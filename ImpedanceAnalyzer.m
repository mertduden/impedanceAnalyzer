function [f,v1,v2,phase]=ImpedanceAnalyzer(start,stop,amp,data_points)

%MSO-2014A

mso = visa('AGILENT','GPIB0::7::INSTR');
pause('on');


mso.InputBufferSize = 100000;
% Set the timeout value
mso.Timeout = 10;
% Set the Byte order
mso.ByteOrder = 'littleEndian';
% Open the connection
fopen(mso);

% Reset the instrument and autoscale and stop
fprintf(mso,'*RST; :AUTOSCALE'); 

% Wait till complete


%33522B Waveform Generator
fgen = visa('AGILENT','GPIB0::10::INSTR');
set (fgen,'OutputBufferSize',100000);
fgen.Timeout=20;
fopen(fgen);

%Query Idendity string and report
fprintf (fgen, '*IDN?');
idn = fscanf (fgen);
fprintf (idn) %prints *IDN? results to the screen
fprintf ('\n\n')

%Clear and reset instrument
fprintf (fgen, '*RST');
fprintf (fgen, '*CLS');
pause(2)
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
fprintf(fgen,'SOURCE1:SWEEP:TIME 145');

%Select the sweep trigger source
fprintf(fgen,'TRIGGER1:SOURCE IMM');

%Enable Sweep State.
fprintf(fgen,'SOURCE1:SWEEP:STATE ON');

%Enable output.
fprintf(fgen,'OUTPUT1 ON');

% Read Error
fprintf(fgen, 'SYST:ERR?');
errorstr = fscanf (fgen);

% error checking
if strncmp (errorstr, '+0,"No error"',13)
   errorcheck = 'Sweep Output enabled without any error';
   fprintf (errorcheck)
else
   errorcheck = ['Error reported: ', errorstr];
   fprintf (errorcheck)
end



for j=1:1:data_points
    
    
    v1(j) = str2double(query(mso,'MEASure:VAMP? CHAN1'));
    v2(j) = str2double(query(mso,'MEASure:VAMP? CHAN2'));
    phase(j) = str2double(query(mso,'MEASure:PHAS? CHAN1,CHAN2'));
    f(j) = start + ((stop-start)/data_points)*j-1;
    pause(0.12);
end


fclose(fgen);
delete(fgen);
fclose(mso);
delete(mso);
end