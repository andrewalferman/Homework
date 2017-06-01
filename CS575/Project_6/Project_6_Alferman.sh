#!/bin/bash

echo NMB, LOCAL_SIZE, NUM_WORK_GROUPS, GigaCalcPerSecond

localsizes="8 16 32 64 96 128 192 256 384 512"
numbers="1 2 4 8 16 32 64 128 256 512 1024 2048 3072 4096 6144 8192"

# Array Multiply
for i in $localsizes; do
  for j in $numbers; do
    g++ -DLOCAL_SIZE=$i -DNMB=$j -o first first.cpp /scratch/cuda-7.0/lib64/libOpenCL.so -lm -fopenmp
    ./arraymult.out
    rm arraymult.out
  done
done

# Array Multiply-Add
for i in $localsizes; do
  for j in $numbers; do
    g++ -DLOCAL_SIZE=$i -DNMB=$j -o first first.cpp /scratch/cuda-7.0/lib64/libOpenCL.so -lm -fopenmp
    ./arraymult.out
    rm arraymult.out
  done
done

# Array Multiply+Reduce
#for i in $localsizes; do
#  for j in $numbers; do
#    g++ -DLOCAL_SIZE=$i -DNMB=$j -o first first.cpp /scratch/cuda-7.0/lib64/libOpenCL.so -lm -fopenmp
#    ./arraymult.out
#    rm arraymult.out
#  done
#done
