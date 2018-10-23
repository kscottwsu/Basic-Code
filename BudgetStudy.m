function BudgetStudy( )

imax = 10000;

for i = 1:imax
    Perk401K(i) = 0.22*(i-1)/imax;
    Output = BudgetAnalysis(Perk401K(i));
    NetMonthlyIncome(i) = Output.NetMonthlyIncome;
    EffTaxRate(i) = Output.effTaxRate;
    RMoneyEnd(i) = Output.RMoneyExtended;
    RMoneyStart(i) = Output.RMoneyImmediate;
end

n = find(RMoneyStart>82014,1);


figure(1)
yyaxis left
plot(Perk401K,NetMonthlyIncome)
hold on
plot(Perk401K(n),NetMonthlyIncome(n),'o')
hold off
ylim([0,max(NetMonthlyIncome)+500])
yyaxis right
plot(Perk401K,RMoneyStart)
hold on
xlim([0,0.22])
ylim([0,max(RMoneyStart)*1.1])
plot(Perk401K(n),RMoneyStart(n),'o');
hold off

disp(Perk401K(n));


figure(2)
plot(Perk401K,EffTaxRate);


end
