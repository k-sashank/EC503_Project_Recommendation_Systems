function mobile_finder_jaccard(mobile_feat, mobiles, mobile_name)
    names = mobiles.device_brand;
    index = find(ismember(names, mobile_name));
    [nsongs, ~] = size(mobile_feat);
    similarity = size(nsongs);
    for i = 1:nsongs
        if i ~= index
            sim = jaccard_similarity(mobile_feat(i, :), mobile_feat(index, :));
            similarity(i) = sim;
        end
    end
    [~, indices] = maxk(similarity, 5);
    name = mobiles.device_brand(index);
    fprintf("\n");
    fprintf("Mobile of Your Interest: %s", name{1});
    fprintf("\n");
    fprintf("\n");
    for i = 1:5
        recommended_index = indices(i);
        name = mobiles.device_brand(recommended_index);
        fprintf("Recommended Mobile %d: %s", i, name{1});
        fprintf("\n");
    end
end