function predict_movies(user_id)
    load predicted_movie_ratings.mat Y_pred
    
    ratings = Y_pred(user_id, :);
    ratings = ratings(:, 2:size(ratings, 2));
    [~, I] = maxk(ratings, 5);
    fid = fopen('user_ratings.csv', 'r');
    headerLine = fgetl(fid);
    fclose(fid);
    
    movies_list = textscan(headerLine, '%s', 'Delimiter', ',');
    
    movies_list = movies_list{1};
    movies_list = movies_list(2: size(movies_list));
    
    fprintf("Recommended Movies for User ID %d:\n", user_id);
    for i = 1:5
        movie_name = movies_list(I(i));
        fprintf("%d. %s\n", i, movie_name{1});
    end
end