
clear;
clc;

Accuracy = 0;
Evasion = 25;


Power = 25;
Toughness = 25;
Armor = 10;

for k = 50:50
    maxVal(k) = k+50;
    for j = 1:maxVal(k)
        rand1(j) = j;
        ToHit = Accuracy - Evasion + rand1(j);
        for i = 1:maxVal(k)
            rand2(i) = i;

            Roll = Power + rand2(i) - Toughness - Armor;
            Result(i) = (Power + rand2(i) - Toughness - Armor)/(Power + rand2(i));
            if (ToHit < 0) || (Result(i) < 0)
                Result(i) = 0;
            end
        end
        Effect(j) = sum(Result)/length(Result);
    end
    Value(k) = sum(Effect)/length(Effect);
end
figure(1);
plot(Effect);

figure(2);
plot(Result);

figure(3);
plot(maxVal,Value);