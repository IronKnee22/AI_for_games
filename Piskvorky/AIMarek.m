function dalsi_tah = AIMarek(board, playerID)

    moje_ID = playerID;
    soupere_ID = GameBoard.GetOponent(moje_ID);
    
    hraci_moje = zeros(6,1);
    hraci_soupere = zeros(6,1);
    nepritelovy_pozice = [];
    mozne_pozice = [];
    
    for i = 1:7
        nepritel_kamenu = 0;
        vrade = 0;
        if GameBoard.ColIsFree(i, board)
            pozice = GameBoard.GetTopFreePosition(i, board);
            
            
            for smer_nepritele = 1:4
                nepritel_kamenu = nepritel_kamenu + GameBoard.CountStonesInDir(board, [pozice, i], smer_nepritele, soupere_ID);
            end
            
            
            for smer = 1:4
                hracskych_kamenu = GameBoard.CountStonesInDir(board, [pozice, i], smer, moje_ID);
                vrade = vrade + hracskych_kamenu;
            end
         end 
            
            hraci_moje(i) = vrade;
            mozne_pozice = [mozne_pozice, hraci_moje(i)];
            hraci_soupere(i) = nepritel_kamenu;
            nepritelovy_pozice = [nepritelovy_pozice, hraci_soupere(i)];
         
    end
    
    [souper_max, max_id] = max(nepritelovy_pozice);
    
    if souper_max > 1
        if souper_max <= 2
            tah = (max_id < 4) * (max_id + 1) + (max_id >= 4) * (max_id - 1);

        else
            tah = max_id;
        end
    else
        [maxv, maxid] = max(mozne_pozice);
        tah = (maxv == 0) * 4 + (maxv ~= 0) * maxid; 
    end
    
    tah = overeni_dostupnosti(tah, board);

    dalsi_tah = tah;
end

function novyTah = overeni_dostupnosti(tah, board)
    if ~GameBoard.ColIsFree(tah, board)
        tah = mod(tah, 7) + 1; 
        novyTah = overeni_dostupnosti(tah, board); 
    else
        novyTah = tah; 
    end
end
