#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>


float
Ranf( unsigned int *seedp, float low, float high )
{
        float r = (float) rand_r( seedp );              // 0 - RAND_MAX
        printf("%d, %d, %d \n", low, high, r);
        float randomnumber = low  +  r * ( high - low ) / 10.00;
        printf("%d, %d, %d, %d \n", low, high, r, randomnumber);
        printf("(Not) Random number: \n");
        printf("%d \n", rand_r( seedp ));
        return randomnumber;
}

// int
// Ranf( unsigned int *seedp, int ilow, int ihigh )
// {
//         float low = (float)ilow;
//         float high = (float)ihigh + 0.9999f;
//
//         return (int)(  Ranf(seedp, low, high) );
// }


int
main( )
{
  // unsigned int seed = 0;  // a thread-private variable
  // float x = Ranf( &seed, -1.0, 1.0 );
  // printf("%d \n", x );
  float random = rand( );
  printf("%d \n", random);
  return 0;
}
