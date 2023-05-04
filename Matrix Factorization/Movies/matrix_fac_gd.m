close all;
clear;

filename = 'ratings_500k.csv';
data = readtable(filename);

unique_users = unique(data.userId);
unique_movies = unique(data.movieId);

% dictionary to map movieId to index
movieId_to_index = containers.Map(unique_movies, 1:length(unique_movies));

% matrix to store ratings
num_users = max(unique_users);
num_movies = length(unique_movies);
Y = zeros(num_users, num_movies);

% ratings matrix Y
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

% # latent factors
num_factors = 15; 
learning_rate = 0.001;
num_epochs = 5000;
lambda = 0.2;
train_loss = zeros(1, num_epochs);
val_loss = zeros(1, num_epochs);

% init user and movie latent factor matrices
P = rand(num_users, num_factors);
Q = rand(num_movies, num_factors);

% find indices of the non-zero elements in the training set
[i_train, j_train] = find(train_ratings);

patience = 0;
prev_RMSE = Inf;

% matrix factorization using GD
for epoch = 1:num_epochs
    predicted_ratings = P * Q';
    error = train_ratings - predicted_ratings;

    dP = -2 * error * Q + 2 * lambda * P;
    dQ = -2 * (error' * P) + 2 * lambda * Q';

    P = P - learning_rate * dP;
    Q = Q - learning_rate * dQ;

    predicted_ratings = P * Q';

    train_error = sum(((train_ratings - predicted_ratings) .^ 2) .* (train_ratings > 0), 'all');
    num_train_ratings = sum(train_ratings > 0, 'all');
    train_rmse = sqrt(train_error / num_train_ratings);
    train_loss(epoch) = train_rmse;

    val_error = sum(((val_ratings - predicted_ratings) .^ 2) .* (val_ratings > 0), 'all');
    num_val_ratings = sum(val_ratings > 0, 'all');
    val_rmse = sqrt(val_error / num_val_ratings);
    val_loss(epoch) = val_rmse;

    if mod(epoch, 10) == 0
        fprintf('Epoch %d, Validation RMSE: %f\n', epoch, val_rmse);
    end

    % early stopping
    if prev_RMSE < val_rmse
        if patience > 4
            break
        end
        patience = patience + 1;
    else
        patience = 0;
    end

    prev_RMSE = val_rmse;
end

% eval model on test set
test_error = sum(((test_ratings - predicted_ratings) .^ 2) .* (test_ratings > 0), 'all');
num_test_ratings = sum(test_ratings > 0, 'all');
test_rmse = sqrt(test_error / num_test_ratings);
fprintf('Test RMSE: %f\n', test_rmse);
%% 

figure;
plot(1:2000, train_loss(1:2000), 'LineWidth', 1.5);
hold on;
plot(1:2000, val_loss(1:2000), 'LineWidth', 1.5);
hold off;
xlabel('Epoch');
ylabel('Loss');
title('Loss');
legend('Train', 'Val');
grid on;
