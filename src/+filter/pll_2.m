function [f_nco] = pll_2(f_nco_prev, disc_pll, disc_pll_prev, T)
% Second Order PLL Function
% Input: Previous NCO Freq [Hz], PLL discrimator [cycle], Previous PLL
% Discrimnator [cycle], Integration Period [seconds]
% Output: New NCO frequency for carrier replica [Hz]

B_n = 20; % Loop Filter Noise Bandwidth [Hz]
zeta = sqrt(2)/2;
w_n = 4*2*zeta*B_n / (1 + 4*zeta^2); % Loop Filter Natural Frequency [Hz]

f_nco = f_nco_prev + (2*zeta*w_n + (w_n^2)*T/2)*disc_pll + ...
    ((w_n^2)*T/2 - 2*zeta*w_n)*disc_pll_prev;

end