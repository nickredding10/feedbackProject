function param = param()


param.PLL_order = 3;
    %% File Parsing Parameters 
    param.fileName = 'orens_second_signal.iq';
    %param.quantization = 'float32';
    param.sampleRate = 12.5e6; % Hz
    param.msToProcess = 5000; 
    param.complex = 1; 
    param.dataType = 'int16';

    msToSkip = 100;
    param.bytes_to_skip = msToSkip*(1e-3)*param.sampleRate*2*4;
    
    %% Acquisition Parameters
    param.cohT = 1;
    param.noncohT = 1; 
    param.PRN = 27;%[1 7 8 9 14 21 27 28 30];%[5 6 11 12 17];%[6 11 12 19 20]; %6 11 12 19 
    param.plotACF = 0;
    param.dopBins = [-5000:500:5000];

    %% Tracking Parameters
    param.dllNoiseBandwidth = 3; %3 %9
    param.pllNoiseBandwidth = 18;
    param.dllCorrelatorSpacing = 0.5; %0.5 % 0.8
    param.IF = 0;
end