classdef GameBoard < matlab.mixin.SetGetExactNames
    %SNAKE Summary of this class goes here
    %   Detailed explanation goes here      
    properties(SetAccess = private, GetAccess= public) 
        GameState % (0 - active, 1 - first won, 2 - second player won)
    end
    properties(Access = private)                
        playersList                        
        Board       
    end
    
    methods (Static)
      function out = Directions()
         out = [-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1] ;
      end
      function out = Direction(id)
         dr = [-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1] ;
         out = dr(id,:);
      end
      function out = ColIsFree(column,board)
      % Vratí true jestli je sloupec volný.      
          out = true; 
          if( sum(board(:,column) == 0) == 0 )
            out  = false;
          end  
      end
      function [new_board,pos] = SimulatePlaceStone(id,column,board)
           % vrati novy board s kamenem umístenym do sloupce column
            if( ~GameBoard.ColIsFree(column, board))
                error("Column is full.")
            end 
            top = GameBoard.GetTopFreePosition(column,board);
            new_board = board;
            new_board(top,column) = id; 
            pos = [top, column];
      end   
      function top = GetTopFreePosition(column,board)
      % na jakou pozici vam spadne kamen 
            if( ~GameBoard.ColIsFree(column, board))
                error("Column is full.")
            end 
            top = find(board(:,column)== 0,1,'last');    
      end
      function out = GetOponent(id)
          % vrati cislo oponenta
           out = mod(id,2) +1;
      end
      function out = GetOpositeDirection(dir_id)
         % vrati opacny smer k vasemu smeru 
         out = mod((dir_id-1 + 4),8) +1;
      end
      function [count,next_values] = CountStonesInDir(board, pos, direction_id,player_id)       
          % spocita pocet kamenu typu player_id kolem pozice pos [radek,
          % sloupec] ve smeru direction [1-narohu, 2 - diagonalo, 3- vpravo
          % , 4 - 2.diagonala
          % vraci pocet, next_values - sousedi
          count= 0;
          if(GameBoard.InMatrix(pos,size(board)) ...
                 && board(pos(1),pos(2)) == player_id)
            count = count+1;
          end
          [count_dir, next_value1] = GameBoard.CountStonesInOneDir(board,pos, direction_id, player_id);
          count = count + count_dir;
          op_dir = GameBoard.GetOpositeDirection(direction_id);
          [count_dir, next_value2] = GameBoard.CountStonesInOneDir(board,pos, op_dir, player_id);                   
          count = count + count_dir;
          next_values = [next_value1,next_value2];
      end
      
      function [countSame, next_value] = CountStonesInOneDir(board, pos, dir_id,value)       
          % spocita pocet kamenu typu player_id kolem pozice pos [radek,
          % sloupec] ve smeru direction [1-narohu, 2 - vpravo nahoru, 3- vpravo
          % , 4 - 2.diagonala, 5 - dolu
          countSame = 0;
          new_pos = pos + GameBoard.Direction(dir_id);
          while( GameBoard.InMatrix(new_pos,size(board)) ...
                 && board(new_pos(1),new_pos(2)) == value)
              countSame = countSame+1;
              new_pos = new_pos + GameBoard.Direction(dir_id);
          end  
          if(GameBoard.InMatrix(new_pos,size(board)))
             next_value = board(new_pos(1),new_pos(2));               
          else
             next_value = -1;
          end          
      end
      
      function inmtr = InMatrix(pos,sz_matrix)        
          %test jestli nejsem mimo pole 
          inmtr = pos(1) > 0 & pos(2) > 0 & pos(1) <= sz_matrix(1) & pos(2) <= sz_matrix(2);
      end 
      
      function fours = CheckFours(board,pos)
            % zjisti, jestli na pozici pos neni 4
            fours = false;
            value = board(pos(1),pos(2));
            for k = 1:4

                c = GameBoard.CountStonesInDir(board, pos,k,value);
                if(c >=4)
                    fours = true;
                    break;
                end            
            end                       
        end
    end
    % konec statickych metod
    methods
        function obj = GameBoard()
             obj.Board = zeros([6 7]);                         
        end 
        
        function obj = Init(obj,playersList)                                  
            obj.Board = zeros([6 7]);
            obj.playersList = playersList;           
            obj.GameState = 0;
        end
        function obj = Play(obj,id)
             if(obj.GameState ~= 0)
                 warning('Game is ended.')
                 return
             end
             % call AI functions
            
            try
                column = obj.playersList(id).PlayStone(obj.Board,id);
                pos = obj.PlaceStone(column,id);
                if(GameBoard.CheckFours(obj.Board,pos))
                    obj.End("Four stones in rows",id);
                    return
                end  
            catch err
                obj.End("Error in program: " + err.message,mod(id,2)+1);
                return
            end                                                                                        
        end
        function board = getBoard(obj)
            board = obj.Board;
        end
            
        function Draw(obj)
           disp(obj.Board)
        end
                
    end
    
    methods(Access = private)
        function End(obj,message,id)
            obj.GameState = id; 
            obj.playersList(id).Winner();
            disp(strcat('Won player: ',num2str(id),' won. Score:',num2str(obj.playersList(id).Score),message));
            obj.playersList(id).Winner();
        end
        
        function pos = PlaceStone(obj,column, id)
            if( ~GameBoard.ColIsFree(column, obj.Board))
                error("Column is full.")
            end 
            top = find(obj.Board(:,column)== 0,1,'last');
            obj.Board(top,column) = id;
            pos = [top,column];
            
        end                             
        
    end
end

