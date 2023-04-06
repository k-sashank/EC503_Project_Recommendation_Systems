data = readtable('Music Data/data.csv/data.csv');

X = data(:, {'valence', 'acousticness', 'danceability', 'duration_ms', 'energy', 'instrumentalness', 'liveness', 'loudness', 'speechiness', 'tempo'});
all_data = data;
%X = data(:, {'acousticness', 'energy', 'loudness'});

X = table2array(X);

save('music_data.mat', 'X');
save('music_data_with_titles.mat', 'all_data');
