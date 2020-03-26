function ctrlpts = bbs_identity2(bbs, amin, amax, bmin, bmax, xmin, xmax, ymin, ymax)
%ctrlpts = bbs_identity2(bbs, xmin, xmax, ymin, ymax)
%ctrlpts = bbs_identity2(bbs, umin, umax, vmin, vmax, xmin, xmax, ymin, ymax)
%
% Compute the "identity" 2-dimensional 2-valued (i.e. a usual image warp)
% between the source domain [umin,umax]x[vmin,vmax] and the target domain
% [xmin,xmax]x[ymin,ymax].
% If the source domain is not specified as arguments of this function, the
% domain of the spline "bbs" is used.
%
% INPUT ARGUMENTS
%
%  - bbs: bbs structure as created by the "bbs_create" function. It gives
%    the basic parameters of the spline such as the source domain (if
%    required) and the number of control points.
%
%  - umin, umax, ...: bounds of the domains. See the description of this
%    function.
%
% OUTPUT ARGUMENTS
%
%  - ctrlpts: control points corresponding to the identity warp. Usable
%    with, for instance, the "bbs_eval".
%
% (c)2010, Florent Brunet.

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

% Input arguments
if nargin == 5
    umin = bbs.umin;
    umax = bbs.umax;
    vmin = bbs.vmin;
    vmax = bbs.vmax;
    xmin = amin;
    xmax = amax;
    ymin = bmin;
    ymax = bmax;
elseif nargin == 9
    umin = amin;
    umax = amax;
    vmin = bmin;
    vmax = bmax;
else
    error('Wrong number of arguments.');
end

[u v] = meshgrid(linspace(umin,umax,2*bbs.nptsu), linspace(vmin,vmax,2*bbs.nptsv));
u = u(:);
v = v(:);
[x y] = meshgrid(linspace(xmin,xmax,2*bbs.nptsu), linspace(ymin,ymax,2*bbs.nptsv));
x = x(:);
y = y(:);

colmat = bbs_coloc(bbs, u, v);

ctrlpts = (colmat \ [x y])';
