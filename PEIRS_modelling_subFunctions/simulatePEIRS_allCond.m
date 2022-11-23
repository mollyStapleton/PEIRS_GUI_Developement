function [out1, out2, out3, out4, out_low, out_high] = simulatePEIRS_allCond(s_safe, s_risky, alpha_q, alpha_s, beta, omega, distType)

iters=1000; %simulate 1000 blocks

for i = 1: iters 

    %generate reward distribtion

    [R] = simulate_rewDist(distType)





end







end
