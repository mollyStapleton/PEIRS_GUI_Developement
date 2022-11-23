function [Q_out, S_out, P_out] = simulatePEIRS_allCond(s_safe, s_risky, alpha_q, alpha_s, beta, omega, distType)

iters=1000; %simulate 1000 blocks

Qt = [50 50 50 50];
St = [s_safe s_risky s_safe s_risky];

for i = 1: iters 

    %generate reward distribtion

    [R] = simulate_rewDist(distType);

    % portion of code taken from Moeller toolbox 
    % generates stimulus indices the same as ours with fewer lines of code
    stimuli_occuring    = [12 13 14 21 23 24 31 32 34 41 42 43];
    stimuliShown        = Shuffle(repmat(stimuli_occuring,1,10))';
    stim1               = floor(stimuliShown/10);
    stim2               = stimuliShown - floor(stimuliShown/10)*10;

    p                   = NaN(1, 120);
    pt                  = NaN(120, 4); %return the probability for each stimulus 
    Q_all               = NaN(120, 4);
    S_all               = NaN(120, 4);

    % generate probability of choice on a single trial basis 

    for itrial = 1: 120 % 120 trials per block

        beta_t    = exp(beta);
        omega_t   = omega;

        % indices of stimuli shown
        stim1_t   = stim1(itrial);
        stim2_t   = stim2(itrial);

        delta_stim = ( Qt(stim1_t) + Qt(stim2_t) ) / 2 - sum(Qt(1:4)) / 4;
        PEIRS(itrial) = tanh(omega_t * delta_stim);

        % compute V for stim 1 and stim 2:
        V1 = Qt(stim1_t) + PEIRS(itrial) * St(stim1_t);
        V2 = Qt(stim2_t) + PEIRS(itrial) * St(stim2_t);

        % Compute differential between stim2 and stim1
        dV(itrial) = V1 - V2;
        p(1, itrial) = VBA_sigmoid( beta_t * dV(itrial));

        if p(1, itrial) > rand
            stim_chosen    =  stim1_t;
            stim_unchosen  =  stim2_t;
            
        else
            stim_chosen    =  stim2_t;
            stim_unchosen  =  stim1_t;      
        end

        
        R_t(itrial) = R{stim_chosen}(1);
        R{stim_chosen}(1) = []; %removes value so cannot be reused

        % updating the action values annd learning rates 
        S0 = exp(alpha_s);
        St = St + S0;

        delta = Qt(stim_chosen) - R_t(itrial); % current trial prediction error
        delta_spread = abs(delta_stim) - St(stim_chosen); 

        % udpdate previous action value: Q_t+1 = Q_t + a_Q * d
        Qt(stim_chosen) = Qt(stim_chosen) + alpha_q * delta; 
        St(stim_chosen) = St(stim_chosen) + alpha_s * delta_spread;
        
        % update previous spread value
        St = St - S0;

        % store the upated Q value
        Q_all(itrial, stim_chosen) = Qt(stim_chosen);
        % store the updated S value
        S_all(itrial, stim_chosen) = St(stim_chosen);
        % store stimulus specific p value
        pt(itrial, stim_chosen)    = p(1, itrial);
               
    end

    for istim = 1:4
        Q_out{istim}   = Q_all(:, istim);
        S_out{istim}   = S_all(:, istim);
        P_out{istim}   = pt(:, istim);
    end

end







end