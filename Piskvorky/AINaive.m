function sloupec = AINaive(board,id)
    
    hodnoty = zeros(7,1);
    ids = [];
    for k = 1:7
       if(GameBoard.ColIsFree(k,board))
           pos = GameBoard.GetTopFreePosition(k,board);
           h = 0;
           for smer = 1:4
                h = h + GameBoard.CountStonesInDir(board,[pos,k],smer,id);
           end
           hodnoty(k) = h;
           ids = [ids,k]; %id vsech moznych pozic
       end
    end
    ids_perm = ids(randperm(length(ids))); %zamicham je
    
    [maxv maxid] = max(hodnoty(ids_perm));
    sloupec = ids_perm(maxid);
end

