#!/bin/bash

echo Mode, NKB, LOCAL_SIZE, NUM_WORK_GROUPS, GigaCalcPerSecond

# Note that it will alwasy fail at 96, 192, and 384
localsizes="8 16 32 64 128 256 512"
numbers="1 2 4 8 16 32 64 128 256 512 1024 2048 3072 4096 6144 8192"

# Array Multiply
for i in $localsizes; do
  for j in $numbers; do
    g++ -DLOCAL_SIZE=$i -DNKB=$j -o first first.cpp /scratch/cuda-7.0/lib64/libOpenCL.so -lm -fopenmp
    ./first
    rm first
  done
done

# Array Multiply-Add
for i in $localsizes; do
  for j in $numbers; do
    g++ -DLOCAL_SIZE=$i -DNKB=$j -o first_add first_add.cpp /scratch/cuda-7.0/lib64/libOpenCL.so -lm -fopenmp
    ./first_add
    rm first_add
  done
done

# Array Multiply+Reduce
for i in $localsizes; do
 for j in $numbers; do
   g++ -DLOCAL_SIZE=$i -DNKB=$j -o first_reduction first_reduction.cpp /scratch/cuda-7.0/lib64/libOpenCL.so -lm -fopenmp
   ./first_reduction
   rm first_reduction
 done
done
