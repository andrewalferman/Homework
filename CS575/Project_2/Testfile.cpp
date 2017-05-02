#include <omp.h>
#include <stdio.h>
#include <math.h>

//Preprocessing variables
//Setting thread number and number of nodes if it's not given to the cmd line
#ifndef NUMT
  #define NUMT            4
#endif
#ifndef ARRAYSIZE
  #define ARRAYSIZE       32768
#endif
#ifndef SCHED
  #define SCHED           static*
#endif
#ifndef CHUNKSIZE
  #define CHUNKSIZE       1
#endif

int
main( )
{
  omp_set_num_threads( NUMT );
  fprintf( stderr, "Using %d threads\n", NUMT );
  fprintf( stderr, "Using %d x %d array\n", ARRAYSIZE, ARRAYSIZE);

  #pragma omp parallel for default(none), schedule(SCHED, CHUNKSIZE)
  for(int i = 0; i < 2; i++)
  {
    int threadnum = omp_get_thread_num( );
    printf("Thread number: %d \n", threadnum);
    printf("Threads = %d \n", NUMT);
    char out = SCHED;
    printf("Schedule: %s \n", out);
  }

  return 0;
}
