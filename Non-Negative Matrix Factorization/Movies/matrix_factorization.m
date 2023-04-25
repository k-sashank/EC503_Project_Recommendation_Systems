close all
clear

load movie_ratings.mat
tic
K = 3;
num_epochs = 10000; % code is vectorized so we can run more epochs
alpha = 0.00003;
beta = 0.03;

rng(21); % reproducibility

P = abs(randn(size(Y, 1), K));
Q = abs(randn(K, size(Y, 2)));

mask = (Y > 0);

P_iter = P;
Q_iter = Q;

for epoch = 1:num_epochs

    E = (Y - P_iter * Q_iter) .* mask;

    P_grad = -2 * E * Q_iter' + beta * P_iter;
    Q_grad = -2 * P_iter' * E + beta * Q_iter;

    P_iter = P_iter - alpha * P_grad;
    Q_iter = Q_iter - alpha * Q_grad;
    P_iter(P_iter < 0) = 0;
    Q_iter(Q_iter < 0) = 0;

    total_error = sum(sum(E.^2)) + beta * (sum(sum(P_iter.^2)) + sum(sum(Q_iter.^2)));

    if total_error < 0.01
        break;
    end
end

Y_pred = P_iter * Q_iter;

RMSE = sqrt(mean((Y(mask) - Y_pred(mask)).^2));

fprintf('RMSE: %.4f\n', RMSE);
toc

save('predicted_movie_ratings.mat', 'Y_pred');
