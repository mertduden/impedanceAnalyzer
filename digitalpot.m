function position = digitalpot(pot_r)
a = arduino('com6', 'uno', 'Libraries', 'SPI');
d_pot = spidev(a, 'D10');
Rab = 10*1000;
Rw = 50;     % actual wiper resistance
position=round(256-(((pot_r-(3*Rw))/Rab))*256);
writeRead(d_pot, position, 'uint8');
fprintf('Current resistance is %d Ohm\n', pot_r);


end