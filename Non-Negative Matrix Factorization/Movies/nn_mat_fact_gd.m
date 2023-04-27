close all;
clear;

load movie_ratings.mat

rng(21); % reproducibility
K = 3;

alpha = 0.00004;
beta = 0.04;

% maintain non negativity
P = abs(randn(size(Y, 1), K));
Q = abs(randn(K, size(Y, 2)));

Y_mask = (Y > 0);

for epoch = 1:10000 % can do more epochs since vectorized
    Y_pred = P * Q;
    err = Y_mask .* (Y - Y_pred);
    
    grad_P = -2 * err * Q' + beta * P;
    grad_Q = -2 * P' * err + beta * Q;
    
    % To enforce non-negativity constraint during GD updates, 
    % we use projected GD, where the updated values for P and Q are 
    % projected back to the non-negative orthant after each update
    P = P - alpha * grad_P;
    P(P < 0) = 0; % Project P back to non-negative 
    
    Q = Q - alpha * grad_Q;
    Q(Q < 0) = 0; % Project Q back to non-negative 
    
    e = sum(err(:).^2) + (beta / 2) * (sum(P(:).^2) + sum(Q(:).^2));
    
    if e < 0.01
        break;
    end
end

Y_pred = P * Q;
RMSE = sqrt(mean((Y(Y_mask) - Y_pred(Y_mask)).^2));
fprintf('RMSE: %.4f\n', RMSE);

save('predicted_movie_ratings.mat', 'Y_pred');
