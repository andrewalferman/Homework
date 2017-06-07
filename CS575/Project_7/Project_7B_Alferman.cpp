#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#include "simd.p5.h"

#ifndef SIZE
  #define SIZE   32768
#endif

// 8 was used here because this script is intended to be run on flip

#ifndef NUMT
  #define NUMT 8
#endif

float Array[2*SIZE];
float  Sums[1*SIZE];
float  SumsMP[1*SIZE];
float  SumsSIMD[1*SIZE];
float  SumsCL[1*SIZE];

int main ()
{
  //Ensure OpenMP is installed and return an error if it is not
  #ifndef _OPENMP
    fprintf( stderr, "OpenMP is not supported here -- sorry.\n" );
    return 1;
  #endif

  // Read the signal file

  FILE *fp = fopen( "signal.txt", "r" );
  if( fp == NULL )
  {
  	fprintf( stderr, "Cannot open file 'signal.txt'\n" );
  	exit( 1 );
  }
  int Size;
  fscanf( fp, "%d", &Size );
  Size = SIZE;

  for( int i = 0; i < Size; i++ )
  {
  	fscanf( fp, "%f", &Array[i] );
  	Array[i+Size] = Array[i];		// duplicate the array
  }
  fclose( fp );

  printf("Shift,Serial,OpenMP,SIMD\n");

  // Non-parallelism method

  double time0 = omp_get_wtime( );

  for( int shift = 0; shift < Size; shift++ )
  {
  	float sum = 0.;
  	for( int i = 0; i < Size; i++ )
  	{
  		sum += Array[i] * Array[i + shift];
  	}
  	Sums[shift] = sum;
  }

  // Using OpenMP

  double time1 = omp_get_wtime( );

  omp_set_num_threads( NUMT );

  float sum;
  #pragma omp parallel for default(none), shared(Array, SumsMP, Size), private(sum)
  for( int shift = 0; shift < Size; shift++ )
  {
  	float sum = 0.;
  	for( int i = 0; i < Size; i++ )
  	{
  		sum += Array[i] * Array[i + shift];
  	}
  	SumsMP[shift] = sum;	// note the "fix #2" from false sharing if you are using OpenMP
  }

  double time2 = omp_get_wtime( );

  // Using CPU SIMD

  for( int shift = 0; shift < Size; shift++ )
  {
    SumsSIMD[shift] = SimdMulSum( &Array[0], &Array[0+shift], Size );
  }

  double time3 = omp_get_wtime( );

  // OpenCL will be done in a different file due to flip not having a GPU

  // Print out the values obtained for the signal

  for ( int i = 0; i < Size; i++ )
  {
    printf("%d,%10.3lf,%10.3lf,%10.3lf\n", i, Sums[i], SumsMP[i], SumsSIMD[i]);
  }

  // Calculate computational speed

  float SpeedSerial = Size / (time1-time0) / 1000;
  float SpeedOpenMP = Size / (time2-time1) / 1000;
  float SpeedSIMD = Size / (time3-time2) / 1000;

  // Print out the speeds

  printf("KiloCorrels/sec,%10.3lf,%10.3lf,%10.3lf\n", SpeedSerial,SpeedOpenMP,SpeedSIMD);

  return 0;
}
