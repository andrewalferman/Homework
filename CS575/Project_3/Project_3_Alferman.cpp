#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#ifndef NUMT
  #define NUMT           4
#endif
#ifndef NUMPAD
  #define NUMPAD         0
#endif
#ifndef ARRAYSIZE
  #define ARRAYSIZE      4
#endif
#ifndef FIX2
  #define FIX2           0
#endif

int
main( )
{
    //Ensure OpenMP is installed and return an error if it is not
  #ifndef _OPENMP
      fprintf( stderr, "OpenMP is not supported here -- sorry.\n" );
      return 1;
  #endif

  struct s
  {
  	float value;
  	int pad[NUMPAD];
  } Array[ARRAYSIZE];

  double time0 = omp_get_wtime( );

	omp_set_num_threads( NUMT );

	const int SomeBigNumber = 100000000;	// keep < 2B

  if (FIX2 == 0)
  {
  	#pragma omp parallel for
  	for( int i = 0; i < ARRAYSIZE; i++ )
  	{
      unsigned int seed = 0;		// automatically private
      for( unsigned int j = 0; j < SomeBigNumber; j++ )
  		{
  			Array[ i ].value = Array[ i ].value + (float)rand_r( &seed );
  		}
  	}
  }
  else if (FIX2 == 1)
  {
    float sum;
    #pragma omp parallel for default(none), shared(Array), private(sum)
    for( int i = 0; i < ARRAYSIZE; i++ )
  	{
      unsigned int seed = 0;		// automatically private
      for( unsigned int j = 0; j < SomeBigNumber; j++ )
  		{
  			sum = sum + (float)rand_r( &seed );
  		}
      Array[ i ].value = sum;
  	}
  }
  else
  {
    fprintf(stderr, "Set FIX2 to 1 or 0.\n");
    return 1;
  }

  double time1 = omp_get_wtime( );

  //Count of how many multiplications were done:
  long int numAdds = (long int)SomeBigNumber * ARRAYSIZE;

  float MegaAddsPS = (double)numAdds/(time1-time0)/1000000.;

  printf("%d, %d, %d, %10.2lf\n", NUMT, NUMPAD, FIX2, MegaAddsPS );

return 0;

}
