#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

//Initialize everything
int	NowYear;		// 2017 - 2022
int	NowMonth;		// 0 - 11

float	NowPrecip;		// inches of rain per month
float	NowTemp;		// temperature this month
float	NowHeight;		// grain height in inches
int	NowNumDeer;		// number of deer in the current population

float tempFactor;
float precipFactor;

unsigned int seed;

float tempHeight;
int tempdeer;

int growthmos;

const float GRAIN_GROWS_PER_MONTH =		8.0;
const float ONE_DEER_EATS_PER_MONTH =		0.1;

float AVG_PRECIP_PER_MONTH =		6.0;	// average
const float AMP_PRECIP_PER_MONTH =		6.0;	// plus or minus
const float RANDOM_PRECIP =			2.0;	// plus or minus noise

const float AVG_TEMP =				50.0;	// average
const float AMP_TEMP =				20.0;	// plus or minus
const float RANDOM_TEMP =			10.0;	// plus or minus noise

const float MIDTEMP =				40.0;
const float MIDPRECIP =				10.0;


float
SQR( float x )
{
  return x*x;
}


float
Ranf( unsigned int *seedp, float low, float high )
{
        float r = (float) rand_r( seedp );              // 0 - RAND_MAX

        return(   low  +  r * ( high - low ) / (float)RAND_MAX   );
}

int
Ranf( unsigned int *seedp, int ilow, int ihigh )
{
        float low = (float)ilow;
        float high = (float)ihigh + 0.9999f;

        return (int)(  Ranf(seedp, low,high) );
}


void Watcher( )
{

  while( NowYear < 2023 )
  {
   // compute a temporary next-value for this quantity
   // based on the current state of the simulation:

   // DoneComputing barrier:
   #pragma omp barrier

   // DoneComputing barrier 2:
   #pragma omp barrier

   // DoneAssigning barrier:
   #pragma omp barrier

   printf("%2d, %10d, %10.2f, %10.2f, %10.2f, %10d \n", NowMonth, NowYear, NowTemp,
          NowPrecip, NowHeight, NowNumDeer);

   if (NowMonth < 11)
   {
     NowMonth++;
   }
   else
   {
     NowMonth = 0;
     NowYear++;
   }

   float ang = (  30.*(float)NowMonth + 15.  ) * ( M_PI / 180. );
   float temp = AVG_TEMP - AMP_TEMP * cos( ang );

   NowTemp = temp + Ranf( &seed, -RANDOM_TEMP, RANDOM_TEMP );
   seed++;

   float precip = AVG_PRECIP_PER_MONTH + AMP_PRECIP_PER_MONTH * sin( ang );
   NowPrecip = precip + Ranf( &seed,  -RANDOM_PRECIP, RANDOM_PRECIP );
   seed++;

   if( NowPrecip < 0. )
   	NowPrecip = 0.;

   tempFactor = exp(   -SQR(  ( NowTemp - MIDTEMP ) / 10.  )   );
   precipFactor = exp(   -SQR(  ( NowPrecip - MIDPRECIP ) / 10.  )   );

   // DonePrinting barrier:
   #pragma omp barrier

  }
}


void GrainDeer( )
{
  growthmos = 0;
  while( NowYear < 2023 )
  {
   // compute a temporary next-value for this quantity
   // based on the current state of the simulation:
   if (NowNumDeer <= 0)
   {
     tempdeer = 0;
     growthmos = 0;
   }
   else if (NowNumDeer == 1 and NowNumDeer<NowHeight)
   {
     tempdeer = 1;
     growthmos = 0;
   }
   else if (NowNumDeer < NowHeight)
   {
     tempdeer = NowNumDeer + 1;
     growthmos++;
   }
   else if (NowNumDeer > NowHeight)
   {
     tempdeer = NowNumDeer - 1;
     growthmos = 0;
   }
   else
   {
     tempdeer = NowNumDeer;
     growthmos = 0;
   }

   // DoneComputing barrier:
   #pragma omp barrier
   NowNumDeer = tempdeer;

   // DoneComputing barrier 2:
   #pragma omp barrier

   // DoneAssigning barrier:
   #pragma omp barrier

   // DonePrinting barrier:
   #pragma omp barrier

  }
  return;
}


void Grain( )
{

  while( NowYear < 2023 )
  {
   // compute a temporary next-value for this quantity
   // based on the current state of the simulation:
   tempHeight = NowHeight;
   tempHeight += tempFactor * precipFactor * GRAIN_GROWS_PER_MONTH;
   tempHeight -= (float)NowNumDeer * ONE_DEER_EATS_PER_MONTH;
   if (tempHeight <= 0)
   {
     tempHeight = 0;
   }

   // DoneComputing barrier:
   #pragma omp barrier
   NowHeight = tempHeight;

   // DoneComputing barrier 2:
   #pragma omp barrier

   // DoneAssigning barrier:
   #pragma omp barrier

   // DonePrinting barrier:
   #pragma omp barrier

  }
  return;
}


void Sandworm( )
{
  int monthswithoutstrike = 4;
  while( NowYear < 2023 )
  {
   // compute a temporary next-value for this quantity
   // based on the current state of the simulation:
   AVG_PRECIP_PER_MONTH -= 0.15;

   // DoneComputing barrier:
   #pragma omp barrier
   if (growthmos >= 4 and monthswithoutstrike > 8)
   {
     monthswithoutstrike = 0;
     if (tempdeer > 15)
     {
       tempdeer -= 10;
     }
     else if (tempdeer > 10)
     {
       tempdeer -= 5;
     }
     else if (tempdeer > 5)
     {
       tempdeer -= 2;
     }
     else
     {
       tempdeer -= 1;
     }
     tempHeight -= 5;
   }
   monthswithoutstrike++;

   // DoneComputing barrier 2:
   #pragma omp barrier
   NowNumDeer = tempdeer;
   NowHeight = tempHeight;

   // DoneAssigning barrier:
   #pragma omp barrier

   // DonePrinting barrier:
   #pragma omp barrier

  }
}


int
main( )
{
  //Ensure OpenMP is installed and return an error if it is not
  #ifndef _OPENMP
      fprintf( stderr, "OpenMP is not supported here -- sorry.\n" );
      return 1;
  #endif

  // starting date and time:
  NowMonth =    0;
  NowYear  = 2017;

  // starting state (feel free to change this if you want):
  NowNumDeer = 20;
  NowHeight =  30.;

  float ang = (  30.*(float)NowMonth + 15.  ) * ( M_PI / 180. );
  float temp = AVG_TEMP - AMP_TEMP * cos( ang );
  seed = (unsigned)time(NULL);
  NowTemp = temp + Ranf( &seed, -RANDOM_TEMP, RANDOM_TEMP );
  seed++;
  float precip = AVG_PRECIP_PER_MONTH + AMP_PRECIP_PER_MONTH * sin( ang );
  NowPrecip = precip + Ranf( &seed,  -RANDOM_PRECIP, RANDOM_PRECIP );
  seed++;
  if( NowPrecip < 0. )
   NowPrecip = 0.;

  float tempFactor = exp(   -SQR(  ( NowTemp - MIDTEMP ) / 10.  )   );
  float precipFactor = exp(   -SQR(  ( NowPrecip - MIDPRECIP ) / 10.  )   );

  printf("Month,    Year,      Temp,       Precip,     Height,   NumDeer \n");

  omp_set_num_threads( 4 );	// same as # of sections

  #pragma omp parallel sections
  {
    #pragma omp section
  	{
  		GrainDeer( );
  	}

  	#pragma omp section
  	{
  		Grain( );
  	}

  	#pragma omp section
  	{
  		Watcher( );
  	}

  	#pragma omp section
  	{
  		Sandworm( );	// your own
  	}       // implied barrier -- all functions must return in order
  	// to allow any of them to get past here
  }
  return 0;
}
