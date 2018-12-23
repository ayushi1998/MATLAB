function [ d, e, pt, normals, k ] = zdist2polyline( curve, pts, kverts )
    % Find the distance of the given points to the polyline
    % Parameters:
    %   curve - the target polyline
    %   pts - the points for which the distance is calculated
    %   kverts - a function defined on the vertices of the curve (for
    %   example the curvature at each vertex).
    % Outputs:
    %   d - the distance of the points to the polyline
    %   e - the index of the closest edge to each point
    %   pt - the closest point on the polyline
    %   normals - the normals to the closest edges
    %   k - interpolate the given function for the closest point
    
    if nargin < 3
        kverts = zeros(length(curve),1);
    end
    
    pts = pts(:);
    edges = curve(2:end) - curve(1:end-1);
    
    d = zeros(length(pts), 1);
    e = zeros(length(pts), 1);
    pt = zeros(length(pts), 1);
    normals = zeros(length(pts), 1);
    k = zeros(length(pts), 1);
    
    for i = 1 : length(pts)
        a = (pts(i) - curve(1:end-1));
        dc = conj(a) .* (edges ./ abs(edges));
        dc(real(dc)<0 | real(dc) > abs(edges)) = 100i;
        absa = abs(a);
        absdc = abs(imag(dc));
        [~, i1] = min(absa);
        [~, i2] = min(absdc);
        
        if absa(i1) < absdc(i2)
            d(i) = absa(i1);
            e(i) = i1;
            pt(i) = curve(i1);
            normals(i) = -1i * edges(i1) ./ abs(edges(i1));
            k(i) = kverts(i1);
        else
            d(i) = absdc(i2);
            e(i) = i2;
            pt(i) = curve(i2) + real(dc(i2)) * edges(i2) ./ abs(edges(i2));
            normals(i) = -1i * edges(i2) ./ abs(edges(i2));
            k(i) = kverts(i2) + real(dc(i2)) * kverts(i2+1) ./ abs(edges(i2));
        end
    end

end

