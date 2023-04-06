function [U, S, V] = my_svd(X)
% X: input data matrix

% Compute Gram matrix
G = X' * X;

% Compute eigenvectors and eigenvalues of Gram matrix
[V, S] = eig(G);

% Sort eigenvectors and eigenvalues in descending order
[S, idx] = sort(diag(S), 'descend');
V = V(:, idx);

% Compute singular values and U matrix
S = sqrt(S);
U = X * V / diag(S);

end
