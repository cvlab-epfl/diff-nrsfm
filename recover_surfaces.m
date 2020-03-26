function [P2,N,err_p,err_n] = recover_surfaces(k1_opt,k2_opt,num,a,b,c,d,u1,v1,u,v,I1u,I2u,I1v,I2v,idx,q_n,Pgth,Ngth)
x1b = repmat(k1_opt,num-1,1); x2b = repmat(k2_opt,num-1,1);
nn = (u1.*x2b-v1.*x1b).*((a.*x1b+b.*x2b).^2 + (c.*x1b+d.*x2b).^2) + (a.*x1b+b.*x2b).*(a.*x2b-b.*x1b) + (c.*x1b+d.*x2b).*(c.*x2b-d.*x1b);
dd = (a.*d-b.*c).*(x1b.^2+x2b.^2).*(u.*(a.*x1b+b.*x2b)-v.*(c.*x1b+d.*x2b));
k1_all = [k1_opt;(a.*x1b+b.*x2b).*nn./dd];
k2_all = [k2_opt;(c.*x1b+d.*x2b).*nn./dd];

res = [k1_opt;k2_opt]';
u_all = [I1u(1,:);I2u]; v_all = [I1v(1,:);I2v];

% find normals on all surfaces N= [N1;N2;N3]
N1 = k1_all; N2 = k2_all; N3 = 1-u_all.*k1_all-v_all.*k2_all;
n = sqrt(N1.^2+N2.^2+N3.^2);
N1 = N1./n ; N2 = N2./n; N3 = N3./n;

N = [N1(:),N2(:),N3(:)]';
N_res = reshape(N(:),3*length(idx),length(u_all));

% find indices with no solution
idx = find(res(:,1)==0);
N_res(:,idx) = []; u_all(:,idx) = []; v_all(:,idx) = [];

% Integrate normals to find depth
P_grid=calculate_depth(N_res,u_all,v_all,1e0);


% compare with ground truth
[P2,err_p] = compare_with_Pgth(P_grid,u_all,v_all,q_n,Pgth);
[N,err_n] = compare_with_Ngth(P2,q_n,Ngth);
%err_n2 = compare_normals(N_res,Ngth);


% % plot results
% for i=1:20%size(u_all,1)
%     figure(i)
%     plot3(Pgth(3*(i-1)+1,:),Pgth(3*(i-1)+2,:),Pgth(3*(i-1)+3,:),'go');
%     hold on;
%     plot3(P2(3*(i-1)+1,:),P2(3*(i-1)+2,:),P2(3*(i-1)+3,:),'ro');
%     %quiver3(P2(3*(i-1)+1,:),P2(3*(i-1)+2,:),P2(3*(i-1)+3,:),N(3*(i-1)+1,:),N(3*(i-1)+2,:),N(3*(i-1)+3,:));
%     %quiver3(Pgth(3*(i-1)+1,:),Pgth(3*(i-1)+2,:),Pgth(3*(i-1)+3,:),Ngth(3*(i-1)+1,:),Ngth(3*(i-1)+2,:),Ngth(3*(i-1)+3,:));
%     hold off;
%     axis equal;
% end
mean(mean(err_p'))

mean(mean(err_n'))
