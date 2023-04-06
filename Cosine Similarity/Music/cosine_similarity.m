function similarity = cosine_similarity(vector1, vector2)
    dot_product = 0;
    for i = 1:length(vector1)
        dot_product = dot_product + vector1(i) * vector2(i);
    end
    
    norm1 = 0;
    norm2 = 0;
    for i = 1:length(vector1)
        norm1 = norm1 + vector1(i)^2;
        norm2 = norm2 + vector2(i)^2;
    end
    norm1 = sqrt(norm1);
    norm2 = sqrt(norm2);
    
    similarity = dot_product / (norm1 * norm2);
end
