function param = param()

    %% File Parsing Parameters 
    param.fileName = 'orens_second_signal.iq';
    %param.quantization = 'float32';
    param.sampleRate = 5e6; % Hz
    param.msToProcess = 5000; 
    param.complex = 1; 
    param.dataType = 'float32';

    msToSkip = 100;
    param.bytes_to_skip = msToSkip*(1e-3)*param.sampleRate*2;
    
    %% Acquisition Parameters
    param.cohT = 1;
    param.noncohT = 1; 
    param.PRN = [6 11 12 19 20];
    param.plotACF = 0;
    param.dopBins = [-5000:5:5000];

    %% Tracking Parameters
    param.dllNoiseBandwidth = 1;
    param.pllNoiseBandwidth = 25;
    param.dllCorrelatorSpacing = 0.1;
    param.IF = 0;
end