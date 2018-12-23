clear all; close all
dat = load('fig3');


% Run mapping. 
nsamples = 4; % Make it bigger for a less oscilatory map (might be slower)
f_i = iccm(dat.s1, dat.s2, 'constraints', [dat.s1_pts, dat.s2_pts], 'clambda', 10, 'tol', 1.5e-2, 'show', 1);
%%

% Generate a mesh to visualize map. Works only on Windows, and uses
% compiled "triangle.exe". Get the sources here: https://www.cs.cmu.edu/~quake/triangle.html
[m1,m2] = show_map_with_meshes(dat.s1, dat.s2, f_i);

% Output as obj files, viewable with MeshLab
m1.export_obj('out1.obj');
m2.export_obj('out2.obj');

