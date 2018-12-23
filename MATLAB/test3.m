axis([0 100 0 100])

v = [];

w=[];

 

z=zeros(3,2)

ans

for ii = 1:3

  v = [v 10];

end

for ii = 0:2

 w = [w 20+(30*ii)];

end

 

for ii= 0:1

    v=[v 20+(10*ii)]

end

for ii=0:1

    w=[w 80]

end

 

for ii= 0:1

    v=[v 20+(10*ii)]

end

for ii=0:1

    w=[w 80]

end

 

for ii= 0:1

    v=[v 30]

end

w=[w 75]

w=[w 70]

 

v=[v 40]

v=[v 60]

w=[w 70]

w=[w 70]

 

v=[v 60]

v=[v 60]

w=[w 50]

w=[w 20]

 

v=[v 35]

w=[w 20]

 

 v=[v 10]
w=[w 20]

 

% Above this the point cloud is set up%

z=cat(1,v,w)

ans1= transpose(z)

ans1   % This is the matrix to be passed to function

  plot(v,w,'-o')

z

axis([0 100 0 100])

 

axis([0 100 0 100])

x = [];

y=[];

 

z2=zeros(80,2)

 

x=[x 10+50]

y=[y 10+50]

 

for ii = 1:3

  x = [x 10+50];

end

for ii = 0:2

 y = [y 20+(30*ii)+50];

end

 

 

 

for ii= 0:1

    x=[x 20+(10*ii)+50]

end

for ii=0:1

    y=[y 80+50]

end

 

 

 

for ii= 0:1

    y=[y 80+50]

end

x=[x 40+50]

x=[x 45+50]

 

x=[x 45+50]

x=[x 45+50]

y=[y 65+50]

y=[y 70+50]

x=[x 45+50]

y=[y 40+50]

x=[x 45+50]

y=[y 10+50]

 

x=[x 30+50]

y=[y 10+50]

 

x=[x 20+50]

y=[y 10+50]




x=[x 10+50]

y=[y 10+50]
 

% Aboxe this the point cloud is set up%

z2=cat(1,x,y)

ans2= transpose(z2)

[d,rojo,tr] = procrustes(ans2,ans1);
rojo
plot(ans1(:,1),ans1(:,2),'-o',ans2(:,1),ans2(:,2),'-o',rojo(:,1),rojo(:,2),'-o');
