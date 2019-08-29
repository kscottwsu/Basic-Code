clear;
clc;

Angle = 90;
C = 0.02*0.01/0.0101;
Base = 100;
iMax = 1000;
StatMax = 1000;

A = C*cosd(Angle);
B = C*sind(Angle);
estimatedPeak = A/(A+B);
for i = 1:iMax
    X(i) = StatMax*i/iMax;
    Y(i) = StatMax*(1-i/iMax);

    K1 = (X(i)+Y(i))/((X(i)^2 + Y(i)^2)^0.5); % converts from linear to unit circle values
    T1(i) = exp(A*K1*X(i) + B*K1*Y(i));
end

index = find(T1 == max(T1));


hold on
plot(X./StatMax,T1);
plot(X(index)./StatMax, T1(index),'x');

growthRate = exp(B*(Y(i)+1) - B*Y(i)) - 1;
disp(growthRate);
growthRate = exp(A*(X(i)+1) - A*X(i)) - 1;
disp(growthRate)