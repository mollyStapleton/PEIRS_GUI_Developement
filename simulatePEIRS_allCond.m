function [Q_out, S_out, P_out] = simulatePEIRS_allCond(Q0, S0, alpha_q, alpha_s, beta, omega, distType, condType)

iters=1000; %simulate 1000 blocks


for i = 1: iters 

    %generate reward distribtion

    [R] = simulate_rewDist(distType);
    Qt = [Q0 Q0 Q0 Q0];
    St = [S0 S0 S0 S0];

    % portion of code taken from Moeller toolbox 
    % generates stimulus indices the same as ours with fewer lines of code

    if condType == 1 % all conditions 
        stimuli_occuring    = [12 13 14 21 23 24 31 32 34 41 42 43];
    else 
        stimuli_occuring    = [12 34 21 43 12 34 21 43 12 34 21 43];
    end

    stimuliShown        = Shuffle(repmat(stimuli_occuring,1,10))';
    stim1               = floor(stimuliShown/10);
    stim2               = stimuliShown - floor(stimuliShown/10)*10;

    % stimuli: 1 = low-safe; 2 = low-risky; 3 = high-safe; 4 = high-risky

    p                   = NaN(1, 120);
    pt                  = NaN(4, 120); %return the probability for each stimulus 
    Q_all               = NaN(4, 120);
    S_all               = NaN(4, 120);

    % generate probability of choice on a single trial basis 

    for t = 1: 120 % 120 trials per block

        % indices of stimuli shown
        stim1_t   = stim1(t);
        stim2_t   = stim2(t);

        delta_stim = ( Qt(stim1_t) + Qt(stim2_t) ) / 2 - sum(Qt(1:4)) / 4;
        PEIRS(t) = tanh(omega * delta_stim);

        % compute V for stim 1 and stim 2:
        V1 = Qt(stim1_t) + PEIRS(t) * St(stim1_t);
        V2 = Qt(stim2_t) + PEIRS(t) * St(stim2_t);

        % Compute differential between stim2 and stim1
        dV(t) = V1 - V2;
        p(1, t) = VBA_sigmoid( beta * dV(t));

        if p(1, t) > rand
            stim_chosen    =  stim1_t;
            stim_unchosen  =  stim2_t;
            
        else
            stim_chosen    =  stim2_t;
            stim_unchosen  =  stim1_t;      
        end

        
        R_t(t) = R{stim_chosen}(1);
        R{stim_chosen}(1) = []; %removes value so cannot be reused

        % updating the action values annd learning rates 

        delta = R_t(t) - Qt(stim_chosen); % current trial prediction error
        delta_spread = abs(delta) - St(stim_chosen); 

        % udpdate previous action value: Q_t+1 = Q_t + a_Q * d
        Qt(stim_chosen) = Qt(stim_chosen) + alpha_q * delta; 
        St(stim_chosen) = St(stim_chosen) + alpha_s * delta_spread;
        
        % update previous spread value
%         St = St + 3.31;

        % store the upated Q value
        Q_all(stim_chosen, t) = Qt(stim_chosen);
        % store the updated S value
        S_all(stim_chosen, t) = St(stim_chosen);
        % store stimulus specific p value
        % store risky choices from the both-high and both-low conditions
        if stimuliShown(t) == 12 || stimuliShown(t) == 21 ||...
            stimuliShown(t) == 34 || stimuliShown(t) == 43
            %both-low and both-high conditions indices
            pt(stim_chosen, t)   = p(1, t);
        end
        
               
    end

    for istim = 1:4
        Q_out{istim}(i, :)   = Q_all(istim, :);
        S_out{istim}(i, :)   = S_all(istim, :);
        P_out{istim}(i, :)   = pt(istim, :);
      
    end

end

end
