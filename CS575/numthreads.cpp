#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>


int
main( )
{
  // omp_set_num_threads(2);
  fprintf( stderr, "Number of available threads is %d\n", omp_get_max_threads( ) );
  fprintf( stderr, "Number of processors is %d\n", omp_get_num_procs( ) );
}
