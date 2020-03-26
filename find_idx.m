function visb = find_idx(k1,k2,eq)

for i=1:size(eq,2)
    for j=1:size(eq,1)
        res(j,i) = abs(eq(j,i,1)*k1(i)^5+eq(j,i,2)*k1(i)^4*k2(i)+eq(j,i,3)*k1(i)^3*k2(i)^2+eq(j,i,4)*k1(i)^2*k2(i)^3+...
            eq(j,i,5)*k1(i)*k2(i)^4+eq(j,i,6)*k2(i)^5+...
            eq(j,i,7)*k1(i)^4+eq(j,i,8)*k1(i)^3*k2(i)+eq(j,i,9)*k1(i)^2*k2(i)^2+eq(j,i,10)*k1(i)*k2(i)^3+eq(j,i,11)*k2(i)^4+...
            eq(j,i,12)*k1(i)^3+eq(j,i,13)*k1(i)^2*k2(i)+eq(j,i,14)*k1(i)*k2(i)^2+eq(j,i,15)*k2(i)^3);
    end
end
m = 10*repmat(median(res),size(eq,1),1);
res(res>=m)=0;
res(res~=0)=1;
visb = res;