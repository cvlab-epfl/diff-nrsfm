function eq = create_poly_coeff_diff1(ee1)

if mod(size(ee1,1),2) == 1
    e1 = zeros(size(ee1,1)+1,size(ee1,2),size(ee1,3));
    for i = 1: size(ee1,3)
        e1(1:size(ee1,1),:,i) = ee1(1:size(ee1,1),:,i);
        e1(size(ee1,1)+1,:,i) = ee1(size(ee1,1)-1,:,i);
    end
    temp = ee1(:,:,1);
else
    e1 = ee1;
end

eq150=e1(1:2:end,:,1); eq141=e1(1:2:end,:,2); eq132=e1(1:2:end,:,3); eq123=e1(1:2:end,:,4); eq114=e1(1:2:end,:,5);eq105=e1(1:2:end,:,6);
eq140=e1(1:2:end,:,7); eq131=e1(1:2:end,:,8); eq122=e1(1:2:end,:,9); eq113=e1(1:2:end,:,10);eq104=e1(1:2:end,:,11);
eq130=e1(1:2:end,:,12);eq121=e1(1:2:end,:,13);eq112=e1(1:2:end,:,14);eq103=e1(1:2:end,:,15);

eq150a=e1(2:2:end,:,1); eq141a=e1(2:2:end,:,2); eq132a=e1(2:2:end,:,3); eq123a=e1(2:2:end,:,4); eq114a=e1(2:2:end,:,5);eq105a=e1(2:2:end,:,6);
eq140a=e1(2:2:end,:,7); eq131a=e1(2:2:end,:,8); eq122a=e1(2:2:end,:,9); eq113a=e1(2:2:end,:,10);eq104a=e1(2:2:end,:,11);
eq130a=e1(2:2:end,:,12);eq121a=e1(2:2:end,:,13);eq112a=e1(2:2:end,:,14);eq103a=e1(2:2:end,:,15);


% eq = cell(size(eq150,2),1);
% for i = 1 : length(eq)
%     eq{i} = zeros(size(eq150,1),17);
% end

eq = zeros(size(eq150,2),33);

for i = 1 : size(eq150,2)
    tt = zeros(size(eq150,1),33);
    i
    parfor j = 1:size(eq150,1)
        x2 = create_var(j);
        s1 = eq112(j,i)*x2^2+eq113(j,i)*x2^3+eq114(j,i)*x2^4;
        s2 = eq103(j,i)*x2^3+eq104(j,i)*x2^4+eq105(j,i)*x2^5;
        s3 = eq112a(j,i)*x2^2+eq113a(j,i)*x2^3+eq114a(j,i)*x2^4;
        s4 = eq103a(j,i)*x2^3+eq104a(j,i)*x2^4+eq105a(j,i)*x2^5;
        s5 = eq121(j,i)*x2+eq122(j,i)*x2^2+eq123(j,i)*x2^3;
        s6 = eq121a(j,i)*x2+eq122a(j,i)*x2^2+eq123a(j,i)*x2^3;
        s7 = eq130(j,i)+eq131(j,i)*x2+eq132(j,i)*x2^2;
        s8 = eq130a(j,i)+eq131a(j,i)*x2+eq132a(j,i)*x2^2;
        s9 = eq140a(j,i)+eq141a(j,i)*x2;
        s10 = eq140(j,i)+eq141(j,i)*x2;
        
        S2 = [eq150a(j,i),s9,s8,s6,s3,s4,0,0,0,0;...
            0,eq150a(j,i),s9,s8,s6,s3,s4,0,0,0;...
            0,0,eq150a(j,i),s9,s8,s6,s3,s4,0,0;...
            0,0,0,eq150a(j,i),s9,s8,s6,s3,s4,0;...
            0,0,0,0,eq150a(j,i),s9,s8,s6,s3,s4;...
            eq150(j,i),s10,s7,s5,s1,s2,0,0,0,0;...
            0,eq150(j,i),s10,s7,s5,s1,s2,0,0,0;...
            0,0,eq150(j,i),s10,s7,s5,s1,s2,0,0;...
            0,0,0,eq150(j,i),s10,s7,s5,s1,s2,0;...
            0,0,0,0,eq150(j,i),s10,s7,s5,s1,s2];
    
        R = det(S2);
        [cf t] = coeffs(R,x2);
        if length(cf) < 17
            cf = [zeros(1,17-length(cf)),cf];
        end
        tt(j,:) = create_diff_sq(double(cf));
        
    end
    eq(i,:)=sum(tt);
end
