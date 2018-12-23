
axis([0 100 0 100])
v = [];
w=[];

z=zeros(80,2)

for ii = 1:20
  v = [v 10];
end
for ii = 1:20
 w = [w 10+(2*ii)];
end

for ii = 1:20
  v = [v 50];
end
for ii = 1:20
 w = [w 10+(2*ii)];
end

for ii = 1:20
  v = [v 10+(2*ii)];
end
for ii = 1:20
 w = [w 10];
end

for ii = 1:20
  v = [v 10+(2*ii)];
end
for ii = 1:20
 w = [w 50];
end

% Above this the point cloud is set up%
z=cat(1,v,w)
zf= transpose(z)
zf   % This is the matrix to be passed to function
v  % Show v
w
plot(v,w,'.')
z
axis([0 100 0 100])




x=[]
y=[]
a=zeros(80,2)

y = rescale(w,20,30) 

x = rescale(v,20,30)











