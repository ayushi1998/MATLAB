axis([0 200 0 200])
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


% Aboxe this the point cloud is set up%
z2=cat(1,x,y)
ans2= transpose(z)
   % This is the matrix to be passed to function

plot(x,y,'o')

axis([0 150 0 150])

