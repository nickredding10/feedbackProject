function trackRes = tracking(sigData,param,acqRes)

%% Initializations

dt = 0.001;
f_IF = param.IF;
codePeriods = param.msToProcess;

dllShift = param.dllCorrelatorSpacing;
zeta = sqrt(2)/2;
BW_DLL = param.dllNoiseBandwidth;
Wn_DLL = BW_DLL*8*zeta / (4*zeta.^2 + 1);
DLL_ki = Wn_DLL^2;
DLL_kp = (2*zeta/Wn_DLL)*DLL_ki;

BW_PLL = param.pllNoiseBandwidth;
Wn_PLL = BW_PLL*8*zeta / (4*zeta.^2 + 1);
PLL_ki = 4*Wn_PLL^2;
PLL_kp = (2*zeta/Wn_PLL)*PLL_ki;

chipping_rate(1:2) = 1.023e6;

prnI = 0;
for prn = param.PRN
    prnI     = prnI + 1;
    PLL_discrim_int(1:2) = 0;
    DLL_discrim_int(1:2) = 0;
    phase_shift(1:2) = 0;
    pll_err(1:2) = 0;
    remCode = 0;
    doppler_shift(1:2) = acqRes.acqDop(prnI) - f_IF;
    acqCodePhase = acqRes.acqTau(prnI);
    accumulate = acqCodePhase;


    
    ca = genCACODE(prn);
    codeLength = length(ca);
    ca = [ca(end) ca ca];
    %% Parse sigData

    for k = 2:codePeriods-1
        samplesPerChip = param.sampleRate/chipping_rate(k);
        samplesPerCode = ceil((codeLength-remCode)*samplesPerChip);
        rawSignal = sigData(accumulate:accumulate+samplesPerCode-1);
        accumulate = accumulate + samplesPerCode;

        PcodeIDX = remCode : 1/samplesPerChip : (samplesPerCode-1)/samplesPerChip + remCode; % (FRACTION OF CHIPS)

        %(Counting Residual Rounding Error)
        remCode = PcodeIDX(samplesPerCode) + (1/samplesPerChip) - codeLength;  %(Fraction of Chip)

        % Create Indices for E,L,P
        EcodeIDX = ceil(PcodeIDX-dllShift) + 1;
        LcodeIDX = ceil(PcodeIDX+dllShift) + 1;
        PcodeIDX = ceil(PcodeIDX)+1; % +1 for "1-indexing" (Whole Chips)

        % Create E,L,P Code
        codeP = ca(PcodeIDX);
        codeE = ca(EcodeIDX);
        codeL = ca(LcodeIDX);

        %% Carrier Generator Plant (NCO)
        time = (0:samplesPerCode)/param.sampleRate;
        F = f_IF + doppler_shift(k);
        phi = ((F*2*pi).*time) + phase_shift(k);
        carrReplica = exp(-1j*phi(1:samplesPerCode));

        %% Mix Signal to Baseband
        if param.complex == 1
            baseband = carrReplica.*rawSignal;
            i = real(baseband);
            q = imag(baseband);
        else
            i = real(carrReplica).*rawSignal;
            q = imag(carrReplica).*rawSignal;
        end

        %% Create Correlators
        IP(k) = sum(codeP.*i);
        QP(k) = sum(codeP.*q);
        IE(k) = sum(codeE.*i);
        QE(k) = sum(codeE.*q);
        IL(k) = sum(codeL.*i);
        QL(k) = sum(codeL.*q);


        %% PLL
        PLL_discrim(k) = atan(QP(k)/IP(k))/(2*pi); %In Samples (phase error)  %Costas Discrim
        
        %% INSERT FIRST ORDER PLL
        if param.PLL_order == 1
        elseif param.PLL_order == 2
        %% SECOND ORDER PLL
        % Integrate PLL Discriminator
        PLL_discrim_int(k) = PLL_discrim_int(k-1) + PLL_discrim(k)*dt;
        % Apply Loop Filter (Controller Plant)
        pll_err(k) = PLL_kp*PLL_discrim(k) + PLL_ki*PLL_discrim_int(k);
        %NCO Command
        doppler_shift(k+1) = doppler_shift(1) + pll_err(k);
        phase_shift(k+1) = rem(phi(samplesPerCode+1),(2*pi));
        elseif param.PLL_order == 3
        end
        %% INSERT THIRD ORDER PLL

        %% FLL
        %                  FLL_discrim(k) = (1/(2*pi*PDIcarr))*atan2((IP(k-1)*QP(k)-IP(k)*QP(k-1)) ...
        %                                                          ,(IP(k)*IP(k-1)+QP(k)*QP(k-1)));

        %% DLL
        % (NNEML) Normalized Noncoherent Early Minus Late
        DLL_discrim(k) = ((sqrt(IE(k)^2+QE(k)^2) - sqrt(IL(k)^2+QL(k)^2))/ ...
            (sqrt(IE(k)^2+QE(k)^2)+sqrt(IL(k)^2+QL(k)^2)));

        % Integrate DLL Discriminator
        DLL_discrim_int(k) = DLL_discrim_int(k-1) + DLL_discrim(k)*dt;

        dll_err(k) = DLL_kp*DLL_discrim(k) + DLL_ki*DLL_discrim_int(k); %chips/s

        %Code Gnerator Command
        chipping_rate(k+1) = chipping_rate(1) - dll_err(k);
    end


    trackRes(prnI).PLL_discrim = PLL_discrim;
    trackRes(prnI).DLL_discrim = DLL_discrim;
    trackRes(prnI).codeFreq = chipping_rate;
    trackRes(prnI).carrFreq = doppler_shift;
    trackRes(prnI).data = sign(IP);
    trackRes(prnI).I_E = IE;
    trackRes(prnI).I_P = IP;
    trackRes(prnI).I_L = IL;
    trackRes(prnI).Q_E = QE;
    trackRes(prnI).Q_P = QP;
    trackRes(prnI).Q_L = QL;
end



% %% NCO
% % Takes in doppler, tau, tau dot,
% % Outputs complete signal replica
% sigReplica = NCO(f_dop,tau,tau_dot);
% % Maybe Gen CA code?
%
% idx = ceil(1.023e6/param.sampleRate : 1.023e6/param.sampleRate : 1023); %% This needs to be commanded (based on taudot)
% ca_up = ca(idx);

%% Correlator Taps
% Takes in signal Replica
% Outputs correlator taps
% % % [IE, IP, IL, QE, QP, QL] = correl(sigReplica,sigData);

%% Feedback System
% Takes in Correlator Taps
% Outputs NCO commands for next iteration
% % f_dop = pll(IE, IP, IL, QE, QP, QL);
% % tau_dot = dll(IE, IP, IL, QE, QP, QL);
% % f_dop = fll(IE, IP, IL, QE, QP, QL);
end