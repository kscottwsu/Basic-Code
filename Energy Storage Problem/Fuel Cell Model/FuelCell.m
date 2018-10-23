function [ Flow,Oxy,PFuelCell, QFuelCell, Vfc, J,CellEff,OxiEff,ErrorFlag ] = FuelCell( Flow, P,FuelUtilization,bDisp)
Ru = 8.3145;
F = 96485.332;%faraday constant C/mol
ASR = 0.21 + 0.1;%account for resistance increases from stack
Hchannel = 1e-3;
Thickness = 50e-6;


[Flow] = FuelCellInitialize(Flow);

J = (Flow.CH4*4+Flow.CO+Flow.H2)*FuelUtilization*2*F;
Oxy.T = Flow.T;
Oxy.O2 = J/(4*F);%1 O for each H2 molecule, 2O per O2, 2 e- per O.

n = 100;
T = Flow.T;
Flow.T = 298;
h1 = enthalpy(Flow);
Flow.T = T;

[Flow,Qindirect] = ChemicalEquilibrium(Flow,P/100);

i = J*ones(1,n)/n;%total current in each differential area

ErrorFlag = 0;
check = 0;
count = 0;
while check == 0
    Flow2 = Flow;
    count = count + 1;
    for k = 1:n
        H2(k) = Flow2.H2;
        H2O(k) = Flow2.H2O;
        CO(k) = Flow2.CO;
        CO2(k) = Flow2.CO2;
        CH4(k) = Flow2.CH4;
        C(k) = Flow2.C;
        [D] = DiffusionCoefficient(Flow2,P);
        
        X.H2 = Flow2.H2/NetFlow(Flow2);
        X.H2O = Flow2.H2O/NetFlow(Flow2);
        X.O2 = 1;
        X.T = Flow2.T;
        
        [E0,VNernst] = NernstVoltage(X,P);
        
        CurrentDensity = i(k)*n;
         
        
        Xs.H2 = X.H2 - Ru*Flow.T*10^4*CurrentDensity*Hchannel/(8*F*(1000*P)*D.H2);
        Xs.H2O = X.H2O + Ru*Flow.T*10^4*CurrentDensity*Hchannel/(8*F*(1000*P)*D.H2O);
        Xs.O2 = 1 - Ru*Flow.T*10^4*CurrentDensity*Hchannel/(8*F*(1000*P)*D.O2);
        
        Xtpb.H2 = Xs.H2 - Ru*Flow.T*10^4*CurrentDensity*Thickness/(2*F*(1000*P)*D.H2Eff);
        Xtpb.H2O = Xs.H2O + Ru*Flow.T*10^4*CurrentDensity*Thickness/(2*F*(1000*P)*D.H2OEff);
        Xtpb.O2 = Xs.O2 - Ru*Flow.T*10^4*CurrentDensity*Thickness/(4*F*(1000*P)*D.O2Eff);

        VDiffusionAnode = -(Ru*Flow.T/(2*F))*log((X.H2O*Xtpb.H2)/(Xtpb.H2O*X.H2));
        VDiffusionCathode = (Ru*Flow.T/(2*F))*log(X.O2/Xtpb.O2);
        Vdiff(k) = VDiffusionAnode+VDiffusionCathode;
        VOhm = CurrentDensity*ASR;
        
        Flow2.H2 = Flow2.H2 - i(k)/(2*F);
        Flow2.H2O = Flow2.H2O + i(k)/(2*F);
        [Flow2,Qdirect(k)] = ChemicalEquilibrium(Flow2,P/100);
       
        Voltage(k) = E0 + VNernst - VOhm - VDiffusionAnode - VDiffusionCathode;
    end
    error = (Voltage - mean(Voltage))/(ASR);
    i = i.*(1+error);
    i = i*(J/sum(i));
    if max(abs(Voltage-mean(Voltage)))<1e-5 || count > 10000
        check = 1;
        if max(abs(Voltage-mean(Voltage)))>1e-5
            ErrorFlag = 1;
        end
    end
    if isnan(Voltage(1))
        ErrorFlag = 1;
        check = 1;
    end
end
Vfc = mean(Voltage);

h = enthalpy(298);
hrxn1 = h.H2O-h.H2-h.O2/2; %H2 + O2/2 -->  H2O, ion transfer
hrxn2 = h.CO2+h.H2-h.CO-h.H2O; %CO + H20 --> CO2 + H2, Water Gas Shift
hrxn3 = 3*h.H2+h.CO-h.CH4-h.H2O; %CH4+H2O --> CO + 3H2, Methane reforming

RFC = J/(2*F);
QOxidation = -RFC*hrxn1 - J*Vfc;

Flow = Flow2;


T = Flow.T;
Flow.T = 298;
h2 = enthalpy(Flow);
Flow.T = T;

delh = (h2-h1-(RFC*h.O2/2));

QFuelCell = QOxidation + 1000*Qindirect + 1000*sum(Qdirect);
PFuelCell = J*Vfc;%power in watts/cm^2
CellEff = PFuelCell/(-delh);
OxiEff = PFuelCell/(-RFC*hrxn1);
if QFuelCell < 0
    CellEff = PFuelCell/(-delh-QFuelCell);
    OxiEff = PFuelCell/(-RFC*hrxn1-QFuelCell);
end


if bDisp == 1
    NX = (1:n)/n;

    figure(101)
    plot(NX,n*i,'LineWidth',2);
    xlabel('Normalized Position');
    ylabel('Current Density (A/cm^2)');

    nH2 = H2./(H2+H2O+CO+CO2+CH4+C);
    nH2O = H2O./(H2+H2O+CO+CO2+CH4+C);
    nCO = CO./(H2+H2O+CO+CO2+CH4+C);
    nCO2 = CO2./(H2+H2O+CO+CO2+CH4+C);
    nCH4 = CH4./(H2+H2O+CO+CO2+CH4+C);
    nC = C./(H2+H2O+CO+CO2+CH4+C);

    figure(102)
    plot(NX,nH2O,'LineWidth',2);
    hold on
    plot(NX,nH2,'LineWidth',2);
    plot(NX,nCO,'LineWidth',2);
    plot(NX,nCO2,'LineWidth',2);
    plot(NX,nCH4,'LineWidth',2);
    plot(NX,nC,'LineWidth',2);
    hold off
    xlabel('Normalized Position');
    ylabel('Molar Fraction');
    legend('H2O','H2','CO','CO2','CH4','C');
    ylim([0 max(nH2O)+0.1]);
end
end

function [Flow] = FuelCellInitialize(Flow)
if ~isfield(Flow,'CO')
    Flow.CO = 0;
end
if ~isfield(Flow,'CO2')
    Flow.CO2 = 0;
end
if ~isfield(Flow,'CH4')
    Flow.CH4 = 0;
end
if ~isfield(Flow,'H2O')
    Flow.H2O = 0;
end
if ~isfield(Flow,'H2')
    Flow.H2 = 0;
end
if ~isfield(Flow,'C')
    Flow.C = 0;
end

end