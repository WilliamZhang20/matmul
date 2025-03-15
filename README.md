# Fast Matrix Multiplication

Fast matrix multiplication on a CPU between two matrices.

Primarily followed [this](https://salykova.github.io/matmul-cpu) guide by [Aman Salykov](https://github.com/salykova), with the addition of the Intel intrinsic subroutine for prefetching memory to speed up memory access.

A summary of techniques for accelerating over the naive implementation:
1. Processing matrices in blocks, also computationally known as "kernels", which improves locality and enables parallelization
2. Using Intel AVX extended instruction set to exploit the processor's SIMD capabilities. This involved loading data into vector registers for simultaneous processing during Fused-Multiply-Add (FMA) operations, in which it computes the dot product vectors of first and second matrices A and B, and adds that to the result C.
3. Cache blocking to optimize memory access by arranging matrix division into blocks that fit within levels of the processor caches (L1, L2, and L3), thereby increasing data reuse and reducing memory latency.
4. Multi-threading using the OpenMP (Open Multi-Processing) library to distribute kernel operations over process cores 
5. The addition of memory prefetching, to fetch data into the cache before it's requested, thereby reducing memory latency and improving processor performance.

## Resources

[OpenMP Guide](https://www.openmp.org/wp-content/uploads/omp-hands-on-SC08.pdf)

[Intel SIMD Intrinsincs](https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html)