/* bbs_bending_ur.cpp
 *
 * Mex entry point for the function that builds the upper right part of the bending matrix.
 * See bbs_bending_ur.m for documentation.
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

/* prhs[0]: b-spline structure
 * prhs[1]: lambdas
 * plhs[0]: (sparse) colocation matrix. */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    bbs_t bbs;
    double *lambdas;
    double *pr;
    mwIndex *ir, *jc;
    int nu, nv;
    char errstr[128];

    // INPUT ARGUMENTS
    if (nrhs != 2) 
        mexErrMsgTxt("Two inputs required.");
    
    // No need to check "prhs[0]" for validity since it is done in "array_to_bsw"
    array_to_bbs(prhs[0], &bbs);
    nu = bbs.nptsu;
    nv = bbs.nptsv;

    // Check 'lambdas'
    check_real(prhs[1], "lambdas");
    if ((mxGetM(prhs[1]) != (nv-3)) || (mxGetN(prhs[1]) != (nu-3))) {
        sprintf(errstr, "The size of the 'lambdas' matrix must be % x %d.", nv-3, nu-3);
        mexErrMsgTxt(errstr);
    }
    lambdas = mxGetPr(prhs[1]);
    
    
    // OUTPUT ARGUMENTS
    if (nlhs != 1) 
        mexErrMsgTxt("One output required.");
    plhs[0] = mxCreateSparse(nu*nv, nu*nv, 25*nu*nv-42*(nu+nv)+72, mxREAL);
    pr = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);
    
    // ACTUAL COMPUTATION OF THE BENDING MATRIX
    bending_ur(&bbs, lambdas, pr, ir, jc);
}
