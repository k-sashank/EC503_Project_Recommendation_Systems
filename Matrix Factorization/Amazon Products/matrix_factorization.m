load product_ratings.mat

tic
K = 3;


alpha = 0.000003;
beta = 0.0003;

rng(21); % reproducibility

P = randn(size(X_, 1), K);
Q = randn(K, size(X_, 2));

mask = (X_ > 0);

P_iter = P;
Q_iter = Q;

for epoch = 1:num_epochs

    E = (X_ - P_iter * Q_iter) .* mask;

    P_grad = -2 * E * Q_iter' + beta * P_iter;
    Q_grad = -2 * P_iter' * E + beta * Q_iter;

    P_iter = P_iter - alpha * P_grad;
    Q_iter = Q_iter - alpha * Q_grad;

    total_error = sum(sum(E.^2)) + beta * (sum(sum(P_iter.^2)) + sum(sum(Q_iter.^2)));

    if total_error < 0.01
        break;
    end
end

Y_pred = P_iter * Q_iter;

RMSE = sqrt(mean((X_(mask) - Y_pred(mask)).^2));

fprintf('RMSE: %.4f\n', RMSE);
toc

save('predicted_product_ratings.mat', 'Y_pred');