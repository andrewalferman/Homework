#!/bin/bash

rm simd.p5.out

g++ -c simd.p5.cpp -o simd.p5.out

echo Run, ARRAYSIZE, MegaMults

listsizes="1000 2000 4000 8000 10000 20000 400000 80000 160000 250000 500000 750000 1000000 2000000 4000000 6000000 8000000 10000000 16000000 24000000 32000000"

for i in $listsizes; do
  g++ -DARRAYSIZE=$i arraymult.cpp -o arraymult.out -lm -fopenmp
  ./arraymult.out
  rm arraymult.out
done

for i in $listsizes; do
  g++ -DARRAYSIZE=$i arraymult_sum.cpp -o arraymult_sum.out -lm -fopenmp
  ./arraymult_sum.out
  rm arraymult_sum.out
done

for i in $listsizes; do
  g++ -DARRAYSIZE=$i arraymult_SIMD.cpp simd.p5.out -o arraymult_SIMD.out -lm -fopenmp
  ./arraymult_SIMD.out
  rm arraymult_SIMD.out
done

for i in $listsizes; do
  g++ -DARRAYSIZE=$i arraymult_sum_SIMD.cpp simd.p5.out -o arraymult_sum_SIMD.out -lm -fopenmp
  ./arraymult_sum_SIMD.out
  rm arraymult_sum_SIMD.out
done
