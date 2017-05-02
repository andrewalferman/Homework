#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

//Preprocessing variables
//Setting thread number and number of nodes if it's not given to the cmd line
#ifndef NUMT
  #define NUMT            4
#endif
#ifndef ARRAYSIZE
  #define ARRAYSIZE       32768
#endif
#ifndef DYNAM
  #define DYNAM           0
#endif
#ifndef CHUNKSIZE
  #define CHUNKSIZE       1
#endif

float Array[ARRAYSIZE];

//Random number function
float
Ranf( float low, float high )
{
	float r = (float) rand();		// 0 - RAND_MAX
	return(   low  +  r * ( high - low ) / (float)RAND_MAX   );
}

int
main( )
{
  //Ensure OpenMP is installed and return an error if it is not
  #ifndef _OPENMP
          fprintf( stderr, "OpenMP is not supported here -- sorry.\n" );
          return 1;
  #endif

  double time0 = omp_get_wtime( );

  omp_set_num_threads( NUMT );

  float prod;

  if(DYNAM == 1)
  {
    #pragma omp parallel for default(none), shared(Array), private(prod), schedule(dynamic, CHUNKSIZE)
    for(int i = 0; i < ARRAYSIZE; i++)
    {
      prod = 1;
      Array[i] = Ranf(-1.f, 1.f);
      for(int j = 0; j < i; j++)
      {
        prod *= Array[j];
      }
    }
  }
  else if(DYNAM == 0)
  {
    #pragma omp parallel for default(none), shared(Array), private(prod), schedule(static, CHUNKSIZE)
    for(int i = 0; i < ARRAYSIZE; i++)
    {
      float prod = 1;
      Array[i] = Ranf(-1.f, 1.f);
      for(int j = 0; j < i; j++)
      {
        prod *= Array[j];
      }
    }
  }
  else
  {
    fprintf(stderr, "Set DYNAM to 1 for dynamic or 0 for static scheduling.\n");
    return 1;
  }

  double time1 = omp_get_wtime( );

  //Count of how many multiplications were done:
  long int numMuled = (long int)ARRAYSIZE * (long int)(ARRAYSIZE+1) / 2;

  float mmps = (double)numMuled/(time1-time0)/1000000.;

  printf("%d, %d, %5d, %d, %10.2lf,", NUMT, ARRAYSIZE, CHUNKSIZE, DYNAM, mmps );

return 0;
}
