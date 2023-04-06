function jaccard_sim = jaccard_similarity(set1, set2)
    intersection_set = intersection_finder(set1, set2);
    union_set = union_finder(set1, set2);
    jaccard_sim = length(intersection_set) / length(union_set);
end
