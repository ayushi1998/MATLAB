#include <stdio.h>
#include <complex>
// For the CUDA runtime routines (prefixed with "cuda_")
#include <cuda_runtime.h>
//#include <helper_functions.h>
#include <mex.h>
#include "gpu/mxGPUArray.h"

#define M_PI 3.1415926535

using namespace std;

#define checkCudaErrors(err)  __checkCudaErrors (err, __FILE__, __LINE__)

inline void __checkCudaErrors(cudaError err, const char *file, const int line )
{
    if(cudaSuccess != err)
    {
        fprintf(stderr, "%s(%i) : CUDA Runtime API error %d: %s.\n",file, line, (int)err, cudaGetErrorString( err ) );
        exit(-1);
    }
}



__device__ double2 complexmul(const double2 a, const double2 b) {
	double2 res;
	res.x = a.x*b.x-a.y*b.y;
	res.y = a.x*b.y+a.y*b.x;
	return res;
}

__device__ double2 complexdiv(const double2 a, const double2 b) {
	double2 res;
	res.x = (a.x * b.x + a.y * b.y) / (b.x*b.x+b.y*b.y);
	res.y = (-a.x * b.y + a.y * b.x) / (b.x*b.x+b.y*b.y);
	return res;
}

__device__ double2 complexlog(const double2 a) {
	double2 res;
	res.x = 0.5 * log(a.x*a.x + a.y*a.y);
	res.y = atan2(a.y, a.x);
	if (res.y + M_PI < 1e-9)
		res.y = M_PI;
	return res;
}

__global__ void
calcCGCoords(const double2* curve, const double2* pts, double2* coords, int M, int N) {

	int j = blockDim.y * blockIdx.y + threadIdx.y;
	int i = blockDim.x * blockIdx.x + threadIdx.x;	

    if (i >= M || j >= N)
        return;

    double2 Aj, Ajp1, Bj, Bjp1, Bjm1;

	Aj.x = curve[j].x - curve[(j + N - 1) % N].x;
	Aj.y = curve[j].y - curve[(j + N - 1) % N].y;

    Ajp1.x = curve[(j + 1) % N].x - curve[j].x;
    Ajp1.y = curve[(j + 1) % N].y - curve[j].y;

	Bj.x = curve[j].x - pts[i].x;
	Bj.y = curve[j].y - pts[i].y;

    Bjp1.x = curve[(j + 1) % N].x - pts[i].x;
	Bjp1.y = curve[(j + 1) % N].y - pts[i].y;

    Bjm1.x = curve[(j + N - 1) % N].x - pts[i].x;
	Bjm1.y = curve[(j + N - 1) % N].y - pts[i].y;

    
    double2 f1 = complexdiv(complexlog(complexdiv(Bj, Bjm1)), Aj);
    double2 f2 = complexdiv(complexlog(complexdiv(Bjp1, Bj)), Ajp1);
    
    coords[j * M + i].x = (f1.y-f2.y) / (2*M_PI);
    coords[j * M + i].y = -(f1.x-f2.x) / (2*M_PI);

}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    mxInitGPU();
    
    mxGPUArray const * A = mxGPUCreateFromMxArray(prhs[0]);
    mwSize n = mxGPUGetNumberOfElements(A);
    double2 const * d_A = (double2 const *)(mxGPUGetDataReadOnly(A));
    
    mxGPUArray const * B = mxGPUCreateFromMxArray(prhs[1]);
    mwSize m = mxGPUGetNumberOfElements(B);
    double2 const * d_B = (double2 const *)(mxGPUGetDataReadOnly(B));
    
    mwSize dims[2] = {m, n};
    mxGPUArray* C = mxGPUCreateGPUArray(2, dims, mxDOUBLE_CLASS, mxCOMPLEX, MX_GPU_DO_NOT_INITIALIZE);
    double2* d_C = (double2*)(mxGPUGetData(C));
    
    dim3 block(32,32);
    dim3 grid((m + block.x - 1) / block.x, (n + block.y - 1) / block.y);
    
    calcCGCoords<<<grid, block>>>(d_A, d_B, d_C, m, n);
    
    plhs[0] = mxGPUCreateMxArrayOnGPU(C);
    
    mxGPUDestroyGPUArray(A);
    mxGPUDestroyGPUArray(B);
    mxGPUDestroyGPUArray(C);
    
}