clear; clc; close all

%% 
dt = 1e-6;
t = 0:dt:1;
fr = 100;
phir = 0.1;
r = sin(2*pi*fr*t + phir);
r_comp = exp(1j*(2*pi*fr*t + phir));
T_int = 1/fr;
numT = floor(t(end)/T_int);

sigIdx = 1;
samps  = T_int/dt;

f = 90;
phase = 0;

zeta = 0.707;
BW_PLL = 8;
Wn_PLL = BW_PLL*8*zeta / (4*zeta.^2 + 1);
PLL_ki = 4*Wn_PLL^2;
PLL_kp = (2*zeta/Wn_PLL)*PLL_ki;
% PLL_ki = 157;
% PLL_kp = 18;
int_phi = 0;

for ii = 1:numT
    tmpT = 0:dt:T_int-dt*T_int;
    % Real Method
    sig = r(sigIdx:1:samps*ii);
    I = 2*sin(2*pi*fr*tmpT);
    Q = 2*cos(2*pi*fr*tmpT);
    phi_err(ii) = atan(sum(sig.*Q)/sum(sig.*I));
    
    % Complex Method
    sig2 = r_comp(sigIdx:1:samps*ii);
    % rep = exp(-1j*2*pi*fr*tmpT);
    rep = exp(-1j*(2*pi*f(ii)*tmpT + phase(ii)));
    IP = sum(real(rep.*sig2));
    QP = sum(imag(rep.*sig2));        
    phi(ii) = atan(QP/IP)./(2*pi);

    % IP2 = sum(sig.*real(rep));
    % QP2 = sum(sig.*imag(rep));
    % phi2(ii) = atan(QP2/IP2);    
    
    int_phi(ii+1) = int_phi(ii) + phi(ii)*T_int;
    pll_upd(ii) = PLL_kp*phi(ii) + PLL_ki*(int_phi(ii));

    f(ii+1) = f(1) + pll_upd(ii);
    phase(ii+1) = rem(2*pi*f(ii)*tmpT(end)+phase(ii),2*pi);

    sigIdx = sigIdx + samps;
end

figure
plot(f)

figure
plot(phi)