function direction = AIMarek( map,pos, directionIn )

if directionIn == 0
        direction = randi([1,4]);
    else
        direction = directionIn;
end
    
    smery = [0,-1,1];
    smery(2:3) = smery(randperm(2)+1);
    %smery = smery(randperm(3));
    hodnoty = [];
    for s = smery
        novy_s = mod((direction + s -1),4) + 1;
        pos_next = pos + smer(novy_s);

         if (map(pos_next(1), pos_next(2)) == 2)
            direction = novy_s; % Otoč se směrem ke jídlu
            return;
         end
         
        hodnoty = [hodnoty,secti_vektor(ohodnot(map,pos_next,novy_s))]; 
    end
    
        [m id] = max(hodnoty);
        s = smery(id);
        direction = zatoc(direction,s);
end

function suma = secti_vektor(vektor)
    if any(vektor == -1)
        suma = -1;
    else
        suma = sum(vektor);
    end
end


function value = ohodnot(map, pos,s)
    if (volno(map, pos))
        M = matice_zajmu(map,pos,s,6);
        jidlo = sum(M==2);
        zed = sum(M == 1);
        had = sum(M > 2);
        value = 10*jidlo - (zed + had);
    else
        value = -100000000;
    end
end
function value = matice_zajmu(map,pos,s,velikost)
    big_map = ones(size(map) + velikost*2);
    big_map(velikost+1:end-velikost,velikost+1:end-velikost) = map;
    pos = pos + velikost;
    diff_s = smer(s);
    rozmerA = diff_s;
    rozmerB = diff_s;
    
    rozmerA(diff_s < 0) = -(velikost-1);
    rozmerA(diff_s > 0) = 0;
    
    rozmerB(diff_s < 0) = 0;
    rozmerB(diff_s > 0) = (velikost-1);
    
    rozmerA(diff_s == 0) = -(velikost-1);
    rozmerB(diff_s == 0) = (velikost-1);
    
    value = big_map(pos(1)+rozmerA(1):pos(1)+rozmerB(1),pos(2)+rozmerA(2):pos(2)+rozmerB(2));
end



function novy_smer = zatoc(smer,kam)
    novy_smer = mod((smer + kam -1),4) + 1;
end

function out = volno(map,pos)
    
    if((map(pos(1),pos(2)) == 0 || ...
       map(pos(1),pos(2)) == 2))
        out = true;
    else
        out = false;
    end
end

function value = smer(id)
    smery = [-1,0;0,1;1,0;0,-1];
    value = smery(id,:);
end


