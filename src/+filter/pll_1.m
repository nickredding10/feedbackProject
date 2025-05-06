function [f_nco] = pll_1(disc_pll)
% First Order PLL Function
% Input: PLL discrimator [cycle]
% Output: New NCO frequency for carrier replica [Hz]

B_n = 100; % Loop FIlter Noise Bandwidth [Hz]
w_n = 4*B_n; % Loop Filter Natural Frequency [Hz]

f_nco = w_n * disc_pll;

end