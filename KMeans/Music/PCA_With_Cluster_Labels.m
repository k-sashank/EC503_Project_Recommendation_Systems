load music_data.mat
% X: input data matrix
% n_components: number of principal components to compute

% Calculate mean of columns
mu = mean(X, 1);

k = 5;
[~, clusterIndices] = kmeans(X, k);

% Subtract mean from columns
X_centered = X - repmat(mu, size(X, 1), 1);

% Compute SVD of centered data matrix
[U, S, V] = my_svd(X_centered);

% Extract top n_components principal components
pcs = V(:, 1:2);

% Calculate explained variance
explained = my_diag(S).^2 / (size(X_centered, 1) - 1);

% Calculate scores
scores = X_centered * pcs;

% Normalize explained variance
explained = explained / sum(explained);

cmap = jet(k);

scatter(scores(:, 1), scores(:, 2), [], cmap(clusterIndices, :),  'filled')
xlabel('PC 1')
ylabel('PC 2')
title('Transformed data in PC space')

