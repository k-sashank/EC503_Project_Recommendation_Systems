% k-means implementation from scratch (memory optimal)
function [centroids, clusterIndices] = kmeans(X, k)

% Initialize the centroids randomly
centroids = X(randperm(size(X, 1), k), :);

% Loop until convergence
while true
    
    % Assign each point to the closest centroid
    distances = zeros(size(X, 1), k);
    for i = 1:k
        distances(:, i) = sum((X - centroids(i, :)) .^ 2, 2);
    end
    [~, clusterIndices] = min(distances, [], 2);
    
    % Update the centroids
    newCentroids = zeros(k, size(X, 2));
    for i = 1:k
        newCentroids(i, :) = mean(X(clusterIndices == i, :), 1);
    end
    
    % Check for convergence
    if norm(newCentroids - centroids, 'fro') < 1e-6
        centroids = newCentroids;
        break;
    end
    
    centroids = newCentroids;
end

end
