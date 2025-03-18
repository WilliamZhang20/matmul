# Fast Matrix Multiplication

Fast matrix multiplication on a CPU between two matrices.

Primarily followed [this](https://salykova.github.io/matmul-cpu) guide by [Aman Salykov](https://github.com/salykova), with the addition of memory prefetching to speed up data access.

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
- [Cache Blocking](#cache-blocking)
- [Multithreading](#multithreading)
- [Memory Prefetching](#memory-prefetching)
- [Sources](#sources)

Key compiler flags used: `-O3 -march=native -mno-avx512f -fopenmp`

In which:
 - O3 applies maximum aggressive compiler optimization, which includes reordering instructions, vectorization, and loop unrolling.
 - march=native applies machine-specific optimization - which may give it a boost compared to instructions for generic machine cache/register file sizes.
 - `mno-avx512f` disables ultra wide 512-bit AVX vector instructions - to ensure that we remain in the domain of only AVX2, since AVX512 is power hungry.
- fopenmp enables the use of OpenMP (Open Multiprocessing) library handling at compile time.

## Mathematical Definitions

The program multiplies two matrices: an M x K matrix A, and a K x N matrix B. The result matrix C is M x N. 

The general standard formula for one element of C is $$C_{ij} = \sum_{k=1}^{n} A_{ik} B_{kj}$$

Here we will treat matrix multiplication for the entire matrix C as a sum of outer products, which will be:

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

This will consist of element-wise products between columns of A and and broadcasted vectors of single elements from the corresponding rows of submatrix B. Then, the results of all those products are added into the same matrix.

This is done by loading the column of A into a YMM register, broadcasting an element of a row of B into a YMM register (where every element in the register is that same number), and performing a fused-multiply add (FMA) into C. Note that the kernel matrix C is also pre-loaded into 12 YMM registers.

These two vector registers will be element-wise multiplied and added to <u>a column</u> of the matrix C in a single instruction.

The above is done for every element in the row vector B, to yield the completed outer product between a column of A and a row of B. 

Then *all that* is repeated $$K$$ times over all remaining of the $$K$$ columns of the submatrix of A.

This procedure can be summarized in load C matrix, load A column, broadcast load B row, fused-multiply add, repeat for the rest of B, repeat for the rest of A.

## Cache Blocking

## Multithreading

## Memory Prefetching

## Sources

[OpenMP Guide](https://www.openmp.org/wp-content/uploads/omp-hands-on-SC08.pdf)

[Intel SIMD Intrinsincs](https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html)
