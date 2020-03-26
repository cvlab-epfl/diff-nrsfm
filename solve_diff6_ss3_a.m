function k1_opt = solve_diff6_ss3_a(k2,eq1,eq2,eq3)
k1_opt=zeros(1,size(eq2,2));
parfor i = 1 : size(eq2,2)
    k1_opt(i)= find_k1(i,eq1(:,i,:),eq2(:,i,:),eq3(:,i,:),k2(i));
end

end

function k1_init = find_k1(i,eq1,eq2,eq3,k2_init)
x2 = create_var(i);
    t = [x2^10,x2^9,x2^8,x2^7,x2^6,x2^5,x2^4,x2^3,x2^2,x2,1];
    t = [x2^10*t,t(2:end)];
    t1 = [x2^5,x2^4,x2^3,x2^2,x2,1];
    t1 = [x2^5*t1,t1(2:end)];
    s = 0;
    for j = 1:size(eq2,1)
        s = s + create_eq2_sq(create_eqn2(eq2(j,:,:),k2_init))*t'+ create_eq2_sq(create_eqn2(eq3(j,:,:),k2_init))*t' + create_eq1_sq(create_eq1(eq1(j,:,:),k2_init))*t1';
    end
    s1 = diff(s,x2);
    s2 = diff(s1,x2);
    [cf ~] = coeffs(s1,x2);
    k1 = roots(double(cf));
    k1 = k1(imag(k1)==0); k1(abs(k1)> 1) = [];
    if ~isempty(k1)
        res = zeros(size(k1));
        for j = 1:length(k1)
            res(j) = double(subs(s2,x2,k1(j)));
        end
        %     k1(res<0)=[];
        %     res_s = zeros(size(k1));
        %     for j = 1:length(k1)
        %         res_s(j) = double(subs(s,x2,k1(j)));
        %     end
        [val, idx] = min(res);
        k1_init= k1(idx);
    else
        k1_init = 0;
    end
end
