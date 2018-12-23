function [ f_i, d_i, err ] = iccm( s1, s2, varargin )
    % Iterative Closest Conformal Map
    % Find a conformal mapping between the domains bounded by the polygons
    % 's1' and 's2'.
    % The function finds a conformal mapping by minimizing the energy
    % E_c = |C f - w|^2
    % 
    % Parameters:
    %   s1 - the boundary polygon of the source domain
    %   s2 - the boundary polygon of the target domain
    % Outputs:
    %   f_i - a matrix containing the mappings during the iterations
    %   (f_i(:, i) containts the mapping at iteration i)
    %   d_i - the correspondences during the iterations
    %   err - the energy E_c during the iterations
    % Additional options:
    %   tol - stop when E_c < tol
    %   maxiter - stop after at most maxiter iterations
    %   show - whether to show the iterations
    %   constraints - p2p constraints (matrix of size m x 2)
    %   clambda - the weight for the p2p constraints
    %   slambda - the weight for the smoothness energy
    %   nsamples - number of samples per vertex 
    %              (sample total of nsamples * n points)
    %   f_i - set initial mapping
    %   quasi - the (inverse) weight for minimizing the dilatation of the
    %           harmonic mapping (0 - for the conformal mapping algorithm)
    %   order - the order of the distance function approximation (0 or 1)


    % Parse inputs
    p = inputParser;
    p.addOptional('tol', 1e-3, @isnumeric);
    p.addOptional('show', 0);
    p.addOptional('maxiter', 100);
    p.addOptional('constraints', zeros(0, 2));
    p.addOptional('clambda', 1e-1);
    p.addOptional('nsamples', 4);
    p.addOptional('f_i', []);
    p.addOptional('quasi', 0);
    p.addOptional('slambda', 0);
    p.addOptional('order', 0);
    parse(p, varargin{:});
    
    n = length(s1);
    fprintf(' p.Results.nsamples * n');
    p.Results.nsamples * n
    % Sample the source polygon
    [pts, nrms] = sample_polygon(s1, p.Results.nsamples * n);
    if ~isempty(p.Results.constraints)
        useconstraints = 1;
        cpts = p.Results.constraints(:, 1);
    else
        useconstraints = 0;
        cpts = [];
    end
    
    % Calculate the coordinates for the sampled points
    [C, D, DD] = cgcoords(s1, pts - 1e-4*nrms);
    % and for the p2p constraints
    Cpts = cgcoords(s1, cpts);
    
    % Calculate the pseudo inverse 
    if p.Results.quasi > 0
        C = [C, conj(C)];
        Cpts = [Cpts, conj(Cpts)];
        A = [C; 
             p.Results.clambda * Cpts;
             (1./p.Results.quasi) * [zeros(size(C, 1), size(C, 2)/2), conj(D)]
             p.Results.slambda * [DD, conj(DD)]];
         
        b = [
            p.Results.clambda * p.Results.constraints(:, 2);
            zeros(size(C, 1)*2, 1)];
                
    else
        A = [C; 
             p.Results.clambda * Cpts;
             p.Results.slambda * DD];
         
        b = [
             p.Results.clambda * p.Results.constraints(:, 2);
             zeros(size(C, 1), 1)];
    end
    if p.Results.order == 0
        Cinv = pinv(A);
        Cinv = Cinv(:, 1 : (length(pts) + size(Cpts, 1)));
    else
        A = A(size(C,1)+1:end, :);
    end


    % The initial correspondence
    [d_i, n_i] = sample_polygon(s2, length(s1) * p.Results.nsamples);
    
    f_i = C \ d_i;
    current = C * f_i;
    err = norm(current - d_i);
    iter = 0;
    
    % Show the initial setup
    if p.Results.show
        figure
        plot(s2([1:end 1]));
        hold on

        hh = plot(current);
        
        if useconstraints == 1
            hh2 = plot(Cpts * f_i, 'r.');
            plot(p.Results.constraints(:, 2), 'b.');
        end
        axis equal;
        fprintf('press any key to run iterations\n');
        waitforbuttonpress;
    end
    
    % Iterative search for a closer conformal map
    while err(end) > p.Results.tol && iter < p.Results.maxiter - 1 
            
        iter = iter + 1;
        fprintf('Iter %d\n', iter);
        
        % Global step - calculate the closest mapping to the correspondence
        % points
        if p.Results.order == 0
            f_i(:, end+1) = Cinv * [d_i(:, end); 
                     p.Results.clambda * p.Results.constraints(:, 2)];
        else
            AA = bsxfun(@times, C, conj(n_i));
            AA = [real(AA), -imag(AA);
                  real(A), -imag(A);
                  imag(A), real(A)];
            x = AA \ [real(d_i(:, end) .* conj(n_i));
                                  real(b);
                                  imag(b)];
            f_i(:, end+1) = complex(x(1:end/2), x(end/2+1:end));
        end

        current = C * f_i(:, end);
        
        % Local step - find the closest points on the target
        [~, ~, d_i(:, end+1), n_i] = zdist2polyline(s2([1:end 1]), current);
        
        err(end+1) = norm(current - d_i(:, end));
        
        if p.Results.show
            
            set(hh, 'xdata', real(current([1:end 1])), 'ydata', imag(current([1:end 1])));
            
            if useconstraints == 1
                set(hh2, 'xdata', real(Cpts*f_i(:, end)), 'ydata', imag(Cpts*f_i(:, end)));
            end
            axis equal
            pause(0.04);
        end
    end
    
end

