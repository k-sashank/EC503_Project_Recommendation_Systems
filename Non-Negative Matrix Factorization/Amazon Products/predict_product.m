function predict_product(user_id)
    load predicted_product_ratings.mat Y_pred
    index = 0;
    T = readtable('id_to_users_mapping.csv');
    column = T.users;
    for i = 1:size(column, 1)
        x = column(i);
        x = x{1};
        if strcmp(x, user_id)
            index = i;
            break;
        end
    end
    user_id_ = user_id;
    user_id = index;
    ratings = Y_pred(user_id, :);
    ratings = ratings(:, 2:size(ratings, 2));
    [~, I] = maxk(ratings, 5);
    fid = fopen('product_ratings.csv', 'r');
    headerLine = fgetl(fid);
    fclose(fid);
    
    product_list = textscan(headerLine, '%s', 'Delimiter', ',');
    
    product_list = product_list{1};
    product_list = product_list(2: size(product_list));
    
    fprintf("Recommended Products for User ID %s:\n", user_id_);
    for i = 1:5
        product_name = product_list(I(i));
        fprintf("%d. %s\n", i, product_name{1});
    end
end