function [N,err_n] = compare_with_Ngth(P,q,Ng)
er = 1e-4;
nC = 40;
N = zeros(size(P));
for i = 1: size(P,1)/3
    
    q1 = q(2*(i-1)+1:2*(i-1)+2,:);
    idx = q1(1,:)~=0;
    umin=min(q1(1,idx))-0.1;umax=max(q1(1,idx))+0.1;
    vmin=min(q1(2,idx))-0.1;vmax=max(q1(2,idx))+0.1;
    bbs = bbs_create(umin, umax, nC, vmin, vmax, nC, 3);
    coloc = bbs_coloc(bbs, q1(1,idx), q1(2,idx));
    lambdas = er*ones(nC-3, nC-3);
    bending = bbs_bending(bbs, lambdas);
    cpts = (coloc'*coloc + bending) \ (coloc'*P(3*(i-1)+1:3*(i-1)+3,idx)');
    ctrlpts = cpts';
    qw = bbs_eval(bbs, ctrlpts, q1(1,idx)',q1(2,idx)',0,0);
    error = sqrt(mean(sum((qw-P(3*(i-1)+1:3*(i-1)+3,idx)).^2)));
    dqu = bbs_eval(bbs, ctrlpts, q1(1,idx)',q1(2,idx)',1,0);
    dqv = bbs_eval(bbs, ctrlpts, q1(1,idx)',q1(2,idx)',0,1);
    nu = [dqu(1,:)./sqrt(sum(dqu.^2));dqu(2,:)./sqrt(sum(dqu.^2));dqu(3,:)./sqrt(sum(dqu.^2))];
    nv = [dqv(1,:)./sqrt(sum(dqv.^2));dqv(2,:)./sqrt(sum(dqv.^2));dqv(3,:)./sqrt(sum(dqv.^2))];
    nn = -cross(nu,nv);
    N(3*(i-1)+1:3*(i-1)+3,idx) = [nn(1,:)./sqrt(sum(nn.^2));nn(2,:)./sqrt(sum(nn.^2));nn(3,:)./sqrt(sum(nn.^2))];
    tt = acosd(sum(N(3*(i-1)+1:3*(i-1)+3,idx).*Ng(3*(i-1)+1:3*(i-1)+3,idx)));
    tt(tt>90)= 180-tt(tt>90);
    err_n(i,idx) = tt;
end