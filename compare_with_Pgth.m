function [P2,err_p] = compare_with_Pgth(P,u,v,q,Pg)
er = 1e-4;
t= 1e-3;
nC = 40;
P2 = zeros(3*length(u(:,1)),length(q(1,:)));
for i = 1: size(u,1)
    idx = find(u(i,:)~=0) & find(v(i,:)~=0);
    idx2 = q(2*(i-1)+1,:)~=0;
    q1 = q(2*(i-1)+1:2*(i-1)+2,idx2);
    umin=min(u(i,idx))-0.1;umax=max(u(i,idx))+0.1;
    vmin=min(v(i,idx))-0.1;vmax=max(v(i,idx))+0.1;
    
    bbs = bbs_create(umin, umax, nC, vmin, vmax, nC, 3);
    coloc = bbs_coloc(bbs, u(i,idx), v(i,idx));
    lambdas = er*ones(nC-3, nC-3);
    bending = bbs_bending(bbs, lambdas);
    cpts = (coloc'*coloc + bending) \ (coloc'*P(3*(i-1)+1:3*(i-1)+3,idx)');
    ctrlpts = cpts';
    qw = bbs_eval(bbs, ctrlpts, q1(1,:)',q1(2,:)',0,0);
    
    %[qw,~,~] = RegisterToGTH(qw,Pg(3*(i-1)+1:3*(i-1)+3,:));
    [~,qw,~]= absor(qw,Pg(3*(i-1)+1:3*(i-1)+3,idx2),'doScale',true);
    P2(3*(i-1)+1:3*(i-1)+3,idx2) = qw;
    scale = max(max(Pg(3*(i-1)+1:3*(i-1)+3,idx2)')-min(Pg(3*(i-1)+1:3*(i-1)+3,idx2)'));
    err_p(i,:) = sqrt(mean((Pg(3*(i-1)+1:3*(i-1)+3,:)-P2(3*(i-1)+1:3*(i-1)+3,:)).^2))/scale;
   
end