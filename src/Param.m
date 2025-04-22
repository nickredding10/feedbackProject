function param = param()

    %% File Parsing Parameters 
    param.fileName = 'orens_second_signal.iq';
    %param.quantization = 'float32';
    param.sampleRate = 5e6; % Hz
    param.msToProcess = 1; 
    param.complex = 1; 
    param.dataType = 'float32';

    msToSkip = 10;
    param.bytes_to_skip = msToSkip*(1e-3)*param.sampleRate*2;
    
    %% Acquisition Parameters
    param.cohT = 1;
    param.noncohT = 1; 
    param.PRN = [1:32];
    param.plotACF = 0;
    param.dopBins = [-5000:500:5000];
end