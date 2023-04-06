function intersection_set = intersection_finder(set1, set2)
    intersection_set = [];
    for i = 1:length(set1)
        elem = set1(i);
        if ismember(elem, set2)
            intersection_set(end+1) = elem;
        end
    end
    intersection_set = unique(intersection_set);
end