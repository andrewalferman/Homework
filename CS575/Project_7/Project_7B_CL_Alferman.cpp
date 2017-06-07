#include <omp.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#ifdef WIN32
  #include <windows.h>
#else
  #include <unistd.h>
#endif

#include "cl.h"
#include "cl_platform.h"

#ifndef SIZE
  #define SIZE   32768
#endif

// 57 was used here because this script is intended to be run on rabbit

#ifndef NUMT
  #define NUMT 57
#endif

// A local size of 128 seemed to work well in project 6

#ifndef LOCAL_SIZE
  #define	LOCAL_SIZE		128
#endif

const char *			CL_FILE_NAME = { "Project_7B.cl" };
const float			TOL = 0.0001f;

void				Wait( cl_command_queue );
int				LookAtTheBits( float );

float Array[2*SIZE];
float  Sums[1*SIZE];
float  SumsMP[1*SIZE];
float  SumsCL[1*SIZE];

int main ( int argc, char *argv[ ] )
{
  //Ensure OpenMP is installed and return an error if it is not
  #ifndef _OPENMP
    fprintf( stderr, "OpenMP is not supported here -- sorry.\n" );
    return 1;
  #endif

  // see if we can even open the opencl kernel program
	// (no point going on if we can't):

	FILE *fp;
#ifdef WIN32
	errno_t err = fopen_s( &fp, CL_FILE_NAME, "r" );
	if( err != 0 )
#else
	fp = fopen( CL_FILE_NAME, "r" );
	if( fp == NULL )
#endif
	{
		fprintf( stderr, "Cannot open OpenCL source file '%s'\n", CL_FILE_NAME );
		return 1;
	}

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

  printf("Shift,Serial,OpenMP,OpenCL\n");

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

  // CPU SIMD will be done in a different file due to lack of rabbit support

  // Using OpenCL

  cl_int status;		// returned status from opencl calls
        // test against CL_SUCCESS

	// 1. get the platform and device ids:
  // get the platform id:

  cl_platform_id platform;
  status = clGetPlatformIDs( 1, &platform, NULL );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clGetPlatformIDs failed (2)\n" );

  // get the device id:

  cl_device_id device;
  status = clGetDeviceIDs( platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clGetDeviceIDs failed (2)\n" );

	// 2. allocate the host memory buffers:

  float *hArray = new float[ 2*Size ];
  float *hSums  = new float[ 1*Size ];

  // 3. create an opencl context:

	cl_context context = clCreateContext( NULL, 1, &device, NULL, NULL, &status );
	if( status != CL_SUCCESS )
		fprintf( stderr, "clCreateContext failed\n" );

  // 4. create an opencl command queue:

  cl_command_queue cmdQueue = clCreateCommandQueue( context, device, 0, &status );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clCreateCommandQueue failed\n" );

	// 5. allocate the device memory buffers:

  cl_mem dArray = clCreateBuffer( context, CL_MEM_READ_ONLY,  2*Size*sizeof(cl_float), NULL, &status );
  if( status != CL_SUCCESS )
		fprintf( stderr, "clCreateBuffer failed (1)\n" );
  cl_mem dSums  = clCreateBuffer( context, CL_MEM_WRITE_ONLY, 1*Size*sizeof(cl_float), NULL, &status );
  if( status != CL_SUCCESS )
		fprintf( stderr, "clCreateBuffer failed (2)\n" );

  // 6. enqueue the command to write the data from the host buffers to the device buffers:

  status = clEnqueueWriteBuffer( cmdQueue, dArray, CL_FALSE, 0, dataSize, hArray, 0, NULL, NULL );
	if( status != CL_SUCCESS )
		fprintf( stderr, "clEnqueueWriteBuffer failed (1)\n" );

  // 7. read the kernel code from a file:

  fseek( fp, 0, SEEK_END );
  size_t fileSize = ftell( fp );
  fseek( fp, 0, SEEK_SET );
  char *clProgramText = new char[ fileSize+1 ];		// leave room for '\0'
  size_t n = fread( clProgramText, 1, fileSize, fp );
  clProgramText[fileSize] = '\0';
  fclose( fp );
  if( n != fileSize )
    fprintf( stderr, "Expected to read %d bytes read from '%s' -- actually read %d.\n", fileSize, CL_FILE_NAME, n );

  // create the text for the kernel program:

  char *strings[1];
  strings[0] = clProgramText;
  cl_program program = clCreateProgramWithSource( context, 1, (const char **)strings, NULL, &status );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clCreateProgramWithSource failed\n" );
  delete [ ] clProgramText;

  // 8. compile and link the kernel code:

  const char *options = { "" };
  status = clBuildProgram( program, 1, &device, options, NULL, NULL );
  if( status != CL_SUCCESS )
  {
    size_t size;
    clGetProgramBuildInfo( program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &size );
    cl_char *log = new cl_char[ size ];
    clGetProgramBuildInfo( program, device, CL_PROGRAM_BUILD_LOG, size, log, NULL );
    fprintf( stderr, "clBuildProgram failed:\n%s\n", log );
    delete [ ] log;
  }

  // 9. create the kernel object:

  cl_kernel kernel = clCreateKernel( program, "AutoCorrelate", &status );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clCreateKernel failed\n" );

  // 10. setup the arguments to the kernel object:

  status = clSetKernelArg( kernel, 0, sizeof(cl_mem), &dArray );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clSetKernelArg failed (1)\n" );
  status = clSetKernelArg( kernel, 1, sizeof(cl_mem), &dSums  );
  if( status != CL_SUCCESS )
    fprintf( stderr, "clSetKernelArg failed (2)\n" );

  // 11. enqueue the kernel object for execution:

  size_t globalWorkSize[3] = { Size,         1, 1 };
  size_t localWorkSize[3]  = { LOCAL_SIZE,   1, 1 };

  Wait( cmdQueue );

  status = clEnqueueNDRangeKernel( cmdQueue, kernel, 1, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL );
	if( status != CL_SUCCESS )
		fprintf( stderr, "clEnqueueNDRangeKernel failed: %d\n", status );

	Wait( cmdQueue );

	// 12. read the results buffer back from the device to the host:

  status = clEnqueueReadBuffer( cmdQueue, dSums, CL_TRUE, 0, dataSize, hSums, 0, NULL, NULL );
	if( status != CL_SUCCESS )
			fprintf( stderr, "clEnqueueReadBuffer failed\n" );

  // The work is done, so we might as well get the time
  double time3 = omp_get_wtime( );

  #ifdef WIN32
    Sleep( 2000 );
  #endif

  // Print out the values obtained for the signal

  for ( int i = 0; i < Size; i++ )
  {
    printf("%d,%10.3lf,%10.3lf,%10.3lf\n", i, Sums[i], SumsMP[i], hSums[i]);
  }

  // 13. clean everything up:

  clReleaseKernel(        kernel   );
	clReleaseProgram(       program  );
	clReleaseCommandQueue(  cmdQueue );
	clReleaseMemObject(     dArray  );
	clReleaseMemObject(     dSums  );

  delete [ ] hArray;
  delete [ ] hSums;

  // Calculate computational speed

  float SpeedSerial = Size / (time1-time0) / 1000;
  float SpeedOpenMP = Size / (time2-time1) / 1000;
  float SpeedCL = Size / (time3-time2) / 1000;

  // Print out the speeds

  printf("KiloCorrels/sec,%10.3f,%10.3lf,%10.3lf\n", SpeedSerial,SpeedOpenMP,SpeedCL);

  return 0;
}
