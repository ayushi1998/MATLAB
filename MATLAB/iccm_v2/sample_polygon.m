function [ z, nrms, kappa] = sample_polygon( w, m, vkappa )

    normals = 1i*(circshift(w, 1) - circshift(w, -1));
    normals = normals ./ abs(normals);

    n = length(w);
    
    dw = diff(w([1:n 1]));
    dn = diff(normals([1:n 1]));
    if nargin > 2
        dk = diff(vkappa([1:n 1]));
    end

    % Arc lengths of sides.
    s = abs(dw);
    s = cumsum([0;s]);
    L = s(end);
    s = s/L;  % relative arc length

    % Evenly spaced points in arc length.
    if m < 1
      % How many points will we need?
      m = ceil(L/m) + 1;
    end
    zs = (0:m-1)'/m;
    z = zs;
    nrms = zs;
    done = false(size(z));
    idx = zeros(size(z));
    kappa = zeros(size(z));

    % Translate to polygon sides.
    for j = 1:n
      mask = (~done) & (zs < s(j+1));
      z(mask) = w(j) + dw(j)*(zs(mask)-s(j))/(s(j+1)-s(j));
      nrms(mask) = normals(j) + dn(j) * (zs(mask)-s(j))/(s(j+1)-s(j));
      if nargin > 2 && nargout > 2
          kappa(mask) = vkappa(j) + dk(j) * (zs(mask)-s(j))/(s(j+1)-s(j));
      end
      idx(mask) = j;
      done = mask | done;
    end

end

