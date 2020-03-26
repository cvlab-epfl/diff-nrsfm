function mat = bbs_coloc(bbs, u, v)
%bbs_coloc Build a colocation matrix.
%
% mat = bbs_coloc(bbs, u, v)
%
% Build the colocation matrix of the bidimensional B-Spline "bbs" for the 
% colocation sites (u,v).
% Note that the colocation matrix is independant of the dimension of the
% values of the spline.
%
% INPUT ARGUMENTS
%
%   bbs: B-Spline structure (as created by bbs_create).
%
%   u, v [matrices]: Location used in the colocation matrix. These arrays
%   can be of any shape. Linear indexing is used to access their elements.
%
% OUTPUT ARGUMENTS
%
%   mat [(numel(u) x (nptsu*nptsv)) sparse matrix]: colocation matrix. The
%   i-th row of "coloc" correspond to the site (u(i),v(i)).
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
