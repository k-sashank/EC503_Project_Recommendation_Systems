close all;
clear;

filename = 'ratings_500k.csv';
data = readtable(filename);

% hyperparameter search
num_factors_test = [3, 5, 10, 15, 20];
lr_test = [0.0005, 0.001, 0.005, 0.01];
lambda_test = [0.1, 0.2, 0.3];

best_hyperparams = struct('num_factors', 0, 'learning_rate', 0, 'lambda', 0);
best_rmse = Inf;

unique_users = unique(data.userId);
unique_movies = unique(data.movieId);

% dictionary to map movieId to index
movieId_to_index = containers.Map(unique_movies, 1:length(unique_movies));

% matrix to store ratings
num_users = max(unique_users);
num_movies = length(unique_movies);
Y = zeros(num_users, num_movies);

% create ratings matrix Y
for i = 1:size(data, 1)
    Y(data.userId(i), movieId_to_index(data.movieId(i))) = data.rating(i);
end

% split data into training, val, and test 
num_users = size(Y, 1);
num_movies = size(Y, 2);
train_ratio = 0.75;
val_ratio = 0.15;
mask_train = rand(size(Y)) < train_ratio;
mask_val = (rand(size(Y)) < (train_ratio + val_ratio)) & (~mask_train);
train_ratings = Y .* mask_train;
val_ratings = Y .* mask_val;
test_ratings = Y .* (~mask_train & ~mask_val);

num_epochs = 5000;

% find indices of the non-zero elements in the training set
[i_train, j_train] = find(train_ratings);

% early stopping
patience = 0;
prev_RMSE = Inf;

for num_factors = num_factors_test
    % init user and movie latent factor matrices
    P = rand(num_users, num_factors);
    Q = rand(num_movies, num_factors);
    for learning_rate = lr_test
        for lambda = lambda_test
            fprintf('Tuning hyperparams: num_factors = %d, learning_rate = %f, lambda = %f\n', num_factors, learning_rate, lambda);
            % matrix factorization using SGD
            for epoch = 1:num_epochs
                idx = randperm(length(i_train));
                i_train = i_train(idx);
                j_train = j_train(idx);
            
                for k = 1:length(i_train)
                    u = i_train(k);
                    m = j_train(k);
            
                    error = train_ratings(u, m) - P(u, :) * Q(m, :)';
                    P(u, :) = P(u, :) + learning_rate * (error * Q(m, :) - lambda * P(u, :));
                    Q(m, :) = Q(m, :) + learning_rate * (error * P(u, :) - lambda * Q(m, :));
                end
            
                predicted_ratings = P * Q';
            
                val_error = sum(((val_ratings - predicted_ratings) .^ 2) .* (val_ratings > 0), 'all');
                num_val_ratings = sum(val_ratings > 0, 'all');
                val_rmse = sqrt(val_error / num_val_ratings);
            
                if mod(epoch, 10) == 0
                    fprintf('Epoch %d, Validation RMSE: %f\n', epoch, val_rmse);
                end
            
                if prev_RMSE < val_rmse
                    if patience > 4
                        fprintf('Stopped after epoch %d, Validation RMSE: %f\n', epoch, val_rmse);
                        break
                    end
                    patience = patience + 1;
                else
                    patience = 0;
                end
            
                prev_RMSE = val_rmse;
                if val_rmse < best_rmse
                    best_rmse = val_rmse;
                    best_hyperparams.num_factors = num_factors;
                    best_hyperparams.learning_rate = learning_rate;
                    best_hyperparams.lambda = lambda;
                end
            end
        end
    end
end

fprintf('Best hyperparameters: num_factors = %d, learning_rate = %f, lambda = %f\n', best_hyperparams.num_factors, best_hyperparams.learning_rate, best_hyperparams.lambda);
fprintf('Validation RMSE with best hyperparameters: %f\n', best_rmse);

% eval model on test set
test_error = sum(((test_ratings - predicted_ratings) .^ 2) .* (test_ratings > 0), 'all');
num_test_ratings = sum(test_ratings > 0, 'all');
test_rmse = sqrt(test_error / num_test_ratings);
fprintf('Test RMSE: %f\n', test_rmse);
