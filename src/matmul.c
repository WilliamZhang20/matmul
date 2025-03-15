#include <string.h>

inline int min(int x, int y) {
    if(x < y) {
        return x;
    }
    return y;
}

#ifndef NTHREADS
    #define NTHREADS 16
#endif

// Constants to divide the matrix into blocks
// This helps to divide & conquer, which is proven to be faster
#define MC (16 * NTHREADS * 5)  // Size of block in the j-dimension (columns of B)
#define NC (6 * NTHREADS * 50) // Size of block in the p-dimension (rows of A and columns of B)
#define KC 500 // Size of block in the i-dimension (rows of A)

static float blockA_packed[MC * KC] __attribute__((aligned(64))); // buffer for matrix A with memory alignment set for SIMD compatiblity
static float blockB_packed[NC * KC] __attribute__((aligned(64))); // buffer for matrix B with memory alignment set for SIMD compatiblity

void pack_panelB(float* B, float* blockB_packed, int nr, int kc, int k) {
    for (int p = 0; p < kc; p++) {
        for (int j = 0; j < nr; j++) {
            *blockB_packed++ = B[j * k + p];
        }
        for (int j = nr; j < 6; j++) {
            *blockB_packed++ = 0;
        }
    }
}

void pack_blockB(float* B, float* blockB_packed, int nc, int kc, int k) {
#pragma omp parallel for num_threads(NTHREADS)
    for (int j = 0; j < nc; j += 6) {
        int nr = min(6, nc - j);
        pack_panelB(&B[j * k], &blockB_packed[j * kc], nr, kc, k);
    }
}

void pack_panelA(float* A, float* blockA_packed, int mr, int kc, int M) {
    for (int p = 0; p < kc; p++) {
        for (int i = 0; i < mr; i++) {
            *blockA_packed++ = A[p * M + i];
        }
        for (int i = mr; i < 16; i++) {
            *blockA_packed++ = 0;
        }
    }
}

void pack_blockA(float* A, float* blockA_packed, int mc, int kc, int M) {
#pragma omp parallel for num_threads(NTHREADS)
    for (int i = 0; i < mc; i += 16) {
        int mr = min(16, mc - i);
        pack_panelA(&A[i], &blockA_packed[i * kc], mr, kc, M);
    }
}

void matmul(float* A, float* B, float* C, int m, int n, int k) {
    memset(C, 0, m * n * sizeof(float));
    for (int j = 0; j < n; j += NC) {
        int nc = min(NC, n - j);
        for (int p = 0; p < k; p += KC) {
            int kc = min(KC, k - p);
            
            pack_blockB(&B[j * k + p], blockB_packed, nc, kc, k); // cache optimization B

            for (int i = 0; i < m; i += MC) { // 3rd loop from inside - B_p already inside L3 Cache
                int mc = min(MC, m - i);
                
                pack_blockA(&A[p * m + i], blockA_packed, mc, kc, m); // cache optimization A
#pragma omp parallel for collapse(2) num_threads(NTHREADS) // parallelize using OpenMP

                for (int ir = 0; ir < mc; ir += 16) { // 2nd Loop from inside - A inside L2 Cache
                    for (int jr = 0; jr < nc; jr += 6) { // Innermost loop over microkernel, i.e. row of A and column of B
                        
                        // Prefetch the A and B blocks ahead of time for the current stride
                        if (ir + 16 < mc) {
                            __builtin_prefetch(&blockA_packed[(ir + 16) * kc], 0, 3); // Prefetch next row of A
                        }
                        if (jr + 6 < nc) {
                            __builtin_prefetch(&blockB_packed[(jr + 6) * kc], 0, 3); // Prefetch next column of B
                        }

                        int nr = min(6, nc - jr);
                        int mr = min(16, mc - ir);
                        kernel_16x6(&blockA_packed[ir * kc],
                                    &blockB_packed[jr * kc],
                                    &C[(j + jr) * m + (i + ir)],
                                    mr,
                                    nr,
                                    kc,
                                    m);
                    }
                }
            }
        }
    }
}

void matmul_naive(float* A, float* B, float* C, int m, int n, int k) {
#pragma omp parallel for collapse(2) num_threads(NTHREADS)
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            float accumulator = 0;
            for (int p = 0; p < k; p++) {
                accumulator += A[p * m + i] * B[j * k + p];
            }
            C[j * m + i] = accumulator;
        }
    }
}