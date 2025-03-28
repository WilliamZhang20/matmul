#include <immintrin.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>

#define MEM_ALIGN 64

#define MR 16
#define NR 6

#define MC MR * 64
#define NC NR * 256
#define KC 2000

#ifndef MDIM
    #define MDIM 1000
#endif

#ifndef NDIM
    #define NDIM 1000
#endif

#ifndef KDIM
    #define KDIM 1000
#endif

#ifndef NITER
    #define NITER 100
#endif

#define min(x, y) ((x) < (y) ? (x) : (y))

static float blockA_packed[MC * KC] __attribute__((aligned(MEM_ALIGN)));
static float blockB_packed[NC * KC] __attribute__((aligned(MEM_ALIGN)));
static int8_t mask[32]
    __attribute__((aligned(64))) = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0};

void pack_panelB(float* B, float* blockB_packed, const int nr, const int kc, const int K) {
    for (int p = 0; p < kc; p++) {
        for (int j = 0; j < nr; j++) {
            *blockB_packed++ = B[j * K + p];
        }
        for (int j = nr; j < NR; j++) {
            *blockB_packed++ = 0;
        }
    }
}

void pack_blockB(float* B, float* blockB_packed, const int nc, const int kc, const int K) {
    for (int j = 0; j < nc; j += NR) {
        const int nr = min(NR, nc - j);
        pack_panelB(&B[j * K], &blockB_packed[j * kc], nr, kc, K);
    }
}

void pack_panelA(float* A, float* blockA_packed, const int mr, const int kc, const int M) {
    for (int p = 0; p < kc; p++) {
        for (int i = 0; i < mr; i++) {
            *blockA_packed++ = A[p * M + i];
        }
        for (int i = mr; i < MR; i++) {
            *blockA_packed++ = 0;
        }
    }
}

void pack_blockA(float* A, float* blockA_packed, const int mc, const int kc, const int M) {
    for (int i = 0; i < mc; i += MR) {
        const int mr = min(MR, mc - i);
        pack_panelA(&A[i], &blockA_packed[i * kc], mr, kc, M);
    }
}

void kernel_16x6(float* blockA_packed,
                 float* blockB_packed,
                 float* C,
                 int mr,
                 int nr,
                 int kc,
                 int m) {
    // Instead of having a 16x2 buffer called C
    // Unroll into 12 separate AVX 256-bit vectors
    // This avoid unecessary use of contiguous portions of memory
    // Avoiding register spilling
    __m256 C00 = _mm256_setzero_ps();
    __m256 C10 = _mm256_setzero_ps();
    __m256 C01 = _mm256_setzero_ps();
    __m256 C11 = _mm256_setzero_ps();
    __m256 C02 = _mm256_setzero_ps();
    __m256 C12 = _mm256_setzero_ps();
    __m256 C03 = _mm256_setzero_ps();
    __m256 C13 = _mm256_setzero_ps();
    __m256 C04 = _mm256_setzero_ps();
    __m256 C14 = _mm256_setzero_ps();
    __m256 C05 = _mm256_setzero_ps();
    __m256 C15 = _mm256_setzero_ps();

    __m256 b_packFloat8;
    __m256 a0_packFloat8;
    __m256 a1_packFloat8;
    __m256i packed_mask0;
    __m256i packed_mask1;
    if (mr != 16) {
        // vectorized mask packing => faster!
        packed_mask0 = _mm256_cvtepi8_epi32(_mm_loadu_si64(&mask[16 - mr]));
        packed_mask1 = _mm256_cvtepi8_epi32(_mm_loadu_si64(&mask[16 - mr + 8]));
        switch (nr) {
        case 1 :
            C00 = _mm256_maskload_ps(C, packed_mask0);
            C10 = _mm256_maskload_ps(&C[8], packed_mask1);
            break;
        case 2 :
            C00 = _mm256_maskload_ps(C, packed_mask0);
            C10 = _mm256_maskload_ps(&C[8], packed_mask1);
            C01 = _mm256_maskload_ps(&C[m], packed_mask0);
            C11 = _mm256_maskload_ps(&C[m + 8], packed_mask1);
            break;
        case 3 :
            C00 = _mm256_maskload_ps(C, packed_mask0);
            C10 = _mm256_maskload_ps(&C[8], packed_mask1);
            C01 = _mm256_maskload_ps(&C[m], packed_mask0);
            C11 = _mm256_maskload_ps(&C[m + 8], packed_mask1);
            C02 = _mm256_maskload_ps(&C[2 * m], packed_mask0);
            C12 = _mm256_maskload_ps(&C[2 * m + 8], packed_mask1);
            break;
        case 4 :
            C00 = _mm256_maskload_ps(C, packed_mask0);
            C10 = _mm256_maskload_ps(&C[8], packed_mask1);
            C01 = _mm256_maskload_ps(&C[m], packed_mask0);
            C11 = _mm256_maskload_ps(&C[m + 8], packed_mask1);
            C02 = _mm256_maskload_ps(&C[2 * m], packed_mask0);
            C12 = _mm256_maskload_ps(&C[2 * m + 8], packed_mask1);
            C03 = _mm256_maskload_ps(&C[3 * m], packed_mask0);
            C13 = _mm256_maskload_ps(&C[3 * m + 8], packed_mask1);
            break;
        case 5 :
            C00 = _mm256_maskload_ps(C, packed_mask0);
            C10 = _mm256_maskload_ps(&C[8], packed_mask1);
            C01 = _mm256_maskload_ps(&C[m], packed_mask0);
            C11 = _mm256_maskload_ps(&C[m + 8], packed_mask1);
            C02 = _mm256_maskload_ps(&C[2 * m], packed_mask0);
            C12 = _mm256_maskload_ps(&C[2 * m + 8], packed_mask1);
            C03 = _mm256_maskload_ps(&C[3 * m], packed_mask0);
            C13 = _mm256_maskload_ps(&C[3 * m + 8], packed_mask1);
            C04 = _mm256_maskload_ps(&C[4 * m], packed_mask0);
            C14 = _mm256_maskload_ps(&C[4 * m + 8], packed_mask1);
            break;
        case 6 :
            C00 = _mm256_maskload_ps(C, packed_mask0);
            C10 = _mm256_maskload_ps(&C[8], packed_mask1);
            C01 = _mm256_maskload_ps(&C[m], packed_mask0);
            C11 = _mm256_maskload_ps(&C[m + 8], packed_mask1);
            C02 = _mm256_maskload_ps(&C[2 * m], packed_mask0);
            C12 = _mm256_maskload_ps(&C[2 * m + 8], packed_mask1);
            C03 = _mm256_maskload_ps(&C[3 * m], packed_mask0);
            C13 = _mm256_maskload_ps(&C[3 * m + 8], packed_mask1);
            C04 = _mm256_maskload_ps(&C[4 * m], packed_mask0);
            C14 = _mm256_maskload_ps(&C[4 * m + 8], packed_mask1);
            C05 = _mm256_maskload_ps(&C[5 * m], packed_mask0);
            C15 = _mm256_maskload_ps(&C[5 * m + 8], packed_mask1);
            break;
        }
    } else {
        switch (nr) {
        case 1 :
            C00 = _mm256_loadu_ps(C);
            C10 = _mm256_loadu_ps(&C[8]);
            break;
        case 2 :
            C00 = _mm256_loadu_ps(C);
            C10 = _mm256_loadu_ps(&C[8]);
            C01 = _mm256_loadu_ps(&C[m]);
            C11 = _mm256_loadu_ps(&C[m + 8]);
            break;
        case 3 :
            C00 = _mm256_loadu_ps(C);
            C10 = _mm256_loadu_ps(&C[8]);
            C01 = _mm256_loadu_ps(&C[m]);
            C11 = _mm256_loadu_ps(&C[m + 8]);
            C02 = _mm256_loadu_ps(&C[2 * m]);
            C12 = _mm256_loadu_ps(&C[2 * m + 8]);
            break;
        case 4 :
            C00 = _mm256_loadu_ps(C);
            C10 = _mm256_loadu_ps(&C[8]);
            C01 = _mm256_loadu_ps(&C[m]);
            C11 = _mm256_loadu_ps(&C[m + 8]);
            C02 = _mm256_loadu_ps(&C[2 * m]);
            C12 = _mm256_loadu_ps(&C[2 * m + 8]);
            C03 = _mm256_loadu_ps(&C[3 * m]);
            C13 = _mm256_loadu_ps(&C[3 * m + 8]);
            break;
        case 5 :
            C00 = _mm256_loadu_ps(C);
            C10 = _mm256_loadu_ps(&C[8]);
            C01 = _mm256_loadu_ps(&C[m]);
            C11 = _mm256_loadu_ps(&C[m + 8]);
            C02 = _mm256_loadu_ps(&C[2 * m]);
            C12 = _mm256_loadu_ps(&C[2 * m + 8]);
            C03 = _mm256_loadu_ps(&C[3 * m]);
            C13 = _mm256_loadu_ps(&C[3 * m + 8]);
            C04 = _mm256_loadu_ps(&C[4 * m]);
            C14 = _mm256_loadu_ps(&C[4 * m + 8]);
            break;
        case 6 :
            C00 = _mm256_loadu_ps(C);
            C10 = _mm256_loadu_ps(&C[8]);
            C01 = _mm256_loadu_ps(&C[m]);
            C11 = _mm256_loadu_ps(&C[m + 8]);
            C02 = _mm256_loadu_ps(&C[2 * m]);
            C12 = _mm256_loadu_ps(&C[2 * m + 8]);
            C03 = _mm256_loadu_ps(&C[3 * m]);
            C13 = _mm256_loadu_ps(&C[3 * m + 8]);
            C04 = _mm256_loadu_ps(&C[4 * m]);
            C14 = _mm256_loadu_ps(&C[4 * m + 8]);
            C05 = _mm256_loadu_ps(&C[5 * m]);
            C15 = _mm256_loadu_ps(&C[5 * m + 8]);
            break;
        }
    }
    for (int p = 0; p < kc; p++) {
        a0_packFloat8 = _mm256_loadu_ps(blockA_packed);
        a1_packFloat8 = _mm256_loadu_ps(blockA_packed + 8);

        b_packFloat8 = _mm256_broadcast_ss(blockB_packed);
        C00 = _mm256_fmadd_ps(a0_packFloat8, b_packFloat8, C00);
        C10 = _mm256_fmadd_ps(a1_packFloat8, b_packFloat8, C10);

        b_packFloat8 = _mm256_broadcast_ss(blockB_packed + 1);
        C01 = _mm256_fmadd_ps(a0_packFloat8, b_packFloat8, C01);
        C11 = _mm256_fmadd_ps(a1_packFloat8, b_packFloat8, C11);

        b_packFloat8 = _mm256_broadcast_ss(blockB_packed + 2);
        C02 = _mm256_fmadd_ps(a0_packFloat8, b_packFloat8, C02);
        C12 = _mm256_fmadd_ps(a1_packFloat8, b_packFloat8, C12);

        b_packFloat8 = _mm256_broadcast_ss(blockB_packed + 3);
        C03 = _mm256_fmadd_ps(a0_packFloat8, b_packFloat8, C03);
        C13 = _mm256_fmadd_ps(a1_packFloat8, b_packFloat8, C13);

        b_packFloat8 = _mm256_broadcast_ss(blockB_packed + 4);
        C04 = _mm256_fmadd_ps(a0_packFloat8, b_packFloat8, C04);
        C14 = _mm256_fmadd_ps(a1_packFloat8, b_packFloat8, C14);

        b_packFloat8 = _mm256_broadcast_ss(blockB_packed + 5);
        C05 = _mm256_fmadd_ps(a0_packFloat8, b_packFloat8, C05);
        C15 = _mm256_fmadd_ps(a1_packFloat8, b_packFloat8, C15);

        blockA_packed += 16;
        blockB_packed += 6;
    }
    if (mr != 16) {
        switch (nr) {
        case 1 :
            _mm256_maskstore_ps(C, packed_mask0, C00);
            _mm256_maskstore_ps(&C[8], packed_mask1, C10);
            break;
        case 2 :
            _mm256_maskstore_ps(C, packed_mask0, C00);
            _mm256_maskstore_ps(&C[8], packed_mask1, C10);
            _mm256_maskstore_ps(&C[m], packed_mask0, C01);
            _mm256_maskstore_ps(&C[m + 8], packed_mask1, C11);
            break;
        case 3 :
            _mm256_maskstore_ps(C, packed_mask0, C00);
            _mm256_maskstore_ps(&C[8], packed_mask1, C10);
            _mm256_maskstore_ps(&C[m], packed_mask0, C01);
            _mm256_maskstore_ps(&C[m + 8], packed_mask1, C11);
            _mm256_maskstore_ps(&C[2 * m], packed_mask0, C02);
            _mm256_maskstore_ps(&C[2 * m + 8], packed_mask1, C12);
            break;
        case 4 :
            _mm256_maskstore_ps(C, packed_mask0, C00);
            _mm256_maskstore_ps(&C[8], packed_mask1, C10);
            _mm256_maskstore_ps(&C[m], packed_mask0, C01);
            _mm256_maskstore_ps(&C[m + 8], packed_mask1, C11);
            _mm256_maskstore_ps(&C[2 * m], packed_mask0, C02);
            _mm256_maskstore_ps(&C[2 * m + 8], packed_mask1, C12);
            _mm256_maskstore_ps(&C[3 * m], packed_mask0, C03);
            _mm256_maskstore_ps(&C[3 * m + 8], packed_mask1, C13);
            break;
        case 5 :
            _mm256_maskstore_ps(C, packed_mask0, C00);
            _mm256_maskstore_ps(&C[8], packed_mask1, C10);
            _mm256_maskstore_ps(&C[m], packed_mask0, C01);
            _mm256_maskstore_ps(&C[m + 8], packed_mask1, C11);
            _mm256_maskstore_ps(&C[2 * m], packed_mask0, C02);
            _mm256_maskstore_ps(&C[2 * m + 8], packed_mask1, C12);
            _mm256_maskstore_ps(&C[3 * m], packed_mask0, C03);
            _mm256_maskstore_ps(&C[3 * m + 8], packed_mask1, C13);
            _mm256_maskstore_ps(&C[4 * m], packed_mask0, C04);
            _mm256_maskstore_ps(&C[4 * m + 8], packed_mask1, C14);
            break;
        case 6 :
            _mm256_maskstore_ps(C, packed_mask0, C00);
            _mm256_maskstore_ps(&C[8], packed_mask1, C10);
            _mm256_maskstore_ps(&C[m], packed_mask0, C01);
            _mm256_maskstore_ps(&C[m + 8], packed_mask1, C11);
            _mm256_maskstore_ps(&C[2 * m], packed_mask0, C02);
            _mm256_maskstore_ps(&C[2 * m + 8], packed_mask1, C12);
            _mm256_maskstore_ps(&C[3 * m], packed_mask0, C03);
            _mm256_maskstore_ps(&C[3 * m + 8], packed_mask1, C13);
            _mm256_maskstore_ps(&C[4 * m], packed_mask0, C04);
            _mm256_maskstore_ps(&C[4 * m + 8], packed_mask1, C14);
            _mm256_maskstore_ps(&C[5 * m], packed_mask0, C05);
            _mm256_maskstore_ps(&C[5 * m + 8], packed_mask1, C15);
            break;
        }
    } else {
        switch (nr) {
        case 1 :
            _mm256_storeu_ps(C, C00);
            _mm256_storeu_ps(&C[8], C10);
            break;
        case 2 :
            _mm256_storeu_ps(C, C00);
            _mm256_storeu_ps(&C[8], C10);
            _mm256_storeu_ps(&C[m], C01);
            _mm256_storeu_ps(&C[m + 8], C11);
            break;
        case 3 :
            _mm256_storeu_ps(C, C00);
            _mm256_storeu_ps(&C[8], C10);
            _mm256_storeu_ps(&C[m], C01);
            _mm256_storeu_ps(&C[m + 8], C11);
            _mm256_storeu_ps(&C[2 * m], C02);
            _mm256_storeu_ps(&C[2 * m + 8], C12);
            break;
        case 4 :
            _mm256_storeu_ps(C, C00);
            _mm256_storeu_ps(&C[8], C10);
            _mm256_storeu_ps(&C[m], C01);
            _mm256_storeu_ps(&C[m + 8], C11);
            _mm256_storeu_ps(&C[2 * m], C02);
            _mm256_storeu_ps(&C[2 * m + 8], C12);
            _mm256_storeu_ps(&C[3 * m], C03);
            _mm256_storeu_ps(&C[3 * m + 8], C13);
            break;
        case 5 :
            _mm256_storeu_ps(C, C00);
            _mm256_storeu_ps(&C[8], C10);
            _mm256_storeu_ps(&C[m], C01);
            _mm256_storeu_ps(&C[m + 8], C11);
            _mm256_storeu_ps(&C[2 * m], C02);
            _mm256_storeu_ps(&C[2 * m + 8], C12);
            _mm256_storeu_ps(&C[3 * m], C03);
            _mm256_storeu_ps(&C[3 * m + 8], C13);
            _mm256_storeu_ps(&C[4 * m], C04);
            _mm256_storeu_ps(&C[4 * m + 8], C14);
            break;
        case 6 :
            _mm256_storeu_ps(C, C00);
            _mm256_storeu_ps(&C[8], C10);
            _mm256_storeu_ps(&C[m], C01);
            _mm256_storeu_ps(&C[m + 8], C11);
            _mm256_storeu_ps(&C[2 * m], C02);
            _mm256_storeu_ps(&C[2 * m + 8], C12);
            _mm256_storeu_ps(&C[3 * m], C03);
            _mm256_storeu_ps(&C[3 * m + 8], C13);
            _mm256_storeu_ps(&C[4 * m], C04);
            _mm256_storeu_ps(&C[4 * m + 8], C14);
            _mm256_storeu_ps(&C[5 * m], C05);
            _mm256_storeu_ps(&C[5 * m + 8], C15);
            break;
        }
    }
}

void matmul_cache(float* A, float* B, float* C, const int M, const int N, const int K) {
    for (int j = 0; j < N; j += NC) {
        const int nc = min(NC, N - j);
        for (int p = 0; p < K; p += KC) {
            const int kc = min(KC, K - p);
            pack_blockB(&B[j * K + p], blockB_packed, nc, kc, K);
            for (int i = 0; i < M; i += MC) {
                const int mc = min(MC, M - i);
                pack_blockA(&A[p * M + i], blockA_packed, mc, kc, M);
                for (int jr = 0; jr < nc; jr += NR) {
                    const int nr = min(NR, nc - jr);
                    for (int ir = 0; ir < mc; ir += MR) {
                        const int mr = min(MR, mc - ir);
                        kernel_16x6(&blockA_packed[ir * kc],
                                    &blockB_packed[jr * kc],
                                    &C[(j + jr) * M + (i + ir)],
                                    mr,
                                    nr,
                                    kc,
                                    M);
                    }
                }
            }
        }
    }
}

void matmul_naive(float* A, float* B, float* C, const int M, const int N, const int K) {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            for (int p = 0; p < K; p++) {
                C[j * M + i] += A[p * M + i] * B[j * K + p];
            }
        }
    }
}

void print_mat(float* mat, const int M, const int N) {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            printf("%f ", mat[i * N + j]);
        }
        printf("\n");
    }
    printf("\n");
}

void init_rand(float* mat, const int M, const int N) {
    for (int i = 0; i < M * N; i++) {
        *mat++ = rand() / (float)RAND_MAX;
    }
}

void init_const(float* mat, const float value, const int M, const int N) {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            *mat++ = value;
        }
    }
}

void compare_mats(float* mat1, float* mat2, const int M, const int N) {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            if (fabsf(mat1[j * M + i] - mat2[j * M + i]) > 1e-4) {
                printf("MISMATCH! Element[%d][%d] %f != %f\n",
                       i,
                       j,
                       mat1[j * M + i],
                       mat2[j * M + i]);
                return;
            }
        }
    }
    printf("MATCH!\n");
    return;
}

uint64_t timer() {
    struct timespec start;
    clock_gettime(CLOCK_MONOTONIC, &start);
    return (uint64_t)start.tv_sec * 1000000000 + (uint64_t)start.tv_nsec;
}

int main() {
    const int M = MDIM;
    const int N = NDIM;
    const int K = KDIM;
    float* A = (float*)_mm_malloc(M * K * sizeof(float), MEM_ALIGN);
    float* B = (float*)_mm_malloc(K * N * sizeof(float), MEM_ALIGN);
    float* C = (float*)_mm_malloc(M * N * sizeof(float), MEM_ALIGN);
    float* C_ref = (float*)_mm_malloc(M * N * sizeof(float), MEM_ALIGN);
    init_rand(A, M, K);
    init_rand(B, K, N);

#ifdef TEST
    matmul_naive(A, B, C_ref, M, N, K);
#endif
    double FLOP = 2 * (double)M * N * K;

    for (int i = 0; i < NITER; i++) {
        init_const(C, 0.0, M, N);
        uint64_t start = timer();
        matmul_cache(A, B, C, M, N, K);
        uint64_t end = timer();

        double exec_time = (end - start) * 1e-9;
        double FLOPS = FLOP / exec_time;

        printf("Exec. time = %.3fms\n", exec_time * 1000);
        printf("GFLOPS = %.3f\n", FLOPS / 1e9);
#ifdef TEST
        compare_mats(C, C_ref, M, N);
#endif
        printf("\n");
    }

    _mm_free(A);
    _mm_free(B);
    _mm_free(C);
    _mm_free(C_ref);

    return 0;
}