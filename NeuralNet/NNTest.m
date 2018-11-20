function  NNTest
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


HiddenWidth = 2;
Layers = 3;

Inputs = 2;
Outputs = 1;

NN = NeuralNetwork(Inputs,Outputs,HiddenWidth,Layers);
for i = 1:5e4
    for j = 1:4
        if j == 1
            SInput = [1,0]';
            SOutput = 0;
        elseif j == 2 
            SInput = [0,1]';
            SOutput = 0;
        elseif j == 3
            SInput = [1,1]';
            SOutput = 1;
        elseif j == 4
            SInput = [0,0]';
            SOutput = 0;
        end
        NN = NN.Train(SInput,SOutput);
    end
    Output = NN.Calculate([1,0]);
    Error(i) = Output-0;
    Output = NN.Calculate([0,1]);
    Error2(i) = Output-1;
end



hold on
plot(Error,'+');
plot(Error2,'o');
end

