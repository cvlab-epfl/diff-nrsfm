% example script
clear all;close all;

% add libraries
addpath(genpath('/cvlabdata2/home/shaifali/NRSFM_CODE/code_new/BBS'));
addpath(genpath('/cvlabdata2/home/shaifali/NRSFM_CODE/code_new/diff_nrsfm_code'));

load kinect_paper_cvpr_methods

idx = 1:190; num = 190;

u_all = qgth(1:2:end,:);
v_all = qgth(2:2:end,:);
I2u = u_all(2:end,:);
I2v = v_all(2:end,:);
I1u = repmat(qgth(1,:) ,length(idx)-1,1);
I1v = repmat(qgth(2,:) ,length(idx)-1,1);

a = J21a; b = J21b; c = J21c; d = J21d;
u = I2u; v = I2v; u1 = I1u; v1 = I1v;

% create equations of diff constraints
[eq1a,eq2a,eq3a] = coeff_eqn_diff_3(u1,v1,u,v,a,b,c,d);

% median values of equations
e1m = repmat(median(abs(eq1a),3),[1,1,size(eq1a,3)]); eq1a(abs(eq1a)<0.01*e1m)=0;
e2m = repmat(median(abs(eq2a),3),[1,1,size(eq2a,3)]); eq2a(abs(eq2a)<0.01*e2m)=0;
e3m = repmat(median(abs(eq3a),3),[1,1,size(eq3a,3)]); eq3a(abs(eq3a)<0.01*e3m)=0;


% create univariate polynomial in x2 using eqn1 : diff constraint shwarzian
% eqn ratio
tic
% create 3 equations : eqn 2,3  are eqns(17) in the paper, eqn1  is the
% ratio of eqn2 and 3
eq = create_poly_coeff_diff1(eq1a);
% solve for k2 using resultants on eqn 1
k2 = solve_diff1_ss_a(eq);
% solve for k1 by using the k2 obtained in the previous line
k1 = solve_diff6_ss3_a(k2,eq1a,eq2a,eq3a);
% find points that are not well-conditioned
visb = find_idx(k1,k2,eq1a);
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off','UseParallel',true,'MaxIterations',2000,'FunctionTolerance',1e-10);
[k1_opt,k2_opt]=refine_results(k1,k2,eq1a,visb,options);
toc
[P_d,N_d,err_pd,err_nd] = recover_surfaces(k1_opt,k2_opt,num,a,b,c,d,u1,v1,u,v,I1u,I2u,I1v,I2v,idx,qgth,Pgth,Ngth);
