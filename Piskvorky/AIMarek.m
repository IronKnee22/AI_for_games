function tah = AIMarek(board, playerID)
    if(playerID == 1)
        moje_ID = 1;
        soupere_ID = 2;
    else
        moje_ID = 2;
        soupere_ID = 1;
    end

    hraci_moje = zeros(6,1);
    hraci_soupere = zeros(6,1);
    nepritelovy_pozice = [];
    mozne_pozice = [];
    nepritel_kamenu = 0;
    
    for i = 1:7
        pozice = GameBoard.GetTopFreePosition(i,board);
        for smer_nepritele = 1:4
            nepritel_kamenu = nepritel_kamenu + GameBoard.CountStonesInDir(board,[pozice,i],smer_nepritele,soupere_ID);
        end   
        if(GameBoard.ColIsFree(i,board))            
            
            vrade = 0;
            for smer = 1:4
                
                hracskych_kamenu = GameBoard.CountStonesInDir(board,[pozice,i],smer,moje_ID);
                vrade = vrade + hracskych_kamenu;
            end
            hraci_moje(i) = vrade;
            mozne_pozice = [mozne_pozice,hraci_moje(i)];
        end
        hraci_soupere(i) = nepritel_kamenu;
        nepritelovy_pozice = [nepritelovy_pozice,hraci_soupere(i)];
        nepritel_kamenu = 0;
    end
    [souper_max max_id] = max(nepritelovy_pozice);
    
    if(souper_max > 1)
        if(souper_max<=2)
            if(max_id<4)
                tah = max_id+1;
                if(GameBoard.ColIsFree(tah,board))
                    tah = max_id+1;
                end
            else
                tah = max_id-1;
            end
        else
            tah = max_id;
        end

    else
        [maxv maxid] = max(mozne_pozice);
        if(maxv == 0)
            tah = 4;
        else
            tah = maxid;
        end
    end
    

    
end
