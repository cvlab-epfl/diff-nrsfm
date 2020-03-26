function mat = bbs_bending_ur(bbs, lambdas)
%bbs_bending_ur Build the upper right part of the bending matrix.
%
% mat = bbs_bending_ur(bbs, lambdas)
%
% Build the upper right part of the bending matrix (which is a symmetric
% matrix). See bbs_bending to build the full bending matrix.
%
% INPUT ARGUMENTS
%
%   bbs: B-Spline structure (as created by bbs_create).
%
%   lambdas [(nptsv-3)x(nptsu-3) matrix]: regularization parameters for all
%   the knot domains. Considering that lambdas is 1-indexed and that knot 
%   interval numbers start from 0, lambdas(b,a) is the regularization parameter
%   for the knot domain #(a-1,b-1). (a-1) along the first (u-)axis and
%   (b-1) along the second (v-)axis.
%
% OUTPUT ARGUMENTS
%
%   mat [((nptsu*nptsv) x (nptsu*nptsv)) sparse matrix]: upper right part
%   of the bending matrix. For a particular spline, the corresponding
%   bending energy is "ctrlpts' * mat * ctrlpts".
%
% (c)2009-2010, Florent Brunet.

% BBS is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% BBS is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
% or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
% for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
