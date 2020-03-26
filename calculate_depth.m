function P_grid=calculate_depth(N_res,u,v,par)
nC=40;
lambdas = par*ones(nC-3, nC-3);
P_grid = zeros(3*size(u,1),size(u,2));
for i=1:size(u,1)
    idx = find(N_res(3*(i-1)+1,:)~=0);
    if ~isempty(idx)
        umin=min(u(i,:))-0.1;umax=max(u(i,:))+0.1;
        vmin=min(v(i,:))-0.1;vmax=max(v(i,:))+0.1;
        bbsd = bbs_create(umin, umax, nC, vmin, vmax, nC, 1);
        colocd = bbs_coloc(bbsd, u(i,idx), v(i,idx));
        bendingd = bbs_bending(bbsd, lambdas);
        [ctrlpts3Dn]=ShapeFromNormals(bbsd,colocd,bendingd,[u(i,idx);v(i,idx);ones(1,length(u(i,idx)))],N_res(3*(i-1)+1:3*(i-1)+3,idx));
        mu=bbs_eval(bbsd, ctrlpts3Dn,u(i,:)',v(i,:)',0,0);
        P_grid(3*(i-1)+1:3*(i-1)+3,:) = [u(i,:);v(i,:);ones(1,length(u(i,:)))].*[mu;mu;mu];
    end
end
