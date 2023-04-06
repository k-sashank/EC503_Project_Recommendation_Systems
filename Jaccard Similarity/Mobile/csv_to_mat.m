data = readtable('Mobile Data\used_device_data.csv');

%X = data(:, {'screen_size', 'rear_camera_mp', 'front_camera_mp', 'internal_memory', 'ram', 'battery', 'weight', 'normalized_used_price', 'normalized_new_price'});
all_data = data;
%X = data(:, {'acousticness', 'energy', 'loudness'});

%X = table2array(X);
%X_ = X(2:size(X, 1), :);
%X = table2array(X);
%X_ = table2array(X_);
%Y = table2array(Y);
%Y = Y(2:size(Y, 1), :);

save('mobile_features_all.mat', 'all_data');
%save('product_ratings_with_titles.mat', 'X');
%save('user_ids.mat', 'Y');
%save('music_data_with_titles.mat', 'all_data');

