% TPS Warp based integration. The function gives the coefficients of the
% warp such that derivatives are as close as possible to those given.
% It uses Linear Least Squares.
%
% SYNTAX
%   L=TPSIntegration(p,J,C,mu,lambda,EpsilonLambda)
%  
% INPUT ARGUMENTS
%   -p: a (mxn) array of mx1 vectors in the template
%   -J: a ((r*m)xn) samples of the derivatives of the warp
%   -C: TPS centers in the template
%   -mu: smoothing parameter
%    -lambda: internal smoothing parameter. usually 1e-4
%   -EpsilonLambda: optional kernel matrix
%
% OUTPUT ARGUMENTS
%   -L: warp coefficients
%
% (c) 2013, Daniel Pizarro. dani.pizarro@gmail.com 

% TPS is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% TPS is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
% or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
% for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

% default parameter: er/70000

function L=BBSIntegration(bbs,p,J,er)

l=bbs.nptsu*bbs.nptsv;
nC = bbs.nptsu;
n=size(J,2);    
% for each p=(x y) obtain the v(p)
PSI=J';
Nx=zeros(n,l);
Ny=zeros(n,l);

% for i=[1:n]
%     pp=p(:,i);
% % q=L*v(p);--> v(p)=epsilon_lambda*lp;
% 
% % Obtaining p_vec
% pvec=zeros(l,2);
% pvec(:,1)=pp(1);
% pvec(:,2)=pp(2);
% distances=sum((pvec'-C').^2)';
% [rhos,rhosd]=TPSrho(distances);
% lp=[rhos;pp;1];
% lpx=[rhosd.*2.*(pvec(:,1)-C(:,1));1;0;0];
% lpy=[rhosd.*2.*(pvec(:,2)-C(:,2));0;1;0];
%  Nx(i,:)=Epsilon_lambda'*lpx;
%  Ny(i,:)=Epsilon_lambda'*lpy;
% end

% bending energy
lambda = er*ones(nC-3, nC-3);
ZTZ = bbs_bending(bbs, lambda);
Nx = bbs_coloc_deriv(bbs, p(1,:)', p(2,:)', 1, 0);
Ny = bbs_coloc_deriv(bbs, p(1,:)', p(2,:)', 0, 1);

N=[Nx;Ny;ones(1,l)];

PSI=[PSI(:);1];
L=(N'*N+n*ZTZ)\N'*PSI;
L=L';