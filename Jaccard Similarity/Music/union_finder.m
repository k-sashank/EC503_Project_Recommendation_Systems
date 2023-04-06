function union_set = union_finder(set1, set2)
    union_set = set1;
    for i = 1:length(set2)
        elem = set2(i);
        if ~ismember(elem, union_set)
            union_set(end+1) = elem;
        end
    end
end
