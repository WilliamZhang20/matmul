cmake_minimum_required(VERSION 3.10)

project(MATMUL)

set(CMAKE_C_FLAGS "-O3 -march=native -mno-avx512f -fopenmp")
set(CMAKE_EXPORT_COMPILE_COMMANDS True)

include_directories("${PROJECT_SOURCE_DIR}/src")
add_subdirectory("${PROJECT_SOURCE_DIR}/src")

option(TEST_TUT "testing tutorial benchmark" OFF)
if(TEST_TUT)
    add_compile_definitions(TEST_TUT)
endif(TEST_TUT)

add_executable(test_matmul test.c)

add_executable(benchmark benchmark_impl.c)

list(APPEND MATMUL_LIBS -lm -lpthread)
target_link_libraries(test_matmul PUBLIC matmul ${MATMUL_LIBS})
target_link_libraries(benchmark PUBLIC matmul ${MATMUL_LIBS})