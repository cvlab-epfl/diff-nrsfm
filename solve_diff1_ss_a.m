function k2_opt = solve_diff1_ss_a(eq)
%syms x2 real
% create sos
k2_opt = zeros(1,size(eq,1));
parfor i = 1:size(eq,1)
    k2_opt(i) = find_k2(i,eq(i,:));
    
end
end

function k2_init = find_k2(i,eqn)
k2_init =0;
x2 = create_var(i);
t = [x2^16,x2^15,x2^14,x2^13,x2^12,x2^11,x2^10,x2^9,x2^8,x2^7,x2^6,x2^5,x2^4,x2^3,x2^2,x2,1];
t = [x2^16*t,t(2:end)];
%t = t.*x2^18;
s = eqn*t';
s1 = diff(s,x2);
s2 = diff(s1,x2);
[cf ~] = coeffs(s1,x2);
k2 = roots(double(cf));
k2 = k2(imag(k2)==0); k2(abs(k2)> 1) = [];
if ~isempty(k2)
    res = zeros(size(k2));
    for j = 1:length(k2)
        res(j) = double(subs(s2,x2,k2(j)));
    end
    %         k2(res<0)=[];
    %         res_s = zeros(size(k2));
    %         for j = 1:length(k2)
    %             res_s(j) = double(subs(s,x2,k2(j)));
    %         end
    [val, idx] = min(res);
    k2_init= k2(idx);
end
end