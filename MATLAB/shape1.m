x = [];
y = [];
z=zeros(80,2);
%Widths

x=[20,20,30,30,50,60,60,75,75,60,60,30,30,20];
y=[20,80,80,70,70,70,80,80,20,20,35,35,20,20];

z=cat(1,x,y);


ans1= transpose(z);

plot(ans1(:,1),ans1(:,2),'-o')

axis([0 150 0 150])



%X=[20 20;20 80;30 80;30 70;60 70;60 80;75 80;75 20;60 20;60 35];

cell1=ans1(1,:)
cell2=ans1(2,:)

cell3