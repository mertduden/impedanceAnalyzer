%%% Impedance Calculation on in series RL Circuit
%%% Author: Ilyas Mert D�den

function [phase,reactance]=impedance_RL(R,L,F)

reactance = 2*pi*F*L;
phase = atand(reactance/R);
end


