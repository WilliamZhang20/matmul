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

#define MC (16 * NTHREADS * 5)
#define NC (6 * NTHREADS * 50)
#define KC 500

static float blockA_packed[MC * KC] __attribute__((aligned(64)));
static float blockB_packed[NC * KC] __attribute__((aligned(64)));

void matmul(float* A, float* B, float* C, int m, int n, int k) {
    memset(C, 0, m * n * sizeof(float));
    for (int j = 0; j < n; j += NC) {
        int nc = min(NC, n - j);
        for (int p = 0; p < k; p += KC) {
            int kc = min(KC, k - p);
            pack_blockB(&B[j * k + p], blockB_packed, nc, kc, k);
            for (int i = 0; i < m; i += MC) {
                int mc = min(MC, m - i);
                pack_blockA(&A[p * m + i], blockA_packed, mc, kc, m);
#pragma omp parallel for collapse(2) num_threads(NTHREADS)
                for (int ir = 0; ir < mc; ir += 16) {
                    for (int jr = 0; jr < nc; jr += 6) {
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