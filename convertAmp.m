function s = convertAmp(str1)
%     fprintf(fgen,'SOURCE1:VOLT 2');
    
    s0 = 'SOURCE1:VOLT ';
    
    s = [s0 num2str(str1)];
end
    