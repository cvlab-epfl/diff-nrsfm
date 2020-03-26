/* bbs_mex.cpp
 *
 * Mex-dependant routines for cubic b-splines.
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

/* Check whether the mxArray "val" is a real scalar or not. "varname" is a
 string used to identified "val" in the error message. It can be NULL. */
void check_real_scalar(const mxArray *val, char *varname) {
    char str[128];
    if (!mxIsDouble(val) || mxIsComplex(val) || mxGetN(val)*mxGetM(val) != 1) {
        if (varname != NULL) {
            sprintf(str, "Value %s must be a real scalar.", varname);
            mexErrMsgTxt(str);
        } else
            mexErrMsgTxt("Value must be a real scalar.");
    }
}

/* Check if "val" is pure real, not complex (matrix or scalar). */
void check_real(const mxArray *val, char *varname) {
    char str[128];
    if (!mxIsDouble(val) || mxIsComplex(val))
        if (varname != NULL) {
            sprintf(str, "Value %s must be a real scalar.", varname);
            mexErrMsgTxt(str);
        } else
            mexErrMsgTxt("Value must be a real scalar.");
}

/* Check if the matrix of control points has the correct size, given the general parameters of a spline. */
void check_bbs_ctrlpts_size(const mxArray *val, bbs_t *bbs) {
    char errstr[128];
    if (mxGetM(val) != bbs->valdim || mxGetN(val) != bbs->nptsu*bbs->nptsv) {
        sprintf(errstr, "The control points matrix must be of size (%d x %d).", bbs->valdim, bbs->nptsu*bbs->nptsv);
        mexErrMsgTxt(errstr);
    }
}

/* Private function used by "array_to_bbs" to extract one field of type double
 from a bbs structure. The "structureness" of "val" is normally tested in
 "array_to_bbs". */
double get_bbs_field_double(const mxArray *val, char *field) {
    mxArray *a_field = NULL;
    char str[96];
    
    a_field = mxGetField(val, 0, field);
    
    if (a_field) {
        check_real_scalar(a_field, field);
        return mxGetScalar(a_field);
    } else {
        sprintf(str, "'%s': non-existant field.", field);
        mexErrMsgTxt(str);
    }      
}

/* Same as "get_bbs_field_double" but for values of type "int". */
int get_bbs_field_int(const mxArray *val, char *field) {
    mxArray *a_field = NULL;
    char str[96];
    
    a_field = mxGetField(val, 0, field);
    
    if (a_field) {
        check_real_scalar(a_field, field);
        return (int)mxGetScalar(a_field);
    } else {
        sprintf(str, "'%s': non-existant field.", field);
        mexErrMsgTxt(str);
    }      
}

/* Convert a Matlab structure (an mxArray) to a "bbs_t" structure.
   This function also checks for the validity of the matlab structure "val". */
void array_to_bbs(const mxArray *val, bbs_t *bbs) {   
    if (!mxIsStruct(val))
        mexErrMsgTxt("The spline structure is not a structure.");
    
    if (mxGetNumberOfElements(val) != 1)
        mexErrMsgTxt("The spline structure must not be an array of structures.");
    
    if (mxGetNumberOfFields(val) != 7)
        mexErrMsgTxt("The spline structure must contain 7 fields.");
    
    bbs->umin = get_bbs_field_double(val, "umin");
    bbs->umax = get_bbs_field_double(val, "umax");
    bbs->nptsu = get_bbs_field_int(val, "nptsu");
    
    bbs->vmin = get_bbs_field_double(val, "vmin");
    bbs->vmax = get_bbs_field_double(val, "vmax");
    bbs->nptsv = get_bbs_field_int(val, "nptsv");
    
    bbs->valdim = get_bbs_field_int(val, "valdim");
}