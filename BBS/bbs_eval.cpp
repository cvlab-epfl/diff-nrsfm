/* bbs_eval.cpp
 *
 * Mex entry point for the function evaluating a bidimensional b-spline.
 * See bbs_eval.m for documentation.
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
 
#include "bbs_mex.h"
#include "bbs.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    bbs_t bbs;
    double *u = NULL, *v = NULL;
    int nval_u, nval_v;
    int du = 0, dv = 0;
    double *ctrlpts = NULL;
    double *val = NULL;

    
    // INPUT ARGUMENTS
    if (nrhs != 4 && nrhs != 6) 
        mexErrMsgTxt("Four or six inputs required.");
    
    // No need to check "prhs[0]" for validity since it is done in "array_to_bsw"
    array_to_bbs(prhs[0], &bbs);
    
    // prhs[1]: control points
    check_real(prhs[1], "ctrlpts");
    check_bbs_ctrlpts_size(prhs[1], &bbs);
    ctrlpts = mxGetPr(prhs[1]);
    
    // prhs[2] and prhs[3]: u and v
    check_real(prhs[2], "u");
    check_real(prhs[3], "v");
    nval_u = mxGetNumberOfElements(prhs[2]);
    nval_v = mxGetNumberOfElements(prhs[3]);
    if (nval_u != nval_v)
        mexErrMsgTxt("'u' and 'v' must have the same number of elements.");
    u = mxGetPr(prhs[2]);
    v = mxGetPr(prhs[3]);
    
    // prhs[4] and prhs[5]: optional order of derivation dx and dy
    if (nrhs == 6) {
        check_real_scalar(prhs[4], "du");
        check_real_scalar(prhs[5], "dv");
        du = (int)mxGetScalar(prhs[4]);
        dv = (int)mxGetScalar(prhs[5]);
    }
    
    // OUTPUT ARGUMENTS
    // plhs[0] : val
    if (nlhs != 1) 
        mexErrMsgTxt("One output required.");
    plhs[0] = mxCreateDoubleMatrix(bbs.valdim, nval_u, mxREAL);
    val = mxGetPr(plhs[0]);
    
    
    // ACTUAL EVALUATION
    eval(&bbs, ctrlpts, u, v, nval_u, val, du, dv);
}
