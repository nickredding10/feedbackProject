clear;clc;close all;


%% Parameters
    % Sample Rate
    % Quantization
    % File Name
    param = Param;

%% Load Signal File
    % Input: Parameters, Signal File
    % Output: Signal Data in double
    sigData = loadSig(param);


%% Perform Acquisition
    % Input: Integration Period
    % Output: Doppler, Code Shift
    acqRes = acquisition(sigData,param);
    
%% Perform Tracking
    trackRes = tracking(sigData,param,acqRes);

    prnI = 0;
    for prn = param.PRN
        prnI = prnI + 1;
       
        figure
        subplot(2,2,[1 2])
        %figure
        plot(trackRes(prnI).I_P,'.')
        hold on
        plot(trackRes(prnI).Q_P,'.')
        tit = sprintf('PRN %.02d',prn);
        title(tit,'FontSize',13)
        legend('IP','QP','FontSize',13)
        
        subplot(2,2,3)
        %figure
        plot(trackRes(prnI).codeFreq)
        title('Code Frequency')
        subplot(2,2,4)
        %figure
        plot(trackRes(prnI).carrFreq)
        title('Carrier Frequency')
    end

%% Position 