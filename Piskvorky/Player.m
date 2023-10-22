classdef Player < hgsetget
    %SNAKE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private, GetAccess= public)                          
        Name      
        Score     
    end
   
    
    properties(Access = private)                
        hAIFunc
        TimeLimit
    end
    
    methods
        function obj = Player(Name,hAIFunc )     
            obj.Name = Name;
            obj.hAIFunc = hAIFunc;                                
            obj.Score = 0;
            obj.TimeLimit = 30000;
        end           
        function obj = Winner(obj)
           obj.Score = obj.Score +1; 
        end
        
        function D = PlayStone(obj,board,id)
            tic 
            D = obj.hAIFunc(board,id);            
            tm = toc;
        end
            
     
    end
    
end

