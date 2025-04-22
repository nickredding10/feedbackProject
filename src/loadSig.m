function data = loadSig(param)

    simT = param.msToProcess*(1e-3)*param.sampleRate*2 +param.cohT*param.noncohT*param.sampleRate*(1e-3)*2;
    %% simT = inf; FOR WHOLE FILE
    [fid, message] = fopen(param.fileName, 'rb');
    fseek(fid,param.bytes_to_skip,'bof');
    data11 = fread(fid, simT, param.dataType);
    %data11 = data11';
    if param.complex == 1
        Idata = data11(1:2:end);
        Qdata = data11(2:2:end);
    
        data = Idata + 1i.* Qdata;
    else
        data = data11;
    end
    data = data';

end