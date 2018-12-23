function E=createpts(oldpts,dl)
C = oldpts;
E=[];
for i=1:length(C)-1
       A=C(i,:);
       B=C(i+1,:);
       X=[A;B];
       d = pdist(X,'euclidean');
       n=floor(d/dl);
       for j=1:n
            e=j*dl;
            de = e * (A - B) / norm(A - B);
            D = B + de;
            E=[E;D];     
       end
       
      
end