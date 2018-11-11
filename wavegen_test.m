fgen = visa('AGILENT','GPIB0::10::INSTR');
set (fgen,'OutputBufferSize',100000);
fgen.Timeout=20;
fopen(fgen);

fprintf (fgen, '*IDN?');
idn = fscanf (fgen);
fprintf (idn)
fprintf ('\n\n')

fprintf (fgen, '*RST');
fprintf (fgen, '*CLS');

a = 1:1:20;
start=200;
stop=600;

for j=1:1:20
    a(j) = start;
    start = start + ((stop-start)/20)*j ;
    
    fprintf(fgen,'SOURCE1:FUNCTION SIN');
    fprintf(fgen,convertStr(start));
    fprintf(fgen,'SOURCE1:VOLT:UNIT VPP');
    fprintf(fgen,convertAmp(10));
    fprintf(fgen,'SOURCE1:VOLT:OFFSET 0');
    fprintf(fgen,'OUTPUT1:LOAD 50');
    fprintf(fgen,'OUTPUT1 ON');
    
    pause(200);
     
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

fclose(fgen);
delete(fgen);