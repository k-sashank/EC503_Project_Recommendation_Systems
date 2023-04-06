load movie_ratings.mat

K = 3;

alpha = 0.00002;
beta = 0.0002;

P = abs(randn(size(Y, 1), K));
Q = abs(randn(K, size(Y, 2)));

for epoch = 1:5000
    for i = 1:size(Y, 1)
        for j = 1:size(Y, 2)
            if Y(i, j) > 0
                err = Y(i, j) - P(i, :) * Q(:, j);
                for k = 1:K
                P(i, k) = P(i, k) + alpha * (2 * err * Q(k, j) - beta * P(i, k));
                Q(k, j) = Q(k, j) + alpha * (2 * err * P(i, k) - beta * Q(k, j));
                end
            end
        end
    end
    eR = P*Q;
    e = 0;
    for i = 1:size(Y, 1)
        for j = 1:size(Y, 2)
            if Y(i, j) > 0
                e = e + power(Y(i, j) - P(i, :) * Q(:, j), 2);
                for k = 1:K
                    e = e + (beta / 2) * (power(P(i, k), 2) + power(Q(k, j), 2));
                end
            end
        end
    end
    if e < 0.01
        break;
    end
end

Y_pred = P*Q;

RMSE = sqrt(mean((Y(Y ~= 0) - Y_pred(Y ~= 0)).^2));
fprintf('RMSE: %.4f\n', RMSE);

save('predicted_movie_ratings.mat', 'Y_pred');
