%dice roll distributions
nTest = 1000000;

%% success counts with success count based difficulty
DC = 30;%-25 = very easy, 25 = very difficult
modifier = 20;

%Modifier = (1 or 0.5)*Primary Stat + (0 or 0.5)*Secondary Stat + 10*Skill Rank
%average stat value is ~20

%-> Modifier = ~20 + 10*Skill Rank



successes = zeros(nTest,1);
for j = 1:nTest
    for i = 1:3
       roll =  100*rand() + modifier;
       if roll >= DC +45 +10*successes(j)
           successes(j) = successes(j) + 1;
       end
    end
end

modifier = 30;

successes2 = zeros(nTest,1);
for j = 1:nTest
    for i = 1:3
       roll =  100*rand() + modifier;
       if roll >= DC +45 +10*successes2(j)
           successes2(j) = successes2(j) + 1;
       end
    end
end


modifier = 40;

successes3 = zeros(nTest,1);
for j = 1:nTest
    for i = 1:3
       roll =  100*rand() + modifier;
       if roll >= DC +45 +10*successes3(j)
           successes3(j) = successes3(j) + 1;
       end
    end
end


modifier = 50;

successes4 = zeros(nTest,1);
for j = 1:nTest
    for i = 1:3
       roll =  100*rand() + modifier;
       if roll >= DC +45 +10*successes4(j)
           successes4(j) = successes4(j) + 1;
       end
    end
end


modifier = 60;

successes5 = zeros(nTest,1);
for j = 1:nTest
    for i = 1:3
       roll =  100*rand() + modifier;
       if roll >= DC +45 +10*successes5(j)
           successes5(j) = successes5(j) + 1;
       end
    end
end


figure(1)
hold off
h1 = histogram(successes,'Normalization','probability');

hold on
%h2 = histogram(successes2,'Normalization','probability');

h3 = histogram(successes3,'Normalization','probability');

%h4 = histogram(successes4,'Normalization','probability');

h5 = histogram(successes5,'Normalization','probability');
legend('show');






