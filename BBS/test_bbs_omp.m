function test_bbs_omp

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

close all;

umin = 0;
umax = 1;
nptsu = 4;
vmin = 0;
vmax = 1;
nptsv = 4;

bbs = bbs_create(umin, umax, nptsu, vmin, vmax, nptsv, 1);
ctrlpts = 2*rand(1,nptsu*nptsv)-1;

all_npts = round(linspace(1, 1000, 100));
nnpts = numel(all_npts);
ntrials = 10000;

results = zeros(ntrials, nnpts);


for i_npts = 1:nnpts
    for i_trial = 1:ntrials
        fprintf('%d %d\n', i_npts, i_trial);
        
        npts = all_npts(i_npts);
        u = (umax-umin)*rand(1,npts)+umin;
        v = (vmax-vmin)*rand(1,npts)+vmin;
        
        tic;
        val1 = bbs_eval(bbs, ctrlpts, u, v);
        t1 = toc;

        u = (umax-umin)*rand(1,npts)+umin;
        v = (vmax-vmin)*rand(1,npts)+vmin;
        
        tic;
        val1 = bbs_eval_omp(bbs, ctrlpts, u, v);
        t2 = toc;

        results(i_trial, i_npts) = t1/t2;
    end
end

plot(all_npts, mean(results));
hold on;
plot(all_npts, mean(results)+std(results), ':');
plot(all_npts, mean(results)-std(results), ':');
%set(gca, 'xscle', 'log');

