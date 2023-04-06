function [eig_val, eig_vec] = my_eig(A, max_iter, tol)
% A: input matrix
% max_iter: maximum number of iterations
% tol: tolerance level

% Initialize eigenvector randomly
eig_vec = rand(size(A,1),1);

for i = 1:max_iter
    % Power iteration
    eig_vec_new = A * eig_vec;
    
    % Normalize eigenvector
    eig_vec_new = eig_vec_new / norm(eig_vec_new);
    
    % Calculate eigenvalue
    eig_val = eig_vec_new' * A * eig_vec_new;
    
    % Check for convergence
    if norm(eig_vec_new - eig_vec) < tol
        eig_vec = eig_vec_new;
        break;
    else
        eig_vec = eig_vec_new;
    end
end
end
