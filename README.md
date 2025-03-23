# Fast Matrix Multiplication

Fast matrix multiplication on a CPU between two matrices.

Primarily followed [this](https://salykova.github.io/matmul-cpu) guide by [Aman Salykov](https://github.com/salykova), with the addition of memory prefetching to speed up data access.

Also changed testing scripts from Bash to Python (since I'm on Windows), and benchmarked the tutorial rather than OpenBLAS.

## Overview

The list of techniques used to accelerate matrix multiplication is:

1. Processing matrices in blocks, also computationally known as "kernels", which improves locality and enables parallelization
2. Using Intel AVX extended instruction set to exploit the processor's SIMD capabilities. This involved loading data into vector registers for simultaneous processing during Fused-Multiply-Add (FMA) operations, in which it computes the dot product vectors of first and second matrices A and B, and adds that to the result C.
3. Cache blocking to optimize memory access by arranging matrix division into blocks that fit within levels of the processor caches (L1, L2, and L3), thereby increasing data reuse and reducing memory latency.
4. Multi-threading using the OpenMP (Open Multi-Processing) library to distribute kernel operations over process cores 
5. The addition of memory prefetching, to fetch data into the cache before it's requested, thereby reducing memory latency and improving processor performance.

For more info, a map of contents below:
- [Mathematical Definitions](#mathematical-definitions)
- [Kernel Optimizations](#kernel-optimizations)
- [Caching Optimization](#caching-optimization)
- [Multithreading](#multithreading)
- [Memory Prefetching](#memory-prefetching)
- [Sources](#sources)
- [Usage](#usage)
- [Results](#results)

Key compiler flags used: 
`-O3 -march=native -mno-avx512f -fopenmp`

In which:
 - `-O3` applies maximum aggressive compiler optimization, which includes reordering instructions, vectorization, and loop unrolling.
 - `march=native` applies machine-specific optimization - which may give it a boost compared to instructions for generic machine cache/register file sizes.
 - `mno-avx512f` disables ultra wide 512-bit AVX vector instructions - to ensure that we remain in the domain of only 256-bit wide AVX2, since AVX512 is generally very exothermic.
- `-fopenmp` enables the use of OpenMP (Open Multiprocessing) library handling at compile time.

## Mathematical Definitions:

The program multiplies two matrices: an M x K matrix A, and a K x N matrix B. The result matrix C is M x N. 

The general standard formula for *one element of C* is $$C_{ij} = \sum_{k=1}^{n} A_{ik} B_{kj}$$

Here we will treat matrix multiplication for the *entire matrix C* as a sum of outer products, which will be:

$$ C = \sum_{k=1}^{n} a_k \otimes b_k^T $$ 

- where $$a_k$$ is the k-th column of A, and $${b_k}^T$$ is the k-th row of B. 

This is 2K floating point operations (FLOP) per element of matrix C, or in other words, this is a $$2KMN$$ FLOP operation. If done naively.

To perform parallelized block multiplication, the matrix product C will be divided into subproblems of shape $$m_R \times n_R $$, which is called a *kernel*. The subscript R will stand for registers - this will be obvious soon.

## Kernel Optimizations

To calculate all elements in the kernel submatrix, we multiply a submatrix in A of size $$m_R \times K$$ by a submatrix in B of size $$K \times n_R$$. 

The old-fashioned way calculates the kernel multiplication by fetching $$2K{m_R}{n_R}$$ elements from the kernel sections of A and B. 

Alternatively, we can take advantage of the Single Instruction, Multiple Data (SIMD) vector processors present in the vast majority of computer cores today. 

They are carried out by specialized vector processors, which are equipped with vector registers (that store vectors) and perform “vector” instructions between vector registers over their entire width. This data parallelism is useful for operations such as inner and outer products, which are ubiquitous in linear algebra.

For us to accelerate operations on SIMD hardware we use Advanced Vector Extensions (AVX) to the x86 ISA that manipulate these registers. In AVX2 extensions on my PC, there are 16 256-bit wide registers of this kind, and they are called YMM registers.

A 256-bit wide register also translates into holding 8 floats, or simply 8 matrix elements. 

We will perform outer products between columns of an A submatrix $$\overline{A}$$ and rows of a B submatrix $$\overline{B}$$, each of which will add to every element in the output kernel matrix.

This will consist of element-wise products between columns of A and broadcasted vectors of single elements from the corresponding rows of submatrix B. See the diagram below sourced from the original guide. Then, the results of all those products are added into the same matrix.

![image](https://github.com/user-attachments/assets/3b4e7d9a-9eeb-40f3-8780-86515fe250bc)

Getting the operands into YMM registers is done by loading the column of $$\overline{A}$$ into a register using `_mm256_loadu_ps`, and broadcasting an element of a row of $$\overline{B}$$ into a register (where every element in the register is that same number) using `_mm256_broadcast_ss`. The kernel matrix $$\overline{C}$$ is also pre-loaded into 12 YMM registers - and it will accumulate outer product results.

Once loaded, the two vector registers will be element-wise multiplied, with the result added to *a column* of the matrix $$\overline{C}$$ in a single instruction of the `_mm256_fmadd_ps` function.

The above is repeated for all $$n_R$$ elements in the row vector of $$\overline{B}$$, to yield the completed outer product between a column of $$\overline{A}$$ and a row of $$\overline{B}$$ - which is a matrix.

Then *all that* is repeated $$K$$ times over all remaining of the $$K$$ columns of the submatrix of A.

This procedure can be summarized in: load $$\overline{C}$$ matrix, load a column of $$\overline{A}$$, broadcast load a $$\overline{B}$$ row element, fused-multiply add, repeat for the rest of the row of $$\overline{B}$$, repeat for the rest of $$\overline{A}$$.

The interpretation of matrix products using outer products enables the use of SIMD extensions, since it will allow us to go: vectors $$\rightarrow$$ operations $$\rightarrow$$ another vector, rather than reducing it to just a scalar - and repeating unnecessarily.

Since there are only 8 floats in a single YMM register - which is the SIMD width, we have kept the kernel matrix C to be a 16x6 matrix, so $$m_R = 16$$ (a constant multiple of 8) and $$n_R = 6$$ (by choice).

To then cover the entirety of the matrix C, we iterate over its rows and columns by strides (aka hops) of the size of the kernel, which are of course $$m_R$$ and $$n_R$$.

TODO: A diagram to show kernels in the original matrix

**But what if the matrix dimensions are not a multiple of the kernel dimensions?**

Clearly, then the kernel matrix cover would overshoot the operand matrix. So some register loads will need to be zeroed out. We do this with bitmasks. They are dependent on the number of rows in the matrix `m`, and if the kernel overshoots, the elements in overlapping addresses (with undefined values) will be ignored.

This is done by defining a base mask, which is equal to `0xFFFF` in hex - or in other words, 16 ones. This is shifted out to a mask vector where the i’th element allows the matrix kernel’s ith element to be turned on/off.

For overshoots, i.e. the bit mask has not been shifted to a multiple of 16, then some elements in the 16-row buffer for $$\overline{C}$$’s registers will be zeroed out, as the locations of the `1` are out of our 16-element view.

In other words, values of $$\overline{C}$$ are masked so that the lower `m` indices of the register contain the elements from the kernel, while the upper overshoot space is zeroed out.

TODO: A diagram to show the above!

The order of packing overall will go like:

```
for (int i = 0; i < M; i += MR) {
     const int m = min(MR, M - i);
     pack_blockA(&A[i], blockA_packed, m, M, K);
     for (int j = 0; j < N; j += NR) {
        const int n = min(NR, N - j);
        pack_blockB(&B[j * K], blockB_packed, n, N, K);
        kernel_16x6(blockA_packed, blockB_packed, &C[j * M + i], m, n, M, N, K);
    }
}
```

## Caching Optimization

The code was shown above to demonstrate that it is *not* a good use of cache space. Why? See below.

In the nested loops, large chunks of the matrices A and B are accessed, which brings them into the cache space. 

However, assuming a common LRU-type cache replacement policy, loading a very large block of B could evict the A submatrix if both matrices' sizes were substantial. This would likely happen pretty frequently since cache space is not very big compared to RAM. 

The eviction of a block $$\overline{A}$$ would mean later accesses would have to fetch the data from RAM after a miss and bring it into the cache again, introducing latency to the procedure.

To address this shortcoming, we adjust the looping pattern of the algorithm to break down the data into smaller chunks to fit in the cache, which are much faster than main memory. This technique ultimately improves both temporal and spatial locality, and is known as **cache blocking**. 

This is done by dividing the matrix into smaller blocks that fit into different levels of the CPU cache (L1, L2, etc.), by using more layers of loops. By keeping these blocks in cache rather than accessing DRAM, we minimize cache misses and reduce memory bandwidth bottlenecks, but most importantly, maximize **reuse** of data for rank-1 updates, a.k.a. outer products.

At the highest level, we divide our resulting m x n matrix $$C$$ into blocks $$C_j$$ of size $$M \times n_c$$ and B into blocks $$B_j$$  of size $$K \times n_c$$. C means cache, and $$n_c$$ is a number by choice. That's the biggest repeated of a matrix that is handled.

Then, in the second layer (i.e. second outermost loop) we iterate over K, dividing matrix $$A$$ into portion indexed $$A_p$$ of size $$M \times k_c$$. Since B also has a dimension on K, this divides it into submatrices $$B_p$$ of size $$k_c \times n_c$$ - both dimensions of which are constant. So if the matrix size isn't proportional to that, then we have to pad it with zeros. Note subscript p stands for "packed."

In the third layer we iterate over M, dividing $$C_j$$ into $$C_i$$ of size $$m_c \times n_c$$ and $$A_p$$ into $$A_j$$ of size $$m_c \times k_c$$ - also a constant dimension which need to be filled by extra zeros.

We structure our approach such that the same $$B_p$$ block is reused across multiple $$A_j$$ blocks from a single $$A_p$$ block. So it is more optimal for memory access (and given the cache access paterns) that the bigger $$B_p$$ stays in higher level L3 cache, while $$A_j$$ stays in a smaller, chip-level L2 cache.

In the 4th (highest) layer (or 2nd lowest loop), we iterate over the preset $$m_c$$ dimension, breaking up $$A_j$$ into sections that are $$m_R \times k_c$$. Intuitively, this is our kernel-size matrix of 'multiple columns of A' lined up horizontally - recall from the 'kernel optimization' section. :smile:

In the 5th layer (i.e. innermost loop), we iterate over the $$n_c$$ dimension, obtaining our atomic blocks of size $$k_c \times n_R$$. This can also be thought of as "rows of a B submatrix" stacked up vertically.

Finally, we take the most atomic $$ m_R \times n_R $$ kernel unit extracted by the five layers of loops, and pass it to the computation kernel.

## Multithreading

For our penultimate optimization technique, we can see many operations listed above are composed of for loops containing independent operations.

To accelerate this, we distribute the iterations of the loops among multiple threads, using the OpenMP library.

This enables us to distribute the operations among multiple cores, rather than a single core doing all the work. 

We primarily did this with for loops like the code below:

```
#pragma omp parallel for num_threads(NTHREADS)
    for (int j = 0; j < nc; j += NR)
```

Another useful keyword used is `collapse(N)` which is generally placed after the `for` word. this can merge `N` nested loop into a *single* loop, allowing us to keep threads busy so we are not wasting cores. 

## Memory Prefetching

A technique to reduce memory latency for loading by fetching it before it is used, knowing that it will be used.

## Sources

[OpenMP Guide](https://www.openmp.org/wp-content/uploads/omp-hands-on-SC08.pdf)

[Intel SIMD Intrinsincs Guide](https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html)

[Cache Blocking](https://www.intel.com/content/www/us/en/developer/articles/technical/cache-blocking-techniques.html).

[Intel Cacheability Intrinsics](https://www.intel.com/content/www/us/en/docs/cpp-compiler/developer-guide-reference/2021-8/cacheability-support-intrinsics-002.html)

## Usage

To get started using the programs inside:
- First and foremost, keep other processes to the minimum. Matrix multiplication is expensive, especially on Windows.
- For testing the tutorial implementation speeds, run from the repository directory, `python scripts/benchmark_tutorial.py`. It will set `#define TEST_TUT` to be true in the CMake build file option.
- For testing my implementation speed, run from repo, `python scripts/benchmark_curr.py`.
- When finished the two steps above, one can plot & compare the FLOPS performance of both by running `plot_benchmark.py`.
- To run matrix multiplication yourself & test out everything, build CMake yourself and run the `test_matmul` executable in the build directory.

## Results

A benchmark comparing my additions of optimizations after multithreading to the original guide. The graph shows *peak* FLOPS.

![benchmark](https://github.com/user-attachments/assets/754d60eb-e4b5-4f48-aad8-88483ec77ca4)
