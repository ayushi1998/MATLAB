function [ C, D, DD ] = cgcoords( cage, pts )
    % Cauchy green coordinates
    % Variables: 
    %   n - the number of vertices in the cage
    %   m - the number of points
    % Parameters:
    %   cage - the boundary of the domain (as a complex valued vector)
    %   pts - the points for which the coordinates are caculated
    % Outputs:
    %   C - a matrix of size (m x n) with the coordinates
    %   D - a matrix of size (m x n) with the derivatives
    %   DD - a matrix of size (m x n) with the second derivatives
    
    pts = pts(:);
    cage = cage(:).';
    cagem1 = circshift(cage, 1, 2);

    A = repmat(cage - cagem1, length(pts), 1);  % z_j - z_{j-1}
    Ap1 = circshift(A, -1, 2);                  % z{j+1} - z_j
    
    B = repmat(cage, length(pts), 1) - kron(pts, ones(1, length(cage)));    % z_j - z
    Bp1 = circshift(B, -1, 2);                  % z_{j+1} - z
    Bm1 = circshift(B, 1, 2);                  % z_{j+1} - z
    
    
    logBp1B = log(Bp1 ./ B);
    
    % Handle points on edges (correct angle of -pi to pi)
    wrongside = imag(logBp1B) + pi < sqrt(eps);
    logBp1B(wrongside) = logBp1B(wrongside) + 2i*pi;
    
    
    % Handle points on vertices (the zeros in the log will cancel each
    % other, so just replace them with 7)
    badB = abs(B) < sqrt(eps);
    badBp1 = circshift(badB, -1, 2);
    logBp1B(badBp1) = log(7 ./ B(badBp1));
    logBp1B(badB) = log(Bp1(badB) ./ 7);
    
    % and add 2*pi when the vertex falls on the wrong side (not very
    % efficient, better replace it with the exact formulas)
    wrongside = repmat(abs(sum(logBp1B, 2)) < 0.5, 1, length(cage));
    logBp1B(badB & wrongside) = 2i*pi + logBp1B(badB & wrongside);
    
    logBBm1 = circshift(logBp1B, 1, 2);
    
    C = (1./(2i*pi)) .* ((Bp1 ./ Ap1) .* logBp1B - (Bm1./A) .*logBBm1);
    
    
    logBBm1der = Ap1 ./ (Bp1 .* B);
    
    if nargout > 1
        Bm1Ader = 1 ./ Ap1;
        d2 = logBBm1der .* (-B./Ap1)  + Bm1Ader .* logBp1B;
        D = (1./(2i*pi)) .* (logBBm1der - d2 + d2(:, [end 1:end-1]));
    end
    if nargout > 2
        DD = (1./(2i*pi)) .* (1./(Bm1 .* B) - 1./(B .* Bp1));
    end
    
end

