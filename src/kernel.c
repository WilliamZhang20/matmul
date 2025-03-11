// A 16x16 kernel for matrix multiplication
// Why 16? CPUs that support AVX instructions have 16 YMM registers.

#include "kernel.h"

void kernel_16x6(float* blockA_packed,
    float* blockB_packed,
    float* C,
    int mr,
    int nr,
    int kc,
    int m) {
        __m256 C00;
        __m256 C10;
        __m256 C01;
        __m256 C11;
        __m256 C02;
        __m256 C12;
        __m256 C03;
        __m256 C13;
        __m256 C04;
        __m256 C14;
        __m256 C05;
        __m256 C15;

        __m256 b_packFloat8;
        __m256 a0_packFloat8;
        __m256 a1_packFloat8;
        __m256i packed_mask0;
        __m256i packed_mask1;
}