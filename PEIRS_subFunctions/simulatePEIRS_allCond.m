function [Q_out, S_out, P_out, p_risky_out, delta_stim, prop_accuracy] = simulatePEIRS_allCond(Q0, S0, alpha_q, alpha_s, beta, omega, distType, condType)


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

    stimuliShown(i, :)  = Shuffle(repmat(stimuli_occuring,1,10))';
    stim1               = floor(stimuliShown(i, :)/10);
    stim2               = stimuliShown(i, :) - floor(stimuliShown(i, :)/10)*10;

    % stimuli: 1 = low-safe; 2 = low-risky; 3 = high-safe; 4 = high-risky

    p                   = NaN(1, 120);
    pt                  = NaN(4, 120); %return the probability for each stimulus
    Q_all               = NaN(4, 120);
    S_all               = NaN(4, 120);

    stimuliShown_i1     = NaN(1, 120);
    stimuliShown_i2     = NaN(1, 120);

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

        delta_stim(t) = ( Qt(stim1_t) + Qt(stim2_t) ) / 2 - sum(Qt(1:4)) / 4;
        PEIRS(t) = tanh(omega * delta_stim(t));

        % compute V for stim 1 and stim 2:
        V1 = Qt(stim1_t) + PEIRS(t) * St(stim1_t);
        V2 = Qt(stim2_t) + PEIRS(t) * St(stim2_t);

        % Compute differential between stim2 and stim1
        dV(t) = V1 - V2;
        p(1, t) = VBA_sigmoid( beta * dV(t));

        if p(1, t) > rand
            stim_chosen(i, t)    =  stim1_t;
            stim_unchosen        =  stim2_t;
        else
            stim_chosen(i, t)    =  stim2_t;
            stim_unchosen        =  stim1_t;
        end


        R_t(t) = R{stim_chosen(i, t)}(1);
        R{stim_chosen(i, t)}(1) = []; %removes value so cannot be reused

        % updating the action values annd learning rates

        delta = R_t(t) - Qt(stim_chosen(i, t)); % current trial prediction error
        delta_spread = abs(delta) - St(stim_chosen(i, t));

        %         % udpdate previous action value: Q_t+1 = Q_t + a_Q * d
        Qt(stim_chosen(i, t)) = Qt(stim_chosen(i, t)) + alpha_q * delta;
        St(stim_chosen(i, t)) = St(stim_chosen(i, t)) + alpha_s * delta_spread;

        % update previous spread value
        %         St = St - S0;

        %         Qt(t) = Qt(stim_chosen(t-1)) + alpha_q * (R_t(t) - Qt(stim_chosen(t-1)));
        %         St(t) = St(stim_chosen(t-1)) + alpha_s * (abs(R_t(t)-Qt(stim_chosen(t-1)))) - St(stim_chosen(t-1));

        % store the upated Q value
        Q_all(stim_chosen(i, t), t) = Qt(stim_chosen(i, t));
        % store the updated S value
        S_all(stim_chosen(i, t), t) = St(stim_chosen(i, t));
        % store stimulus specific p value
        % store risky choices from the both-high and both-low conditions

        if stimuliShown(i, t) == 12 || stimuliShown(i, t)  == 21 ||...
                stimuliShown(i, t) == 34 || stimuliShown(i, t)  == 43
            
            %both-low and both-high conditions indices
            pt(stim_chosen(i, t), t)   = p(1, t); 
        
            % only store choices made for LL and HH conditions 

            if stim_chosen(i, t) == 1
                p_low_safe(t)         = 1;
            elseif stim_chosen(i, t) == 2
                p_low_risky(t)        = 1;
            elseif stim_chosen(i, t) == 3
                p_high_safe(t)        = 1;
            elseif stim_chosen(i, t) == 4
                p_high_risky(t)       = 1;
            end

            % only start to sum up stimulus presentations for LL and HH
            % conditions 
            stimuliShown_i1(:, t) = stim1(t)';
            stimuliShown_i2(:, t) = stim2(t)';

        end

    end

    for istim = 1:4
        Q_out{istim}(i, :)   = Q_all(istim, :);
        S_out{istim}(i, :)   = S_all(istim, :);
        P_out{istim}(i, :)   = pt(istim, :); 
    end

    p_low_safe_out(i, :) = p_low_safe;
    p_low_risky_out(i, :) = p_low_risky;
    p_high_safe_out(i, :) = p_high_safe;
    p_high_risky_out(i, :) = p_high_risky;

    stim1_total(i, :) = stimuliShown_i1;
    stim2_total(i, :) = stimuliShown_i2;


end

%calculate accuracy across trial numbers 
%identify both-different conditions 
%p(high) on that trial 
both_diff_idx = [14 41; 13 31; 23 32; 24 42];
for it = 1:120

    for icombo = 1:4
        tmpIdx = [];
        tmpIdx = find(stimuliShown(:, it) == both_diff_idx(icombo, 1) | stimuliShown(:, it) == both_diff_idx(icombo, 2));

        if icombo == 1 | icombo == 4
            highIdx = [];
            highIdx = find(stim_chosen(:, it) == 4);
            totalHigh(icombo, it) = length(find(ismember(highIdx, tmpIdx)));
        else 
            highIdx = [];
            highIdx = find(stim_chosen(:, it) == 3);
            totalHigh(icombo, it) = length(find(ismember(highIdx, tmpIdx)));
        end
        totalCombo(icombo, it) = length(tmpIdx);
    end

    prop_accuracy(:, it) = totalHigh(:, it)./totalCombo(:, it);
end



% calculcate risk preferences
% across trial numbers, how many times each stimulus was shown
% at time point (t)
for it = 1: 120

    for istim = 1:4

        tmp_stotal1(1, istim) = sum(stim1_total(:, t) == istim);
        tmp_stotal2(1, istim) = sum(stim2_total(:, t) == istim);

    end
end

stimTotal_all = tmp_stotal1(1, :) + tmp_stotal2(1, :);

%total times each stimulus was CHOSEN at time point (t)
p_risky_out(:, 1) = sum(p_low_safe_out ==1, 1)./stimTotal_all(1);
p_risky_out(:, 2) = sum(p_low_risky_out ==1, 1)./stimTotal_all(2);
p_risky_out(:, 3) = sum(p_high_safe_out ==1, 1)./stimTotal_all(3);
p_risky_out(:, 4) = sum(p_high_risky_out ==1, 1)./stimTotal_all(4);


end
