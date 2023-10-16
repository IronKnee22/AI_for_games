classdef GameBoard < hgsetget
    %SNAKE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = protected)                
        Board        
        % 0 - volno,1 - zed, 2 - jidlo,3-roh 100 a víc
        
    end
    
    properties(Access = private)                
        snakeList        
        visionDistance
    end
    
    methods
        function obj = GameBoard(size)
             obj.Board = zeros(size);            
             obj.createBoard();
        end 
        
        function obj = Init(obj,snakeList,numOfFood)            
            obj.visionDistance = 40;
            maxHunger = (size(obj.Board,1)+size(obj.Board,2));
            obj.snakeList = snakeList; 
            for k = 1:numOfFood
                ps = obj.getRandomFreePos();
                obj.Board(ps(1),ps(2)) = 2;
            end
            for k = 1:length(obj.snakeList)
                ps = obj.getRandomFreePos();
                obj.snakeList(k).InitPos(ps,maxHunger);
                obj.BoardUpdate();
            end
        end
        function obj = Step(obj)
             % call AI functions
             for k = 1:length(obj.snakeList)
                if(obj.snakeList(k).Active)
                    try
                       obj.snakeList(k).ComputeDirection(obj.getBoardForSnake(k,obj.visionDistance));
                    catch err
                        obj.snakeList(k).Die(err.message);                        
                        continue
                    end                    
                end
             end
             % move
             newFood = false;
             for k = 1:length(obj.snakeList)
                if(obj.snakeList(k).Active)                    
                    pos = obj.snakeList(k).NextPos();
                    if(obj.Board(pos(1),pos(2)) == 0 || obj.Board(pos(1),pos(2)) >= 100)
                        obj.snakeList(k).Move();
                        continue;
                    end
                    if(obj.Board(pos(1),pos(2)) == 2)
                        obj.snakeList(k).MoveEat();
                        newFood = true;
                        continue;
                    end
                    obj.snakeList(k).Die('Kolize se zdí');                    
                end
            end
            obj.BoardUpdate();
            colisionBoard = obj.createColisionBoard();
            for k = 1:length(obj.snakeList)                
                if(obj.snakeList(k).Active)
                    pos = obj.snakeList(k).Position(1,:);
                    if(colisionBoard(pos(1),pos(2)) > 1)
                        obj.snakeList(k).Die('Støet s hadem');                        
                        continue;
                    end               
                end
            end
            if(newFood)
               ps = obj.getRandomFreePos();
               obj.Board(ps(1),ps(2)) = 2;
            end
                
           
        end
        function Draw(obj)
           tmpBoard = obj.Board;
           szB = size(tmpBoard,2)+1;
           for k = 1:length(obj.snakeList) %nahraju hady
               id = (k-1) * 3 + 1;
               tmpBoard(id,szB) = k +200;
               tmpBoard(id+1,szB) = k +100;                                             
            end
           
           imagesc(tmpBoard);
           
           sL = length(obj.snakeList);
           cmap = zeros(200+sL,3);
           cmap(1,:) = [0.8 1 0.8]; %pozadi
           cmap(2,:) = [0 0 0];
           cmap(3,:) = [0 0.3 0]; %jidlo
           
           for k = 1:sL
            cmap(100+k+1,:) = obj.snakeList(k).Color;
            cmap(200+k+1,:) = abs(obj.snakeList(k).Color-0.2);
           end
           colormap(cmap);
          % caxis([0 200+sL]);
           axis equal;
           axis off;
        end
        
        function obj = BoardUpdate(obj)
            obj.Board(obj.Board >= 100) = 0; %vymazu hady
            for k = 1:length(obj.snakeList) %nahraju hady
                pList = obj.snakeList(k).Position;
                psize = size(pList);
                if(psize>0)
                    obj.Board(pList(1,1),pList(1,2)) = k+200;
                end
                for pid = 2:psize(1)
                    obj.Board(pList(pid,1),pList(pid,2)) = k+100;
                end
                
            end
        end
    end
    
    methods(Access = private)
        function cb = createColisionBoard(obj)
            cb = obj.Board;
            cb(obj.Board >= 100) = 0; %vymazu hady
            cb(obj.Board == 2) = 0; %vymazu jidlo
            for k = 1:length(obj.snakeList) %nahraju hady
                pList = obj.snakeList(k).Position;
                psize = size(pList);
                for pid = 1:psize(1)
                    cb(pList(pid,1),pList(pid,2)) = cb(pList(pid,1),pList(pid,2)) + 1;
                end                
            end 
            
        end
        function obj = setSnakesPosition(obj)
            for k = 1:length(obj.snakeList)
                
            end
            
        end
        function obj = createBoard(obj)                   
               obj.Board(:,1) = 1;
               obj.Board(:,end) = 1;
               obj.Board(1,:) = 1;
               obj.Board(end,:) = 1;            
        end
        function board= getBoardForSnake(obj,snID,dist)
           b = obj.Board == 100+snID ;
           bh = obj.Board == 200+snID ;
           SE = strel('square', dist*2+1);
           vision = imdilate(b|bh,SE,'same');
           board = obj.Board.*vision;
           board(~vision) = -1;
           board(b) = 100;
           board(bh) = 200;
        end
        function pos = getRandomFreePos(obj)
            
            [r c] = find(obj.Board == 0);
            rid = randi([1 length(r)]);
            pos = [r(rid),c(rid)];          
        end
        
        
    end
end

