function direction = AInahodne( map,pos, directionIn )
%SNAKEAI Summary of this function goes here
%   Detailed explanation goes here

    if(directionIn == 0)
        directionIn = 1; % prvni krok nastavit nahoru
    end
    pohyb = [-1,0;0,1;1,0;0,-1]; %smery    
    direction = directionIn; % nastaveni vystupniho jde rovne
    
    %podívá se do okolí, když je tam jídlo zatoèí 
    smer=0;
    for k = 1:4
       p = pos+pohyb(k,:);
       if(map(p(1),p(2)) == 2 )
           smer = k;
           break; 
       end              
    end 
    
    %pokud tam není jídlo, tak zmìn smer když je pøed tebou zeï nebo s 20%
    %jen tak
    if(smer==0 && (rand() < 0.2 || ~JeVolno(direction,pos,map)))  
        s = randi([1,4]); %zvolím náhodný smìr
        for k = 1:4 
            p = pos+pohyb(s,:); %obejdu dokola najdu první volný            
            if(map(p(1),p(2)) == 0 || map(p(1),p(2)) == 2)
                smer = s;
                break; 
            end
            s = SmerDoprava(s);
       end              
    end 
    
    if(smer~=0)
        direction = smer;
    end
end

function vpravo = SmerDoprava(smer)
    vpravo = mod(smer - 1+1,4)+1;
end

function volno = JeVolno(smer,pos,map)
    pohyb = [-1,0;0,1;1,0;0,-1];
    p = pos+pohyb(smer,:);
    if(map(p(1),p(2)) == 2 || map(p(1),p(2)) == 0 )
        volno = true;
    else
        volno = false;
    end
end



