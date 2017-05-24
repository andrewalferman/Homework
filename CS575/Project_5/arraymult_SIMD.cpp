#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include "simd.p5.h"

#ifndef ARRAYSIZE
  #define ARRAYSIZE      10000000
#endif

float A[ARRAYSIZE];
float B[ARRAYSIZE];
float C[ARRAYSIZE];

int
main( )
{
  #ifndef _OPENMP
    fprintf( stderr, "OpenMP is not supported here -- sorry.\n" );
    return 1;
  #endif

  double MegaMults;

  double time0 = omp_get_wtime( );

  SimdMul( A, B, C, ARRAYSIZE );

  double time1 = omp_get_wtime( );

  MegaMults = (double)ARRAYSIZE/(time1-time0)/1000000.;

  printf( "Mult SIMD,  %d, %8.2lf \n", ARRAYSIZE, MegaMults );

  return 0;

}
