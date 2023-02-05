function [Q_out, P_out, p_risky_out] = simulatePosNegRates_allCond(Q0, alpha_p, alpha_n, beta, distType, condType)

iters=1000; %simulate 1000 blocks

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
              p_low_safe(t)         = 1;
        elseif stim_chosen == 2
              p_low_risky(t)        = 1;
        elseif stim_chosen == 3
              p_high_safe(t)        = 1;
        elseif stim_chosen == 4 
              p_high_risky(t)       = 1;
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

    for istim = 1:4
        Q_out{istim}(i, :)   = Q_all(istim, :);
        P_out{istim}(i, :)   = pt(istim, :);
        p_low_safe_out(i, :) = p_low_safe;
    end

     p_low_safe_out(i, :) = p_low_safe;
     p_low_risky_out(i, :) = p_low_risky;
     p_high_safe_out(i, :) = p_high_safe;
     p_high_risky_out(i, :) = p_high_risky;


end

% calculcate risk preferences
% across trial numbers, how many times each stimulus was shown
% at time point (t)
for it = 1: 120

    for istim = 1:4


        tmp_stotal1(it, istim) = sum(stimuliShown_i1(:, t) == istim);
        tmp_stotal2(it, istim) = sum(stimuliShown_i2(:, t) == istim);

    end
end

stimTotal_all = tmp_stotal1(1, :) + tmp_stotal2(1, :);

%total times each stimulus was CHOSEN at time point (t)
p_risky_out(:, 1) = sum(p_low_safe_out ==1, 1)./stimTotal_all(1);
p_risky_out(:, 2) = sum(p_low_risky_out ==1, 1)./stimTotal_all(2);
p_risky_out(:, 3) = sum(p_high_safe_out ==1, 1)./stimTotal_all(3);
p_risky_out(:, 4) = sum(p_high_risky_out ==1, 1)./stimTotal_all(4);

end
