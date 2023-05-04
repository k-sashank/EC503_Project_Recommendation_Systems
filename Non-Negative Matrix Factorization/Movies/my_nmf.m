function [W, H] = my_nmf(R, k, max_iter)
% Perform non-negative matrix factorization on the matrix R
% with k latent factors and a maximum of max_iter iterations

% Initialize the factors W and H with random values
W = abs(randn(size(R, 1), k));
H = abs(randn(k, size(R, 2)));

% Compute the initial error between R and WH
err = norm(R - W*H, 'fro')^2;

% Repeat until the error converges or the maximum number of iterations is reached
for iter = 1:max_iter
    iter
    % Update the factors W and H using the NMF rules
    W = W .* (R*H') ./ (W*(H*H') + eps);
    H = H .* (W'*R) ./ ((W'*W)*H + eps);
    
    % Compute the error between R and WH
    err_new = norm(R - W*H, 'fro')^2;
    
    % Check if the error has converged
    if abs(err_new - err) < 1e-4
        disp("converges!")
        break;
    end
    
    err = err_new;
end
end
