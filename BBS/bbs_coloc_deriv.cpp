/* bbs_coloc_deriv.cpp
 *
 * Mex entry point for the function that builds the colocation matrix.
 * See bbs_coloc_deriv.m for documentation.
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
 * prhs[1]: u
 * prhs[2]: v
 * prhs[3]: du
 * prhs[4]: dv
 * plhs[0]: (sparse) colocation matrix. */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    bbs_t bbs;
    double *u = NULL, *v = NULL;
    int du, dv;
    int nb_u, nb_v;
    double *pr;
    mwIndex *ir, *jc;

    // INPUT ARGUMENTS
    if (nrhs != 5) 
        mexErrMsgTxt("Five inputs required.");
    
    // No need to check "prhs[0]" for validity since it is done in "array_to_bbs"
    array_to_bbs(prhs[0], &bbs);

    // Check u and v
    check_real(prhs[1], "u");
    check_real(prhs[2], "v");
    nb_u = mxGetNumberOfElements(prhs[1]);
    nb_v = mxGetNumberOfElements(prhs[2]);
    if (nb_u != nb_v)
        mexErrMsgTxt("'u' and 'v' must have the same number of elements.");

    u = mxGetPr(prhs[1]);
    v = mxGetPr(prhs[2]);
    
    // Check du and dv
    check_real_scalar(prhs[3], "du");
    check_real_scalar(prhs[4], "dv");
    du = (int)mxGetScalar(prhs[3]);
    dv = (int)mxGetScalar(prhs[4]);

    // OUTPUT ARGUMENTS
    if (nlhs != 1) 
        mexErrMsgTxt("One output required.");
    plhs[0] = mxCreateSparse(nb_u, bbs.nptsu*bbs.nptsv, 16*nb_u, mxREAL);
    pr = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);
    
    // ACTUAL EVALUATION
    switch (coloc_deriv(&bbs, u, v, nb_u, du, dv, pr, ir, jc)) {
        case 1: mexErrMsgTxt("A colocation site was outside of the spline definition domain.");
    }
}
