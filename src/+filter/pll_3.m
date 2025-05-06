function [f_nco] = pll_3(f_nco_prev, f_nco_prev2, disc_pll, ...
    disc_pll_prev, disc_pll_prev2, T)
% Third Order PLL Function
% Input: Previous NCO Freq (k-1) [Hz], Previous Previous NCO Freq(k-2)[Hz], 
% PLL discrimator (k) [cycle], Previous PLL Discrimnator (k-1) [cycle], 
% Previous Previous PLL Discriminator (k-2) [cycle], 
% Integration Period [seconds]
% Output: New NCO frequency for carrier replica (k) [Hz]

B_n = 70; % Loop Filter Noise Bandwidth [Hz] % 35
a = 1.1;
b = 2.4;
w_n = 4*(a*b - 1)*B_n / (a*b^2 + a^2 - b); % Loop FIlter Natural Frequency [Hz]

% f_nco = 2*f_nco_prev - f_nco_prev2 + ...
%         (b*w_n + (T/2)*a*w_n^2 + (1/4)*T^2*w_n^3)*disc_pll + ...
%         2*((1/4)*T^2*w_n^3 - b*w_n)*disc_pll_prev + ...
%         (b*w_n - (T/2)*a*w_n^2 + (1/4)*T^2*w_n^3)*disc_pll_prev2;

% zeta=0.707 ans ts=0.03s
p = conv([1 750],[1 2*0.707*216.88 216.88^2]);

f_nco = 2*f_nco_prev - f_nco_prev2 + ...
        (p(2) + (T/2)*p(3) + (1/4)*T^2*p(4))*disc_pll + ...
        2*((1/4)*T^2*p(4) - p(2))*disc_pll_prev + ...
        (p(2) - (T/2)*p(3) + (1/4)*T^2*p(4))*disc_pll_prev2;

end