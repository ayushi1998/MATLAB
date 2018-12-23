% Generate model points
clc ; clear; close all;
%model1=[20 20; 20 90; 35 90;35 85;50 85;50 90 ; 60 90; 60 85; 110 85; 110 20;20 20]

model1=[20 30; 30 80; 40 80; 40 55; 60 55;60 80; 80 80; 80 20; 30 20]

%model1 =[20 40; 20 90; 40 90; 40 70; 90 70 ; 90 40 ; 20 40]

dest=transpose(model1)

% Generate data points  : 

%data1=[120 120; 120 190; 135 190;135 185;150 185;150 190 ; 160 190; 160 185; 210 185; 210 120;120 120]
%data1=[230 220; 230 280; 240 280; 240 255; 260 255;260 280; 280 280; 280 220; 230 220]
%data1=model1;

data1=[75 100;0 100;0 200;200 200;200 100;300 100;300 0;75 0;75 100];

src=data1;
% Transform data points to their start positions
v1=2*pi*rand;
Rma=[cos(v1) -sin(v1);sin(v1) cos(v1)];

src1=src*Rma;
src2=Rma*transpose(src);
src=src2;
figure(3)
plot(src1(1,:),src1(2,:),'-r',src2(1,:),src2(2,:),'-b'), axis equal

src(1,:)=src(1,:)+2*randn;
src(2,:)=src(2,:)+2*randn;

scale=rand;
I=[  scale 0  ; 0 scale];
src=scale*src;

% A plot. Model points and data points in start positions
srcbefore=src
figure(1)
plot(dest(1,:),dest(2,:),'-r',src(1,:),src(2,:),'-b'), axis equal




[d,Z,transform] = procrustes(transpose(dest),transpose(src));

Z=transform.b* src * transform.T 


% A plot. Model points and data points in transformed positions

figure(2)

plot(dest(1,:),dest(2,:),'o-r',Z(1,:),Z(2,:),'-b'), axis equal

