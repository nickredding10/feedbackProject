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
    acqResults = acquisition(sigData,param);
    
%% Perform Tracking
