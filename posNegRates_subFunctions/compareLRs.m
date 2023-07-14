function [risky_HH, risky_LL] = compareLRs(Q0, alpha_p, alpha_n, beta, distType, condType)

iters                   = 1000; %simulate 1000 blocks
risky_HH                = zeros(1, iters);
risky_LL                = zeros(1, iters);
    
for i = 1: iters 

    %generate reward distribtion

    [R] = simulate_rewDist(distType);
    Qt = [Q0 Q0 Q0 Q0];

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

    % generate vector of 0s to store choices to each stimulus as a binary
    % matrix 

    p_low_safe          = zeros(120, 1);
    p_low_risky         = zeros(120, 1);
    p_high_safe         = zeros(120, 1);
    p_high_risky        = zeros(120, 1);

    p_risky_out         = zeros(iters, 4);

    for t = 1: 120 % 120 trials per block

        % indices of stimuli shown
        stim1_t   = stim1(t);
        stim2_t   = stim2(t);

        p(1, t) = VBA_sigmoid( beta * (Qt(stim1_t) - Qt(stim2_t)));

        if p(1, t) > rand
            stim_chosen    =  stim1_t;
            stim_unchosen  =  stim2_t;
        else
            stim_chosen    =  stim2_t;
            stim_unchosen  =  stim1_t;      
        end
        
        if stim_chosen == 1 
              p_low_safe(t)        = 1;
        elseif stim_chosen == 2
              p_low_risky(t)       = 1;
        elseif stim_chosen == 3
              p_high_safe(t)       = 1;
        elseif stim_chosen == 4 
              p_high_risky(t)      = 1;
        end
        
        R_t(t) = R{stim_chosen}(1);
        R{stim_chosen}(1) = []; %removes value so cannot be reused

        % learning rates; different for positive and negative prediction
        % errors

        % updating the action values annd learning rates 

        delta = R_t(t) - Qt(stim_chosen); % current trial prediction error

        % check whether delta is more or less than 0 to determine which
        % learning rate to use 

        if delta > 0
            alpha2use = alpha_p;
        else 
            alpha2use = alpha_n;
        end
        
%       % udpdate previous action value: Q_t+1 = Q_t + a_Q * d
        Qt(stim_chosen) = Qt(stim_chosen) + alpha2use * delta; 

        % store the upated Q value
        Q_all(stim_chosen, t) = Qt(stim_chosen);
        % store the updated S value
    
        % store stimulus specific p value
        % store risky choices from the both-high and both-low conditions
        if stimuliShown(t) == 12 || stimuliShown(t) == 21 ||...
            stimuliShown(t) == 34 || stimuliShown(t) == 43
            %both-low and both-high conditions indices
            pt(stim_chosen, t)   = p(1, t);
        end        
               
    end

    stimuliShown_i1(i, :) = stim1';
    stimuliShown_i2(i, :) = stim2';

    % total times each of the four stimuli were shown on this iteration
    for istim = 1:4
        tmp_stotal1(i, istim)   = sum(stimuliShown_i1(i, :) == istim);
        tmp_stotal2(i, istim)   = sum(stimuliShown_i2(i, :) == istim);
        Q_out{istim}(i, :)      = Q_all(istim, :);
        P_out{istim}(i, :)      = pt(istim, :);
    end

     p_low_safe_out(i, :) = p_low_safe;
     p_low_risky_out(i, :) = p_low_risky;
     p_high_safe_out(i, :) = p_high_safe;
     p_high_risky_out(i, :) = p_high_risky;

    % generate risk preferences per iteration 

    stimTotal_all(i, :) = tmp_stotal1(i, :) + tmp_stotal2(i, :);

    %total times each stimulus was CHOSEN during this iteration 
    % irrespective of trial number at this stage
    p_risky_out(i, 1) = sum(p_low_safe_out(i, :) == 1)./stimTotal_all(i, 1);
    p_risky_out(i, 2) = sum(p_low_risky_out(i, :) ==1)./stimTotal_all(i, 2);
    p_risky_out(i, 3) = sum(p_high_safe_out(i, :) ==1)./stimTotal_all(i, 3);
    p_risky_out(i, 4) = sum(p_high_risky_out(i, :) ==1)./stimTotal_all(i, 4);

    risky_HH(i)       = p_risky_out(i, 4);
    risky_LL(i)       = p_risky_out(i, 2);

end

end
