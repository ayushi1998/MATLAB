
dat = load('example.mat');

% Using a zeroth order approximation of the distance function
fprintf('Zero order approximation\n');
iccm(dat.s1, dat.s2, 'show', 1, 'tol', 1.5e-2);
%%

% Using a first order approximation of the distance function
fprintf('First order approximation\n');
iccm(dat.s1, dat.s2, 'show', 1, 'tol', 1.5e-2, 'ord', 1);