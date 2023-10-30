clear

hrac = [Player('Radim',@AIMinMax),...
    Player('Davids',@AIdavids),...
    Player('Patrik',@AIPatrik),...
    Player('Marek',@AIZkouska),...
    Player('Naive',@AINaive),...
    Player('Jan',@AIjan)];

disp("start")
ids = [1,4];
res = zeros([1 2]);
% stridat startovaci hrace
% vyresit remizu
for k = 1:20    
    h = play(hrac(ids));
    res(h) = res(h) + 1 ;
end

disp('Konec');


function win = play(hraci)
 
    gb = GameBoard();
    gb.Init(hraci); 

    while(gb.GameState == 0)        
        gb.Play(1); 
        if(gb.GameState ~=0)            
            break;
        end        
        gb.Play(2);      
    end
    win = gb.GameState;
    gb.Draw();    
    fprintf("winner: %d\n",win)
end