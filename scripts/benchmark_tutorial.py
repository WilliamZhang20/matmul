import os
import subprocess
import sys

# Define the parameters
MINSIZE = 200
STEPSIZE = 200
NPTS = 50
WNITER = 5
NITER_START = 1001
NITER_END = 5

# get build directory
build_dir = os.path.join(os.getcwd(), 'build')

# Run CMake to configure the build
cmake_command = [
    'cmake', 
    '-G', 'MinGW Makefiles',  # Use MinGW as the generator
    '-S', os.getcwd(), 
    '-B', build_dir,  # Specify the build directory
    '-DTEST_TUT=ON'
]

subprocess.run(cmake_command, check=True)

# Build the benchmark target
subprocess.run(['mingw32-make', '-C', build_dir, 'benchmark'], check=True)

# Run the benchmark with the specified parameters
benchmark_command = os.path.join(build_dir, 'benchmark')
subprocess.run([benchmark_command, str(MINSIZE), str(STEPSIZE), str(NPTS), str(WNITER), str(NITER_START), str(NITER_END)], check=True)