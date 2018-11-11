%%% Impedance Calculation on in series RC Circuit
%%% Author: Ilyas Mert Düden

function [magnitude,phase,reactance]=impedance_RC(R,C,F)

reactance = 1/(2*pi*F*C);
magnitude = sqrt((R^2) + (reactance^2));
phase = atand(reactance/R);

end



