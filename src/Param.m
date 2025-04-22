function param = param()

    %% File Parsing Parameters 
    param.fileName = 'orens_second_signal.iq';
    param.quantization = 'float32';
    param.sampleRate = 20e6; % Hz
    param.msToProcess = 10; 
    param.complex = 1; 
    param.dataType = 'int16';

    msToSkip = 10000;
    param.bytes_to_skip = msToSkip*(1e-3)*param.sampleRate*2;
    
    %% Acquisition Parameters
    param.cohT = 1;
    param.noncohT = 1; 
end