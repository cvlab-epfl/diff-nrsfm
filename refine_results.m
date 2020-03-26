function [k1_opt,k2_opt]=refine_results(k1,k2,eq1a,visb,options)
k1_opt = zeros(size(k1));
k2_opt = zeros(size(k2));
parfor i = 1:size(eq1a,2)
    [k1_opt(i),k2_opt(i)]= refine(k1(i),k2(i),eq1a(:,i,:),visb(:,i),options);
end
end

function [k1o,k2o]= refine(k1i,k2i,eq1,vis,options)
eq1 = reshape(eq1,size(eq1,1),size(eq1,3));
vis = repmat(vis,1,size(eq1,3));
eq1= eq1.*vis;
[xlsq,resnorm,residual,exitflag,output] =lsqnonlin(@(x) refine_eq1(x,eq1), [k1i,k2i],[],[],options);
k1o=xlsq(1); k2o=xlsq(2);        
end

function F = refine_eq1(x,eq)
k1a = repmat(x(1),size(eq,1),1);
k2a = repmat(x(2),size(eq,1),1);
co = [k1a.^5,k1a.^4.*k2a,k1a.^3.*k2a.^2,k1a.^2.*k2a.^3,k1a.*k2a.^4,k2a.^5,k1a.^4,k1a.^3.*k2a,k1a.^2.*k2a.^2,k1a.*k2a.^3,k2a.^4,k1a.^3,k1a.^2.*k2a,k1a.*k2a.^2,k2a.^3];
F = sum(sum(eq.*co,2).^2);
end
