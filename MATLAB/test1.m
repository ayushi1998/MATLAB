

clc ; clear; close all;
X = [20 20; 20 90; 35 90;35 85;50 85;50 90 ; 60 90; 60 85; 110 85; 110 20;20 20] %N*2 matrix

Y=[20 20; 20 70; ; 60 70; 60 80;75 80;75 20;60 20;60 25; 30 25; 30 20; 20 20]

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


figure(1)
plot(X(:,1), X(:,2),'r-',B1(:,1), B1(:,2),'b-o', Y(:,1), Y(:,2),'g-',B2(:,1), B2(:,2),'b-o');
legend('X = Destination','Y = Source','location','SE')

xlim([-100 120]);
ylim([-100 120]);

[d,Z,transform]=procrustes(B1,B2);

figure(2)
plot(Y(:,1), Y(:,2),'r-',Z(:,1), Z(:,2),'p-')

legend('X = Destination','Y = Source','location','SE')

src1=transform.b*Y*transform.T;
figure(3)
plot(src1(:,1), src1(:,2),'r-',X(:,1), X(:,2),'g-o')
xlim([-100 120]);
ylim([-100 120]);




