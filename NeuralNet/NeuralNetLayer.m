classdef NeuralNetLayer
    properties
        A;
        b;
    end
    methods
        function obj = NeuralNetLayer(Input,Output)
            %constructor
            obj.A = zeros(Output,Input);
            obj.b = zeros(Output,1);

            for i = 1:Output
                for j = 1:Input
                    obj.A(i,j) = 0.01*rand();
                end
                obj.b(i) = 0.01*rand();
            end
        end
        function S = CalculateLayer(obj,x)
            Y = obj.A*x + obj.b;
            S = 1./(1+exp(-Y));
        end
        function dS = dS(obj,x)
            Y = obj.A*x + obj.b;
            S = 1./(1+exp(-Y));
            dS = S.*(1-S);
        end
        function obj = Update(obj,dCdW,dCdb,LearningRate,Regulation,BatchSize)
            obj.A = obj.A + LearningRate*dCdW/BatchSize - Regulation/BatchSize*obj.A;
            obj.b = obj.b + LearningRate*dCdb/BatchSize;
        end
    end
        
end

