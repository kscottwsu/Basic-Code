function [Damage] = DamageCalc(Damage, Armor, Evasion, Block)
% K = (S+D)/((S^2 + D^2)^0.5); % converts from linear to unit circle values
% Damage = Base* exp(K*Sscaling*S + K*Dscaling*D);
AR = Armor/(Armor + 2*Damage);
if AR > 0.75
    AR = 0.75;
end
MaxDamage = Damage*(1-AR);
ER = Evasion/(Evasion + Damage);
MinDamage = MaxDamage*(1-ER);
Damage = max(MinDamage + (MaxDamage-MinDamage)*rand() - Block,0);
end

