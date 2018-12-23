A = [11 39;17 42;25 42;25 40;23 36;19 35;30 34;35 29;
30 20;18 19;11 39];
B = [15 31;20 37;30 40;29 35;25 29;29 31;31 31;35 20;
29 10;25 18;15 31];
X = A;
Y = B + repmat([25 0], 11,1);
plot(X(:,1), X(:,2),'r-', Y(:,1), Y(:,2),'b-');


legend('X = Target','Y = Comparison','location','SE')
xlim([0 65]);
ylim([0 55]);
[d,Z,tr] = procrustes(X,Y);

plot(X(:,1), X(:,2),'r-', Y(:,1), Y(:,2),'b-',...
Z(:,1),Z(:,2),'b:');

legend('X = Target','Y = Comparison',...
'Z = Transformed','location','SW')
xlim([0 65]);
ylim([0 55]);