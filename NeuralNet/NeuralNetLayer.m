classdef NeuralNetLayer
    properties
        A;
        B;
        
        
    end
    methods
        function obj = NeuralNetLayer(Input,Output)
            %constructor
            Loutput = length(Output);
            Linput = length(Input);
            obj.A = zeros(Loutput,Linput);
            obj.B = zeros(Loutput,1);

            for i = 1:Loutput
                for j = 1:Linput
                    obj.A(i,j) = rand();
                end
                obj.B(i) = rand();
            end
        end
        function S = Calculate(obj,Input)
            N = obj.A*Input + obj.B;
            S = 1./(1+exp(-N));
            %dS/dZ = S*(1-S);
        end
        function D = Derivative(obj,Input)
            
            
        end
    end
    
    
    
    
    
    
end








function [ output_args ] = untitled( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end

