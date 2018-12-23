clc ; clear; close all;
Y = [20 20; 20 90; 35 90;35 85;50 85;50 90 ; 60 90; 60 85; 110 85; 110 20;20 20];
%X=[30 20; 30 80; 40 80; 40 55; 60 55;60 80; 80 80; 80 20; 30 20];
%X=[20 40; 20 90; 40 90; 40 70; 90 70 ; 90 40 ; 20 40];
%X=[30 50; 30 90; 55 90; 55 60; 80 60; 80 30; 70 30; 70 50; 30 50 ];
%X=[200 200;100 200;100 300;400 300;400 200;300 200;300 100;200 100;200 200]
%Y=[100 200;100 300;200 300;200 200;300 200;300 100;200 100;200 0;100 0;100 100;0 100;0 200;100 200];
X=[20 20; 20 70; ; 60 70; 60 80;75 80;75 20;60 20;60 25; 30 25; 30 20; 20 20]

v1=pi*rand;
Rma=[cos(v1) -sin(v1);sin(v1) cos(v1)];

src=Rma*transpose(Y);

src(1,:)=src(1,:)+2*5;
src(2,:)=src(2,:)+2*5;

scale=rand;
I=[  scale 0  ; 0 scale];
src=scale*src;

Y=transpose(src);

B1=transpose(minBoundingBox(transpose(X)));

B2=transpose(minBoundingBox(transpose(Y)));

% Transform data points to their start positions


%figure(1)
%plot(X(:,1), X(:,2),'r-',B1(:,1), B1(:,2),'b-o', Y(:,1), Y(:,2),'g-',B2(:,1), B2(:,2),'b-o');
%legend('X = Destination','B = Bounding Box','Y = Source','location','SE')

xlim([0 100]);
ylim([0 100]);

[d,Z,transform]=procrustes(B1,B2);


% The transformation is applied to the Y matrix.


src1=transform.b*Y*transform.T;

row=transform.c(1,:)
translation=transform.c;
translation=[translation; ones(7,1)*row]

src1=src1+translation;

% The src1 matrix will now have the new generated points.

src1=createpts(src1,0.2);
X=createpts(X,0.2);


%plot(src1(:,1), src1(:,2),'r-',X(:,1), X(:,2),'g-',Z(:,1),Z(:,2),'b-o')
xlim([-100 120]);
ylim([-100 120]);


[R,T,data2] = icp(X,src1);
 
data2=transpose(data2);
figure(3)
plot(X(:,1), X(:,2),'x',data2(:,1), data2(:,2),'x')
legend('X = Destination','data2 = Transformed/Mapped Figure','location','SE')
xlim([-100 100]);
ylim([-100 100]);



