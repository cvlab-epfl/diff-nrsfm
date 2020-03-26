function test_bbs

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


test_normalize
test_eval_monoval
% test_eval_bival
% timing_eval
% test_coloc_bival
% test_coloc_monoval
% test_bending_disp
% test_bending_disp_bival
% check_bending

function test_normalize %#ok<DEFNU>
[nx inter] = bbs_normalize(0, 1, 5, 1)


function test_eval_monoval %#ok<DEFNU>
umin = 0;
umax = 1;
nptsu = 4;
vmin = 0;
vmax = 1;
nptsv = 4;

bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 1);

ctrlpts = [0 0 0 0   1 1 1 1   2 2 2 2   3 3 3 3];

[u v] = meshgrid(linspace(umin,umax,20), linspace(vmin,vmax,20));
val = bbs_eval(bbs, ctrlpts, u, v);
val = reshape(val(1,:), size(u));

close all;
mesh(u, v, val);
set(gca, 'dataaspectratio', [1 1 1]);



function test_eval_bival %#ok<DEFNU>
bbs = bbs_create(0, 1, 4, 0, 1, 4, 2);

ctrlpts = [0 0 0 0   1 1 1 1   2 2 2 2   3 3 3 3 ; 
           0 1 2 3   0 1 2 3   0 1 2 3   0 1 2 3];

ptsx = ctrlpts(1,:);
ptsy = ctrlpts(2,:);

[u v] = meshgrid(linspace(0,1,20), linspace(0,1,20));
val = bbs_eval(bbs, ctrlpts, u, v);
x = reshape(val(1,:), size(u));
y = reshape(val(2,:), size(u));

close all;
plot(ptsx, ptsy, '*');
hold on;
mesh(x, y, zeros(size(x)));
set(gca, 'dataaspectratio', [1 1 1]);
view(0, 90);


function timing_eval %#ok<DEFNU>
bbs = bbs_create(0, 1, 4, 0, 1, 4, 2);

ctrlpts = [0 0 0 0   1 1 1 1   2 2 2 2   3 3 3 3 ; 
           0 1 2 3   0 1 2 3   0 1 2 3   0 1 2 3];

all_npts = round(logspace(2, 6, 20));
all_tps = zeros(size(all_npts));
ntrial = 5;

for i = 1:numel(all_npts)
    fprintf('i=%d\n', i);
    
    npts = all_npts(i);
    
    u = rand(npts,1);
    v = rand(npts,1);

    tps = 0;
    for trial = 1:ntrial
        tic;
        val = bbs_eval(bbs, ctrlpts, u, v);
        tps = tps + toc;
    end
    all_tps(i) = tps;% / ntrial;
end

close all;
plot(all_npts, all_tps);
sum(all_tps)


function test_coloc_bival %#ok<DEFNU>
umin = 1;
umax = 800;
nptsu = 10;
vmin = 1;
vmax = 600;
nptsv = 5;

bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 2);

% Generate some point corresp.
[u v] = meshgrid(linspace(umin,umax,nptsu), linspace(vmin,vmax,nptsv));
u = u(:);
v = v(:);
amp = 10;
th = 2*pi*rand(size(u));
x = u + amp * cos(th);
y = v + amp * sin(th);

% Compute the control points
coloc = bbs_coloc(bbs, u, v);
ctrlpts = coloc \ [x y];
ctrlpts = ctrlpts';

% Display the results
close all;
plot(x, y, '*');
set(gca, 'DataAspectRatio', [1 1 1]);
fact = 8;
ndu = fact*(nptsu-1)+1;
ndv = fact*(nptsv-1)+1;
[du dv] = meshgrid(linspace(umin,umax,ndu), linspace(vmin,vmax,ndv));
val = bbs_eval(bbs, ctrlpts, du, dv);
dx = reshape(val(1,:), size(du));
dy = reshape(val(2,:), size(du));
hold on;
mesh(dx, dy, zeros(size(dx)), 'facecolor', 'none');


function test_coloc_monoval %#ok<DEFNU>
umin = 0;
umax = 1;
nptsu = 10;
vmin = 0;
vmax = 1;
nptsv = 5;

bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 1);

% Generate some point corresp.
[u v] = meshgrid(linspace(umin,umax,nptsu), linspace(vmin,vmax,nptsv));
u = u(:);
v = v(:);
z = sin(2*pi*u);

% Compute the control points
coloc = bbs_coloc(bbs, u, v);

ctrlpts = coloc \ z;
ctrlpts = ctrlpts';

% Display the results
close all;
plot3(u, v, z, '*');
%set(gca, 'DataAspectRatio', [1 1 1]);
fact = 4;
ndu = fact*(nptsu-1)+1;
ndv = fact*(nptsv-1)+1;
[du dv] = meshgrid(linspace(umin,umax,ndu), linspace(vmin,vmax,ndv));
val = bbs_eval(bbs, ctrlpts, du, dv);
dx = reshape(val, size(du));
hold on;
mesh(du, dv, dx, 'facecolor', 'none');


function test_bending_disp %#ok<DEFNU>
close all;

umin = 0;
umax = 1;
nptsu = 8;
vmin = 0;
vmax = 1;
nptsv = 5;

bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 1);

% Generate some point corresp.
[u v] = meshgrid(linspace(umin,umax,nptsu), linspace(vmin,vmax,nptsv));
u = u(:);
v = v(:);
z = sin(2*pi*u);

% Compute the control points
coloc = bbs_coloc(bbs, u, v);
lambdas = 0.0*ones(nptsv-3, nptsu-3);
lambdas(1,1)=0.001;
imagesc(lambdas);
set(gca, 'ydir', 'normal', 'dataaspectratio', [1 1 1]);
bending = bbs_bending_ur(bbs, lambdas);
tmp = bending - diag(diag(bending));
tmp2 = tmp + tmp' + diag(diag(bending));

ctrlpts = (coloc'*coloc + tmp2) \ (coloc'*z);
ctrlpts = ctrlpts';

% Display the results
figure(2);
plot3(u, v, z, '*');
%set(gca, 'DataAspectRatio', [1 1 1]);
fact = 4;
ndu = fact*(nptsu-1)+1;
ndv = fact*(nptsv-1)+1;
[du dv] = meshgrid(linspace(umin,umax,ndu), linspace(vmin,vmax,ndv));
val = bbs_eval(bbs, ctrlpts, du, dv);
dx = reshape(val, size(du));
hold on;
mesh(du, dv, dx, 'facecolor', 'none');



function test_bending_disp_bival %#ok<DEFNU>
rand('twister', 1);
close all;

umin = 1;
umax = 800;
nptsu = 16;
vmin = 1;
vmax = 600;
nptsv = 12;

bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 2);

% Generate some point corresp.
[u v] = meshgrid(linspace(umin,umax,1.5*nptsu), linspace(vmin,vmax,1.5*nptsv));
u = u(:);
v = v(:);
amp = 10;
th = 2*pi*rand(size(u));
x = u + amp * cos(th);
y = v + amp * sin(th);

ang = pi/4;
tmp = [cos(ang) -sin(ang) ; sin(ang) cos(ang)] * [x' ; y'];
x = tmp(1,:)';
y = tmp(2,:)';

% Compute the control points
coloc = bbs_coloc(bbs, u, v);
lambdas = 1*ones(nptsv-3, nptsu-3);
bending = bbs_bending(bbs, lambdas);
ctrlpts = (coloc'*coloc + bending) \ (coloc'*[x y]);
ctrlpts = ctrlpts';


% Display the results
close all;
plot(x, y, '*');
set(gca, 'DataAspectRatio', [1 1 1]);
fact = 4;
ndu = fact*(nptsu-1)+1;
ndv = fact*(nptsv-1)+1;
[du dv] = meshgrid(linspace(umin,umax,ndu), linspace(vmin,vmax,ndv));
val = bbs_eval(bbs, ctrlpts, du, dv);
dx = reshape(val(1,:), size(du));
dy = reshape(val(2,:), size(du));
hold on;
mesh(dx, dy, zeros(size(dx)), 'facecolor', 'none');



function check_bending() %#ok<DEFNU>
%rand('twister', 1);
ntest = 10;
err = 0;

for t = 1:ntest
    umin = 100*rand(1)-50;
    umax = umin+100*rand(1);
    nptsu = 4 + round(8*rand(1));
    vmin = 100*rand(1)-50;
    vmax = vmin+100*rand(1);
    nptsv = 4 + round(8*rand(1));

    bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 1);
    ctrlpts = rand(1, nptsu*nptsv);
    b_gt = dblquad(@(u,v)fun_bending(bbs, ctrlpts, u, v), umin, umax, vmin, vmax);

    lambdas = ones(nptsv-3, nptsu-3);
    bending = bbs_bending(bbs, lambdas);
    b_calc = ctrlpts * bending * ctrlpts';

    fprintf('ground truth: %f  computed: %f  diff: %f\n', b_gt, b_calc, abs(b_gt-b_calc));
    
    err = max(err, abs(b_gt-b_calc));
end
fprintf('ERROR MAX: %f\n', err);

function val = fun_bending(bbs, ctrlpts, u, v)
v = v * ones(size(u));
val = bbs_eval(bbs, ctrlpts, u, v, 2, 0).^2 + 2*bbs_eval(bbs, ctrlpts, u, v, 1, 1).^2 + bbs_eval(bbs, ctrlpts, u, v, 0, 2).^2;
