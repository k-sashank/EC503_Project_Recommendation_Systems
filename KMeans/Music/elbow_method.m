% Load your data into a matrix X
load music_data.mat

% Set the maximum number of clusters to try
maxK = 20;

% Initialize the sum of squared distances vector
sumSquaredDistances = zeros(1, maxK);

% Loop over the range of k values
for k = 1:maxK
    % Run k-means with the current k value
    [centroids, clusterIndices] = kmeans(X, k);
    
    % Compute the sum of squared distances for each point in each cluster
    clusterDistances = zeros(size(X));
    for i = 1:k
        clusterPoints = X(clusterIndices == i, :);
        centroid = centroids(i, :);
        clusterDistances(clusterIndices == i, :) = repmat(centroid, size(clusterPoints, 1), 1) - clusterPoints;
    end
    sumSquaredDistances(k) = sum(sum(clusterDistances .^ 2));
    
end

% Plot the elbow curve
figure;
plot(1:maxK, sumSquaredDistances, 'bx-');
xlabel('Number of Clusters');
ylabel('Sum of Squared Distances');
title('Elbow Curve');