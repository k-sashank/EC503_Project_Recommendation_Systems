function song_finder_cosine(song_feat, songs, index)
    [nsongs, ~] = size(song_feat);
    similarity = size(nsongs);
    for i = 1:nsongs
        if i ~= index
            sim = cosine_similarity(song_feat(i, :), song_feat(index, :));
            similarity(i) = sim;
        end
    end
    [~, indices] = maxk(similarity, 5);
    disp("-------------------------------");
    disp("---- Song Of Your Interest ----");
    disp("Title: " + songs.name(index));
    disp("Artists: " + songs.artists(index));
    disp("-------------------------------");
    disp("");
    for i = 1:5
        disp("Recommended Song " + i);
        recommended_index = indices(i);
        disp("Title: " + songs.name(recommended_index));
        disp("Artists: " + songs.artists(recommended_index));
        disp("");
    end
end