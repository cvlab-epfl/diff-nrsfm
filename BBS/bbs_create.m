function bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, valdim)
%bbs_create Create a bidimensional cubic spline.
%
% bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, valdim)
%
% Create a structure containing the parameters of a bidimensional cubic
% B-Spline. It can mono or multi valued depending on the "valdim"
% parameter.
%
% INPUT ARGUMENTS
%
%   umin, umax [scalars]: limits of the domain along the first input
%   dimension (u-axis). By convention, the letters (u,v) are used in the
%   input space of the spline while the letters (x,y,...) are used for the
%   output space.
%
%   vmin, vmax [scalars]: same as umin and umax but for the second
%   input dimension (v-axis).
%
%   nptsu, nptsv [scalars]: size of the control points grid. The total
%   number of control points is nptsu*nptsv. The total number of parameters
%   is valdim*nptsu*nptsv.
%
%   valdim [scalar]: dimension of the B-Spline values. "valdim=1"
%   correspond to a monovalued spline such as a range surface. "valdim=2"
%   corresponds to, for example, an image warp.
%
% OUTPUT ARGUMENTS
%
%   bss [structure]: a structure containing the parameters of the spline.
%   Note that this structure does not contains the control points of the
%   spline.
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

if nptsu < 4 || nptsv < 4
    error('bsw:numberOfCtrlPts', 'The number of control point must be > 4.');
end

bbs.umin = umin;
bbs.umax = umax;
bbs.nptsu = nptsu;
bbs.vmin = vmin;
bbs.vmax = vmax;
bbs.nptsv = nptsv;
bbs.valdim = valdim;
