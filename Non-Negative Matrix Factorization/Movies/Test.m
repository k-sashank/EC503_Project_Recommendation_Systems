% csv_file1 = 'ratings_small.csv';
% % use csvread to read the data from the file
% M = csvread(csv_file1,1);
% movie_rating=zeros(max(M(:,1)),max(M(:,2)));
% for i=1:max(M(:,1))
%     user_id_idx=find(M(:,1)==i);
%     for j=1:length(user_id_idx)
%         movie_id=M(user_id_idx(j),2);
%         rating=M(user_id_idx(j),3);
%         movie_rating(i,movie_id)=rating;
%     end
%     user_id_idx=[];
% end
% save("movie_rating.mat","movie_rating")

% load movie_rating.mat
% V=movie_rating;
% nonzero_cols = any(V, 1);
% % Select only the non-zero columns
% V = V(:, nonzero_cols);
% save("movie_rating_filled.mat","V")

load movie_rating_filled.mat
[W, H] = my_nmf(V, 3, 2000);
predicted_rating = W * H;
