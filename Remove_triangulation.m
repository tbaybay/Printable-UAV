function Tu = Remove_triangulation(T, Tr)
    for n = 1:size(T,1)-1
        if T([n n+1], :) == Tr
            T([n n+1], :) = [];
            sprintf('Removal succesful');
            break
        end
    end
    Tu = T;
end
    