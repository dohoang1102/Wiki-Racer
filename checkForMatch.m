function boolean = checkForMatch(matrix, expression)
    boolean = 0;
    for a = 1:length(matrix)
        if (strcmpi(cell2mat(matrix(a)),expression))
            boolean = 1;
            return;
        end
    end

end