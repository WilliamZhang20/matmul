#include "matmul.h"
#include "utils.h"
#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char* argv[]) {
    srand(time(NULL));
    int matsize_min = 8;
    int matsize_max = 256;
    int matsize_step = 1;

    if (argc > 3) {
        matsize_min = atoi(argv[1]);
        matsize_max = atoi(argv[2]);
        matsize_step = atoi(argv[3]);
    }
    printf("================\n");
    printf("MINSIZE = %i\nMAXSIZE = %i\nSTEP = %i\n", matsize_min, matsize_max, matsize_step);
    printf("================\n");

    int n_tests = (matsize_max - matsize_min) / matsize_step;
    int n_failed = 0;
    
    double total_time = 0;

    for (int i = 0; i < n_tests; i += 1) {
        int matsize = matsize_min + i * matsize_step;
        int m = matsize, n = matsize, k = matsize;

        float* A = (float*)_mm_malloc(m * k * sizeof(float), 64);
        float* B = (float*)_mm_malloc(n * k * sizeof(float), 64);
        float* C = (float*)_mm_malloc(m * n * sizeof(float), 64);
        float* C_ref = (float*)_mm_malloc(m * n * sizeof(float), 64);
        init_rand(A, m * k);
        init_rand(B, k * n);

        uint64_t start = timer();
        matmul(A, B, C, m, n, k); // fast matrix multiplication
        uint64_t end = timer();
        double exec_time = (end - start) * 1e-9;
        printf("Exec. time = %.3fms\n", exec_time * 1000);
        total_time += exec_time;
        matmul_naive(A, B, C_ref, m, n, k); // reliable reference from looped old matrix multiplication (but naively parallelized with OpenMP)
        
        struct val_data result = validate_mat(C, C_ref, m * n, 1e-4);
        if (result.n_error > 0) {
            n_failed += 1;
            printf("Test #%i: FAILED\n", i + 1);
        } else {
            printf("Test #%i: PASSED\n", i + 1);
        }
        _mm_free(A);
        _mm_free(B);
        _mm_free(C);
        _mm_free(C_ref);
    }
    printf("=====================\n");
    printf("PASSED: %i / %i\n", n_tests - n_failed, n_tests);
    printf("Avg Exec. time =  %.3fms\n", total_time / n_tests * 1000);
}