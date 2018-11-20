function [Output] = BudgetAnalysis( Perc401K )

%% Constants
BasePay = 82014;

%Insurance Costs, not deductible
HealthInsurance = 1205.6;
Vision = 12.36;
Dental = 0;

%HSA, deductible
MaxHSAD = 3450;
RaytheonHSA = 750;

%401K deductible
Max401KD = 18000;
Raytheon401K = 0.03;%4% after 5 years

MaxCHSA = MaxHSAD - RaytheonHSA;
MaxC401K = Max401KD/BasePay;


%%Income Tax Stuff
StdDeduction = 12000;
StdDeductionAz = 5099;
SS = 0.062;
Medicare = 0.0145;


FTaxBracketPerc = [0.1,0.12,0.22,0.24,0.32,0.35,0.37];
FTaxBracketVal = [9525,38700,82500,157500,200000,500000];

STaxBracketPerc = [0.0259,0.0288,0.0336,0.0424,0.0454];
STaxBracketVal = [10346,25861,51721,155159,9999999];



%% variables
CHSA = MaxHSAD-RaytheonHSA;
C401K = BasePay*Perc401K;





%%  Annual Pay
BasePay2 = BasePay - HealthInsurance - Vision - Dental;%these are pre-tax


BasePayF = BasePay2 - CHSA - C401K - StdDeduction;



n = find(FTaxBracketVal > BasePay2,1);

for i = 1:n
    if i ==1
        if BasePayF < FTaxBracketVal(1)
            fiTax = FTaxBracketPerc(1)*BasePayF;
        else
            fiTax = FTaxBracketPerc(1)*FTaxBracketVal(1);
        end
    elseif BasePayF>FTaxBracketVal(i)
        fiTax = fiTax + FTaxBracketPerc(i)*(FTaxBracketVal(i)-FTaxBracketVal(i-1));
    else
        fiTax = fiTax + FTaxBracketPerc(i)*(BasePayF-FTaxBracketVal(i-1));
    end
end

BasePayS = BasePay2 - StdDeductionAz-CHSA - C401K;

n = find(STaxBracketVal > BasePayS,1);

for i = 1:n
    if i ==1
        if BasePayS < STaxBracketVal(1)
            siTax = STaxBracketPerc(1)*BasePayS;
        else
            siTax = STaxBracketPerc(1)*STaxBracketVal(1);
        end
    elseif BasePayS>STaxBracketVal(i)
        siTax = siTax + STaxBracketPerc(i)*(STaxBracketVal(i)-STaxBracketVal(i-1));
    else
        siTax = siTax + STaxBracketPerc(i)*(BasePayS-STaxBracketVal(i-1));
    end
end


    
ssTax = min(SS*128400,SS*(BasePay-CHSA));
medTax = Medicare*(BasePay-CHSA);
    
Output.PostTaxIncome = BasePay-fiTax-ssTax-medTax-siTax-CHSA-C401K;
Output.effTaxRate = 1-Output.PostTaxIncome/(BasePay-CHSA-C401K);
Output.BiMonthlyPaycheck = Output.PostTaxIncome/26;

%% Monthly Budget

%Monthly Expenses
Rent = 865;
Electricity = 100;%assume average
Internet = 60;%assume average
Insurance = 200;%car and renters
Food = 600;%including eating out
Fun = 1000;%any misc fun purchases
MonthlyExpenses = Rent + Electricity + Internet + Insurance + Food + Fun;

MonthlyIncome = Output.PostTaxIncome/12;
Output.NetMonthlyIncome = MonthlyIncome-MonthlyExpenses;

%% 401K Value
TimeToRetirement = 65-28;
Rate401K = C401K + min(C401K,Raytheon401K*BasePay);
RoR = 0.05;
RMoney1 = 0;
RMoney2 = Rate401K;
for i = 1:TimeToRetirement
    RMoney1 = RMoney1*(1+RoR) + Rate401K;
    RMoney2 = RMoney2*(1+RoR);
end

Output.RMoneyExtended = RMoney1;
Output.RMoneyImmediate = RMoney2;
end

