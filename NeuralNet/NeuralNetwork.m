classdef NeuralNetwork
    properties
       LayerArray;%array of NNLayers
       Layers;
       Learning = 1;%Learning Rate
       Regulation = 0;%Regulation parameter

    end
    
    methods
        function obj = NeuralNetwork(Inputs,Outputs,HiddenWidth,Layers)
            obj.Layers = Layers;
            obj.LayerArray = NeuralNetLayer.empty(0,Layers);
            for i = 1:Layers
                if i == 1
                    obj.LayerArray(i) = NeuralNetLayer(Inputs,HiddenWidth);
                elseif i == Layers
                   obj.LayerArray(i) = NeuralNetLayer(HiddenWidth,Outputs);
                else
                   obj.LayerArray(i) = NeuralNetLayer(HiddenWidth,HiddenWidth);
                end  
            end
        end
        
        function Output = Calculate(obj,Input)
            for i = 1:length(obj.LayerArray)
                if i == 1
                    Output = obj.LayerArray(i).CalculateLayer(Input);
                else
                    Output = obj.LayerArray(i).CalculateLayer(Output);
                end
            end
        end
        
        function [dCdW,delta] = GenerateCoefs(obj,Input,OutputDesired)
            Output = cell(obj.Layers,1);
            for i = 1:obj.Layers
                if i == 1
                    Output{i} = obj.LayerArray(i).CalculateLayer(Input);
                else
                    Output{i} = obj.LayerArray(i).CalculateLayer(Output{i-1});
                end
            end
            for i = obj.Layers:-1:1
                if i == obj.Layers
                    dCosta = OutputDesired./Output{i};%derivative of Cost function
                    dCostb = - (1-OutputDesired)./(1-Output{i});
                    if isnan(dCosta)
                        dCosta = 1;%l'hopital's rule
                    end
                    if isnan(dCostb)
                        dCostb = 1;
                    end% A = Inputs x Outputs
                    dCost = dCosta + dCostb;
                    delta{i} = dCost.*obj.LayerArray(i).dS(Output{i-1});
                    dCdW{i} = delta{i}*Output{i-1}';
                elseif i ~= 1
                    delta{i} = (obj.LayerArray(i+1).A'*delta{i+1}).*obj.LayerArray(i).dS(Output{i-1});
                    dCdW{i} =  delta{i}*Output{i-1}';
                elseif i == 1
                    delta{i} = (obj.LayerArray(i+1).A'*delta{i+1}).*obj.LayerArray(i).dS(Input);
                    dCdW{i} = delta{i}*Input';
                end
            end    
        end
        
        function obj = Train(obj,InputArray,OutputDesiredArray)
            [~,Batchsize] = size(InputArray);
            for i = 1:Batchsize
                [dCdW{i},delta{i}] = GenerateCoefs(obj,InputArray(:,i),OutputDesiredArray(:,i));
                [TdCdW, Tdelta] = 
            end
            for j = 1:obj.Layers
                obj2.LayerArray(j) = obj2.LayerArray(j).Update(dCdW{j},delta{j},obj2.Learning,obj2.Regulation,Batchsize);
            end
        end
    end
    
end

