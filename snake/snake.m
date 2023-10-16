classdef snake < hgsetget
    %SNAKE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private, GetAccess= public)                
        Color        
        Name
        Position
        Score
        SnakeLength
        Direction
        Active
        DeathReport
        TimeLimit
        Hunger
        MaxHunger
    end
   
    
    properties(Access = private)                
        hAIFunc
    end
    
    methods
        function obj = snake(Color,Name,hAIFunc )
            obj.Color = Color;
            obj.Name = Name;
            obj.hAIFunc = hAIFunc;                    
            obj.TimeLimit = 200;%0.05;            
            obj.Score = 0;
            obj.Active = true;
        end           
        function obj = InitPos(obj,pos,maxHunger)
            obj.Position = pos;
            obj.MaxHunger = maxHunger;
            obj.Hunger = maxHunger;
            obj.Active = true;
            obj.Direction = 0;
        end
        function pos = NextPos(obj)
            pos = obj.Position(1,:);
            switch(obj.Direction)
                case 1
                    pos = pos + [-1 0];
                case 2
                    pos = pos + [0 1];
                case 3
                    pos = pos + [1 0 ];
                case 4
                    pos = pos + [0 -1];
                otherwise
                    obj.Die('Zvolili jste spatny smer');
                    
            end
        end
        function obj = Move(obj)            
            obj.Position = cat(1,obj.NextPos(), obj.Position(1:end-1,:));            
            obj.Hunger = obj.Hunger - 1;
            if(obj.Hunger <= 0)
                obj.Die('Had umrel hladem');
            end
        end
        function obj = MoveEat(obj)
            obj.Position = cat(1,obj.NextPos(), obj.Position(1:end,:));            
            obj.Hunger = obj.MaxHunger;
        end
        function obj = Die(obj,report)
            obj.DeathReport = report;
            obj.Direction = 0;
            obj.Active = false;
            obj.Score = obj.Score + obj.SnakeLength;
        end
        function obj = ComputeDirection(obj,map)
            tic 
            d = obj.hAIFunc(map,obj.Position(1,:),obj.Direction);            
            tm = toc;
            
            if(d > 4 && d < 1)
                error([obj.Name,': Spatny smer']);
            end
            obj.Direction  = d;
            if(tm > obj.TimeLimit)
                error([obj.Name,': Vypocet trval moc dlouho']);
            end
        end
        function value = get.SnakeLength(obj)
            value = size(obj.Position,1);            
        end

    end
    
end

