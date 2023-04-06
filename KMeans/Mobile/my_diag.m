function d = my_diag(A, k)
% A: input matrix
% k: diagonal offset

[m, n] = size(A);

if nargin == 1
    k = 0;
end

if k >= 0
    d = zeros(n - k, 1);
    for i = 1:n - k
        d(i) = A(i + k, i);
    end
elseif k < 0
    d = zeros(m + k, 1);
    for i = 1:m + k
        d(i) = A(i, i - k);
    end
end

end
