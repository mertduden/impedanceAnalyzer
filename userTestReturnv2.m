function [a,phase,reactance]=userTestReturnv2(start,stop,amp,data_points,r)

fgen = visa('AGILENT','GPIB0::10::INSTR');
set (fgen,'OutputBufferSize',100000);
fgen.Timeout=20;
fopen(fgen);

%MSO-2014A

mso = visa('AGILENT','GPIB0::7::INSTR');
set (mso,'OutputBufferSize',100000);
mso.Timeout=20;
fopen(mso);

%Query Idendity string and report
fprintf (fgen, '*IDN?');
idn = fscanf (fgen);
fprintf (idn)
fprintf ('\n\n')
%Query Idendity string and report
fprintf (mso, '*IDN?');
idn = fscanf (mso);
fprintf (idn)
fprintf ('\n\n')

%Clear and reset instrument
fprintf (fgen, '*RST');
fprintf (fgen, '*CLS');
%Clear and reset instrument
fprintf (mso,'*RST');
fprintf (mso,'*CLS');

fprintf(mso,':ACQuire:TYPE NORMal');

%Select the waveform shape, amplitude and offset
fprintf(fgen,'SOURCE1:FUNCTION SIN');
fprintf(fgen,'SOURCE1:VOLT:UNIT VPP');
fprintf(fgen,convertAmp(amp));

%Select the frequency boundaries of the sweep
fprintf(fgen,convertStart(start));
fprintf(fgen,convertStop(stop));

%Select the sweep mode
fprintf(fgen,'SOURCE1:SWEEP:SPACING LINEAR');

%Set the sweep time in seconds.
fprintf(fgen,'SOURCE1:SWEEP:TIME 5');

%Select the sweep trigger source
fprintf(fgen,'TRIGGER1:SOURCE IMM');

%Enable Sweep State.
fprintf(fgen,'SOURCE1:SWEEP:STATE ON');

%Enable output.
fprintf(fgen,'OUTPUT1 ON');

 a = 1:1:data_points;
 chan1 = 1:1:data_points; %voltage at chan1
 chan2 = 1:1:data_points; %voltage at chan2
 voltage1 = 1:1:data_points;
 voltage2 = 1:1:data_points;
 resistor = 1:1:data_points; %constant value, resistor R
 reactance = 1:1:data_points;
 phase = 1:1:data_points;
 current = 1:1:data_points; %current flowing at the test circuit
 complex = 1:1:data_points;
 
 
 
for j=1:1:data_points
%     fprintf(mso,'MEASure:FREQuency CHAN1');
%     a(j) = str2double(query(mso,'MEASure:FREQuency? CHAN1'));

    a(j) = start + ((j-1)*((stop-start)/data_points));
    
    resistor(j) = r;      
    fprintf(mso,'MEASure:VPP CHAN1');
    chan1(j) = str2double(query(mso,'MEASure:VPP? CHAN1'));
    
    fprintf(mso,'MEASure:VPP CHAN2');
    chan2(j) = str2double(query(mso,'MEASure:VPP? CHAN2'));
    
    phase(j) = atand((chan1(j)-chan2(j))/chan2(j));
    reactance(j) = resistor(j)*tand(phase(j));

    
    pause('on')
    pause(2/(data_points))
    pause('off')
    
    
end 
fprintf(fgen, 'SYST:ERR?');
errorstr = fscanf (fgen);

% error checking
if strncmp (errorstr, '+0,"No error"',13)
errorcheck = 'Waveform generated without any error \n';
fprintf (errorcheck)
else
errorcheck = 'There is a error \n';
fprintf (errorcheck)
end


%closes the visa session with the function generator
fclose(fgen);
delete(fgen);
fclose(mso);
delete(mso);

end