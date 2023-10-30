clear
%profile on
hraci = [Player('Hrac0',@AIHuman),...
         Player('Hrac1',@AIZkouska),...
         %Player('Hrac2',@AIMinMax),...
        ];
     
      
for k = 1:1 %vice opakovani
    gb = GameBoard();
    gb.Init(hraci); 

    while(gb.GameState == 0)
        gb.Draw();
        gb.Play(1); 
        if(gb.GameState ~=0)
            break;
        end
        gb.Draw();
        gb.Play(2); 
        %pause(5);
    end
    
    gb.Draw();
end
%profile viewer

%end    
disp('Konec');


