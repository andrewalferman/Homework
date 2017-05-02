#include <stdlib.h>

#ifndef NUMT
  #define NUMT           4
#endif
#ifndef NUMPAD
  #define NUMPAD         0
#endif

struct s
{
	float value;
	int pad[NUMPAD];
} Array[4];

	. . .

	omp_set_num_threads( NUMT );

	const int SomeBigNumber = 100000000;	// keep < 2B

	#pragma omp parallel for
	for( int i = 0; i < 4; i++ )
	{
		for( unsigned int j = 0; j < SomeBigNumber; j++ )
		{
			Array[ i ].value = Array[ i ].value + (float)rand( );
		}
	}
