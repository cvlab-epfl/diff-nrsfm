/* bbs_normalize.cpp
 *
 * Mex entry point for the function normalizing values.
 * See bbs_normalize.m for documentation.
 *
 * History
 *  2009/??/??: First version
 *  2010/12/15: Translation to CPP
 *              Adding OpenMP support
 *
 * (c)2009-2010, Florent Brunet.
 */
 
 /*
 * BBS is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * BBS is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#include "mex.h"
#include "bbs_mex.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double xmin, xmax;
    int npts;
    double *x = NULL, *nx = NULL;
    int *inter = NULL;
    int nb_x;
    mwSize ndim_x;
    const mwSize *dim_x;
    
    if (nrhs != 4) 
        mexErrMsgTxt("Four inputs required.");
    
    if (nlhs < 1 || nlhs > 2) 
        mexErrMsgTxt("One or two outputs required.");
    
    check_real_scalar(prhs[0], "xmin");
    check_real_scalar(prhs[1], "xmax");
    check_real_scalar(prhs[2], "npts");
    
    xmin = mxGetScalar(prhs[0]);
    xmax = mxGetScalar(prhs[1]);
    npts = (int)mxGetScalar(prhs[2]);
    x = mxGetPr(prhs[3]);
    nb_x = mxGetNumberOfElements(prhs[3]);
    ndim_x = mxGetNumberOfDimensions(prhs[3]);
    dim_x = mxGetDimensions(prhs[3]);
    
    plhs[0] = mxCreateNumericArray(ndim_x, dim_x, mxDOUBLE_CLASS, mxREAL);
    nx = mxGetPr(plhs[0]);
    
    if (nlhs == 2) {
        plhs[1] = mxCreateNumericArray(ndim_x, dim_x, mxINT32_CLASS, mxREAL);
        inter = (int*)mxGetData(plhs[1]);
        normalize_with_inter(xmin, xmax, npts, x, nb_x, nx, inter);
    } else
        normalize(xmin, xmax, npts, x, nb_x, nx);
}
