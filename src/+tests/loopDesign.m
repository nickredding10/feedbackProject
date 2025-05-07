clear; clc; close all

%% FIRST ORDER PLL
% --continuous
vco = tf(1, [1 0]); % plant

B_n = 100; % Loop Filter Noise Bandwidth [Hz]
w_n = 4*B_n; % Loop Filter Natural Frequency [Hz]
K_s = tf(2*pi*w_n); % [rad/s]
% K_s = tf(w_n); % [Hz]

% figure
% rlocus(K_s*vco)
% figure
% step(feedback(K_s*vco,1))
% figure
% bode(feedback(K_s*vco,1))

% --discrete
T = 1e-3;
vco_d = c2d(vco,T,'tustin');
K_d1 = K_s;

tf_d = K_d1*vco_d;
num = cell2mat(tf_d.Numerator);
den = cell2mat(tf_d.Denominator);
[g,ph,w] = dbode(num,den,1);
ph(end) = ph(end-1);

% figure
% rlocus(K_d*vco_d)
% hold on
% rlocus(K_d*vco_d,1,'^')
% figure
% margin(K_d*vco_d)
% grid minor
% figure
% subplot(2,1,1)
% loglog(w,g,LineWidth=2)
% hold on; grid minor
% xline(pi,'k--',LineWidth=1.5)
% ylim([10^-3 10^3])
% subplot(2,1,2)
% semilogx(w,ph,LineWidth=2)
% hold on; grid minor
% xline(pi,'k--',LineWidth=1.5)
% ylim([-120 0])
% yticks([-120 -90 -60 -30 0])
% figure
% dbode(num,den,1)
% grid minor

% figure
% step(feedback(K_d*vco_d,1))
% figure
% bode(feedback(K_d*vco_d,1))

%% SECOND ORDER PLL
% --continuous
vco = tf(1, [1 0]); % plant

B_n = 20; % Loop Filter Noise Bandwidth [Hz]
zeta = sqrt(2)/2;
w_n = 4*2*zeta*B_n / (1 + 4*zeta^2); % Loop Filter Natural Frequency [Hz]
K_s = tf([2*zeta*2*pi*w_n (2*pi*w_n)^2], [1 0]); % [rad/s]
% K_s = tf([2*zeta*w_n (w_n)^2], [1 0]); % [Hz]

% figure
% rlocus(K_s*vco)
% figure
% step(feedback(K_s*vco,1))
% figure
% bode(feedback(K_s*vco,1))

% --discrete
T = 1e-3;
vco_d = c2d(vco,T,'tustin');
K_d2 = c2d(K_s,T,'tustin');

% figure
% rlocus(K_d*vco_d)
% hold on
% rlocus(K_d*vco_d,1,'^')
% figure
% margin(K_d*vco_d)
% grid minor
% figure
% step(feedback(K_d*vco_d,1))
% figure
% bode(feedback(K_d*vco_d,1))

% num = cell2mat(tf_d.Numerator);
% den = cell2mat(tf_d.Denominator);
% figure
% dbode(num,den,1)
% grid minor

%% THIRD ORDER PLL
% --continuous
vco = tf(1, [1 0]); % plant

B_n = 70; % Loop Filter Noise Bandwidth [Hz]
a = 1.1;
b = 2.4;
w_n = 4*(a*b - 1)*B_n / (a*b^2 + a^2 - b);
K_s = tf([b*2*pi*w_n a*(2*pi*w_n)^2 (2*pi*w_n)^3], [1 0 0]); % [rad/s]
% K_s = tf([b*w_n a*(w_n)^2 (w_n)^3], [1 0 0]); % [Hz]

% p = conv([1 750],[1 2*0.707*216.88 216.88^2]);
% K_s = tf([p(2) p(3) p(4)],[1 0 0]);

% figure
% rlocus(K_s*vco)
% hold on
% rlocus(K_s*vco,1,'^')
% figure
% step(feedback(K_s*vco,1))
% figure
% bode(feedback(K_s*vco,1))

% --discrete
T = 1e-3;
vco_d = c2d(vco,T,'tustin');
K_d3 = c2d(K_s,T,'tustin');

% figure
% rlocus(K_d*vco_d)
% hold on
% rlocus(K_d*vco_d,1,'^')
% figure
% margin(K_d*vco_d)
% grid minor
% figure
% step(feedback(K_d*vco_d,1))
% figure
% bode(feedback(K_d*vco_d,1))


cl_p = feedback(K_d1*vco_d,1);
cl_pi = feedback(K_d2*vco_d,1);
cl_pii = feedback(K_d3*vco_d,1);

t = 0:1e-3:0.1;
u_step = ones(size(t));
u_ramp = t;
u_parab = t.^2;

y_p_step = lsim(cl_p,u_step,t);
y_p_ramp = lsim(cl_p,u_ramp,t);
y_p_parab = lsim(cl_p,u_parab,t);

y_pi_step = lsim(cl_pi,u_step,t);
y_pi_ramp = lsim(cl_pi,u_ramp,t);
y_pi_parab = lsim(cl_pi,u_parab,t);

y_pii_step = lsim(cl_pii,u_step,t);
y_pii_ramp = lsim(cl_pii,u_ramp,t);
y_pii_parab = lsim(cl_pii,u_parab,t);

figure
subplot(3,1,1)
stairs(t,u_step'-y_p_step,LineWidth=2)
hold on; grid minor
stairs(t,u_step'-y_pi_step,LineWidth=2)
stairs(t,u_step'-y_pii_step,LineWidth=2)
yline(0,'k--',LineWidth=1.5)
title('Phase Error for Various Inputs','FontSize',10)
ylabel('STEP','FontSize',10)
legend('P-Control','PI-Control','PII-Control','FontSize',10,Orientation='horizontal')
subplot(3,1,2)
stairs(t,u_ramp'-y_p_ramp,LineWidth=2)
hold on; grid minor
stairs(t,u_ramp'-y_pi_ramp,LineWidth=2)
stairs(t,u_ramp'-y_pii_ramp,LineWidth=2)
yline(0,'k--',LineWidth=1.5)
ylabel('RAMP','FontSize',10)
subplot(3,1,3)
stairs(t,u_parab'-y_p_parab,LineWidth=2)
hold on; grid minor
stairs(t,u_parab'-y_pi_parab,LineWidth=2)
stairs(t,u_parab'-y_pii_parab,LineWidth=2)
yline(0,'k--',LineWidth=1.5)
xlabel('Time [s]','FontSize',10)
ylabel('PARABOLIC','FontSize',10)