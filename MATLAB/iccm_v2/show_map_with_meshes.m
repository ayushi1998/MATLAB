function [m1,m2] = show_map_with_meshes(s1, s2, f_i)
    m1 = curve2tmesh(s1 - 1e-3 * znormals(s1), 1e-4);
    pts = complex(m1.vertices(:, 1), m1.vertices(:, 2));
    b = zinpoly(pts, s1);
    [~, ~, pts(~b)] = zdist2polyline(s1, pts(~b));
    Cpts = cgcoords(s1, pts);

    newpts = Cpts * f_i(:, end);

    m2 = m1;
    m2.vertices(:, 1:2) = [real(newpts), imag(newpts)];
    
    figure; 
    patch('faces',m1.faces,'vertices',m1.vertices,'facecolor','interp','cdata',m1.vertices(:,1)+m1.vertices(:,2),'edgecolor','k'); axis equal
    figure; 
    patch('faces',m2.faces,'vertices',m2.vertices,'facecolor','interp','cdata',m1.vertices(:,1)+m1.vertices(:,2),'edgecolor','k'); axis equal

    m1.texture = 'nums.jpg';
    m1.uv = m1.vertices(:,1:2);    
    
    m2.texture = 'nums.jpg';
    m2.uv = m1.vertices(:,1:2);
end

function [ normals ] = znormals( curve )

    normals = 1i*(circshift(curve, 1) - circshift(curve, -1));
    normals = normals ./ abs(normals);
    if turning_number(curve) > 0
        normals = -normals;
    end

end

function [ tmesh ] = curve2tmesh( curve, maxtarea, sources )
    if nargin < 2
        maxtarea = 0.01;
    end
    if nargin < 3
        sources = [];
    end
    
    save_pslg('tmp.poly', curve, sources);
    [~, ~] = system(sprintf('triangle.exe -ga%fD tmp.poly', maxtarea));
    tmesh = TriangleMesh('tmp.1.off');
end

function [ in, on ] = zinpoly( pts, curve )
    [in, on] = inpolygon(real(pts), imag(pts), real(curve), imag(curve));
end

function [ num ] = turning_number( curve )
    e1 = (curve - circshift(curve, 1));
    e2 = (circshift(curve, -1) - curve);
    num = sum(asin(imag(e1 .* conj(e2) ./ (abs(e1) .* abs(e2)))));    
end

function [ ] = save_pslg( filename, curve, sources )

    if nargin < 3
        sources = [];
    else
        sources = sources(:);
    end

    fid = fopen(filename, 'w');
    
    fprintf(fid, '%d 2 0 0\n', length(curve) + length(sources));
    inds = 1:length(curve);
    
    fprintf(fid, '%d %f %f\n', [inds, inds(end)+1 : inds(end) + length(sources); ...
        real(curve).', real(sources).'; ...
        imag(curve).', imag(sources).']);
    
    fprintf(fid, '%d 0\n', length(curve));
    
    fprintf(fid, '%d %d %d\n', [inds; circshift(inds, 1, 2); inds]); 
    
    fprintf(fid, '0\n');
    
    fclose(fid);
    
end


