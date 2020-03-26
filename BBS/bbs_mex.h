/* bbs_mex.h
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
 
#ifndef __BBS_MEX_H__
#define __BBS_MEX_H__ 1

#include "mex.h"
#include "bbs.h"

void check_real_scalar(const mxArray *val, char *varname);
void check_real(const mxArray *val, char *varname);
void check_bbs_ctrlpts_size(const mxArray *val, bbs_t *bbs);

void array_to_bbs(const mxArray *val, bbs_t *bbs);

#endif
