#pragma once

void matmul(float* A, float* B, float* C, const int m, const int n, const int k);

// old = tutorial's final implementation = new benchmark
void matmul_old(float* A, float* B, float* C, const int m, const int n, const int k);
void matmul_naive(float* A, float* B, float* C, const int m, const int n, const int k);