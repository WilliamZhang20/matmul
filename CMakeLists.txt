cmake_minimum_required(VERSION 3.10)

project(MATMUL)

set(CMAKE_C_FLAGS "-O3 -march=native -mno-avx512f -fopenmp")

include_directories("${PROJECT_SOURCE_DIR}/src")
add_subdirectory(src)

add_executable(test_matmul test.c)