function sloupec = AIHuman(board,id)
    sz_board= size(board);
    str = input('Zadej sloupec:','s');
    sloupec = str2num(str);
    
    while(~(sloupec > 0 && sloupec <=sz_board(2) && GameBoard.ColIsFree(sloupec,board)))
        str = input('Spatne zadany sloupec:','s');
        sloupec = str2num(str);        
    end
end