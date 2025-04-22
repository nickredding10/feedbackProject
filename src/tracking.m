function tracking(sigData,param)

    %% Initializations

    %% Parse sigData

    %% NCO
    % Takes in doppler, tau, tau dot,
    % Outputs complete signal replica
    sigReplica = NCO(f_dop,tau,tau_dot);
    % Maybe Gen CA code?
    ca = genCACODE(prn);
    idx = ceil(1.023e6/param.sampleRate : 1.023e6/param.sampleRate : 1023); %% This needs to be commanded (based on taudot)
    ca_up = ca(idx);

    %% Correlator Taps
    % Takes in signal Replica
    % Outputs correlator taps
    [IE, IP, IL, QE, QP, QL] = correl(sigReplica,sigData);

    %% Feedback System
    % Takes in Correlator Taps
    % Outputs NCO commands for next iteration
    f_dop = pll(IE, IP, IL, QE, QP, QL);
    tau_dot = dll(IE, IP, IL, QE, QP, QL);
    f_dop = fll(IE, IP, IL, QE, QP, QL);
end