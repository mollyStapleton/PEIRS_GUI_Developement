function [Q_out, P_out, p_risky_out, V_out] = simulateExploration_allCond(Q0, S0, cParam, alpha, beta, omega, distType)

iters=1000; %simulate 1000 blocks

for i = 1: iters

    %generate reward distribtion

    [R] = simulate_rewDist(distType);
    Qt = [Q0 Q0 Q0 Q0];

    % portion of code taken from Moeller toolbox
    % generates stimulus indices the same as ours with fewer lines of code

    stimuli_occuring    = [12 13 14 21 23 24 31 32 34 41 42 43];

    stimuliShown(i, :)  = Shuffle(repmat(stimuli_occuring,1,10))';
    stim1               = floor(stimuliShown(i, :)/10);
    stim2               = stimuliShown(i, :) - floor(stimuliShown(i, :)/10)*10;

    % stimuli: 1 = low-safe; 2 = low-risky; 3 = high-safe; 4 = high-risky

    p                   = NaN(1, 120);
    pt                  = NaN(4, 120); %return the probability for each stimulus
    Q_all               = NaN(4, 120); %stored updated Q for plotting
    V_all               = NaN(4, 120); 
    % generate vector of 0s to store choices to each stimulus as a binary
    % matrix

    p_low_safe          = zeros(120, 1);
    p_low_risky         = zeros(120, 1);
    p_high_safe         = zeros(120, 1);
    p_high_risky        = zeros(120, 1);

    nCounts             = ones(1, 4);
    for t = 1: 120 % 120 trials per block

        % indices of stimuli shown
        stim1_t   = stim1(t);
        stim2_t   = stim2(t);

        V1  = Qt(stim1_t) + (cParam *(sqrt(2*log(t)./nCounts(stim1_t))));
        V2  = Qt(stim2_t) + (cParam *(sqrt(2*log(t)./nCounts(stim2_t))));

        V_all(stim1_t, t) = V1;
        V_all(stim2_t, t) = V2;

        p(1, t) = VBA_sigmoid( beta * (V1-V2));

        if p(1, t) > rand
            stim_chosen(i, t)    =  stim1_t;
            stim_unchosen  =  stim2_t;
        else
            stim_chosen(i, t)    =  stim2_t;
            stim_unchosen  =  stim1_t;
        end

        nCounts(stim_chosen(i, t)) = nCounts(stim_chosen(i, t))+1;

        %store whether the stimulus was explored
        if stim_chosen(i, t) == 1
            p_low_safe(t)         = 1;
        elseif stim_chosen(i, t) == 2
            p_low_risky(t)        = 1;
        elseif stim_chosen(i, t) == 3
            p_high_safe(t)        = 1;
        elseif stim_chosen(i, t) == 4
            p_high_risky(t)       = 1;
        end

        R_t(t) = R{stim_chosen(i, t)}(1);
        R{stim_chosen(i, t)}(1) = []; %removes value so cannot be reused

        % updating the action values

        delta = R_t(t) - Qt(stim_chosen(i, t)); % current trial prediction error
        %         delta_spread = abs(delta) - St(stim_chosen(i, t));

        % udpdate previous action value: Q_t+1 = Q_t + a_Q * d
        Qt(stim_chosen(i, t)) = Qt(stim_chosen(i, t)) + alpha * delta;

        Q_all(stim_chosen(i, t), t) = Qt(stim_chosen(i, t));

        % store stimulus specific p value
        % store risky choices from the both-high and both-low conditions
        if stimuliShown(i, t) == 12 || stimuliShown(i, t) == 21 ||...
            stimuliShown(i, t) == 34 || stimuliShown(i, t) == 43
            %both-low and both-high conditions indices
            pt(stim_chosen(i, t), t)   = p(1, t);
        end        
             

    end


    stimuliShown_i1(i, :) = stim1';
    stimuliShown_i2(i, :) = stim2';

    for istim = 1:4
        Q_out{istim}(i, :)   = Q_all(istim, :);
        V_out{istim}(i, :)   = V_all(istim, :);
        P_out{istim}(i, :)   = pt(istim, :);
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

        tmp_stotal1(istim, it) = sum(stim1_total(:, it) == istim);
        tmp_stotal2(istim, it) = sum(stim2_total(:, it) == istim);

    end
 
    stimTotal_all(:, it) = tmp_stotal1(:, it) + tmp_stotal2(:, it);
end

% stimTotal_all(it, istim) = tmp_stotal1(1, :) + tmp_stotal2(1, :);

%total times each stimulus was CHOSEN at time point (t)
p_risky_out(:, 1) = sum(p_low_safe_out ==1, 1)./stimTotal_all(1, :);
p_risky_out(:, 2) = sum(p_low_risky_out ==1, 1)./stimTotal_all(2, :);
p_risky_out(:, 3) = sum(p_high_safe_out ==1, 1)./stimTotal_all(3, :);
p_risky_out(:, 4) = sum(p_high_risky_out ==1, 1)./stimTotal_all(4, :);

end
