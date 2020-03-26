function [nx inter] = bbs_normalize(xmin, xmax, npts, x)
%bbs_normalize Compute normalized values.
%
% [nx] = bbs_normalize(xmin, xmax, npts, x)
% [nx inter] = bbs_normalize(xmin, xmax, npts, x)
%
% Normalize the values in x according to the parameters xmin, xmax and
% npts. This function can also gives the interval number to which belongs
% the value x.
%
% INPUT ARGUMENTS
%
%   xmin, xmax [scalars]: definition range of a b-spline along one
%   direction.
%
%   npts [scalar]: number of control point along the considered direction.
%
%   x [matrix]: values to be normalized.
%
% OUTPUT ARGUMENTS
%
%   nx [matrix]: normalized values (between 0 and 1). size(nx) = size(x).
%
%   inter [matrix]: interval number to which belongs x. The first interval
%   is numbered 0. It can be negative (or greater that the last valid
%   number) in case of extrapolation.
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
