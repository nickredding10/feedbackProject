clear; clc; close all

%% FIRST ORDER PLL
% --continuous
vco = tf(1, [1 0]); % plant

B_n = 10; % Loop Filter Noise Bandwidth [Hz]
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
K_d = K_s;

% figure
% rlocus(K_d*vco_d)
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
K_d = c2d(K_s,T,'tustin');

% figure
% rlocus(K_d*vco_d)
% figure
% step(feedback(K_d*vco_d,1))
% figure
% bode(feedback(K_d*vco_d,1))

%% THIRD ORDER PLL
% --continuous
vco = tf(1, [1 0]); % plant

B_n = 70; % Loop Filter Noise Bandwidth [Hz]
a = 1.1;
b = 2.4;
w_n = 4*(a*b - 1)*B_n / (a*b^2 + a^2 - b);
% K_s = tf([b*2*pi*w_n a*(2*pi*w_n)^2 (2*pi*w_n)^3], [1 0 0]); % [rad/s]
% K_s = tf([b*w_n a*(w_n)^2 (w_n)^3], [1 0 0]); % [Hz]

p = conv([1 750],[1 2*0.707*216.88 216.88^2]);
K_s = tf([p(2) p(3) p(4)],[1 0 0]);

figure
rlocus(K_s*vco)
hold on
rlocus(K_s*vco,1,'^')
figure
step(feedback(K_s*vco,1))
figure
bode(feedback(K_s*vco,1))

% --discrete
T = 1e-3;
vco_d = c2d(vco,T,'tustin');
K_d = c2d(K_s,T,'tustin');

figure
rlocus(K_d*vco_d)
hold on
rlocus(K_d*vco_d,1,'^')
figure
step(feedback(K_d*vco_d,1))
figure
bode(feedback(K_d*vco_d,1))