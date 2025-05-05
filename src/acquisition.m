function out = acquisition(sigData, param)

dopBins = param.dopBins';%[-2400-50 : 0.1 : -2400+50]';
time = 0:1/param.sampleRate:0.001-1/param.sampleRate;

carrRep = exp(-1j*dopBins*time*2*pi);
p_idx = 0;
for prn = param.PRN
    
    p_idx = p_idx + 1;
    ca = genCACODE(prn);
    ca = ca(:,ceil(1.023e6/param.sampleRate: 1.023e6/param.sampleRate :1023));
    res = abs(ifft2(fft2(carrRep.*sigData(1:12500)).*conj(fft(ca))));
    
    if param.plotACF == 1
        figure;
        surf(1:5000,dopBins,res,'LineStyle','none');
    end
    [~, frequencyBinIndex] = max(max(res, [], 2));
    [peakSize(p_idx), codePhase] = max(max(res));

    out.acqDop(p_idx) = dopBins(frequencyBinIndex);
    out.acqTau(p_idx) = codePhase;
    out.PRN(p_idx) = prn;
end
figure
bar(param.PRN,peakSize);
title('Acquisition Results','FontSize',13)
xlabel('PRN #','FontSize',13)
ylabel('Correlation Strength','FontSize',13)
grid on
end