function [out1, out2, out3, out4, out_low, out_high] = generatePlotData_posNegRates_simulated(s_safe, s_risky, alpha_q, alpha_s, beta, omega, distType)

iters=1000; %simulate 1000 blocks


for i = 1:iters

    % vector of cnd idx, in this case we assume that both-high and both-low can
    % be presented 50% of simulated trials

    cndIdx = zeros(1, 500);
    cndIdx(1: 255) = ones;
    cndIdx(255: 500) = ones*2;

    pt = NaN(2, 500);

    % randomise cnd vector to make simulation more realistic to actual study
    % paradagim

    randIdx = randi([1 500], 500, 1);
    cndIdx =cndIdx(randIdx);

    % Q values refer to the agents belief of the underlying mean of the reward
    % distribution - 1, 2, 3, 4 (4 stimuli)
    % all start at 50

    Q1 = 50; Q2 = 50; Q3 = 50; Q4 = 50;

    PEIRS = 0;

    for t= 2:500 %loop over 500 trials/per block

        tmpCnd = cndIdx(t);
        % simulation of the reward distributions

if distType == 1 % GAUSSIAN
        if tmpCnd == 1 %both-low
            R1(t)=randn*5+40; %this is the reward for option 1 (safe-low)
            R2(t)=randn*15+40; %this is the reward for option 2 (risky-low)
            R3(t)=0; %stimulus 3 not presented in this condition so no reward update
            R4(t)=0; %stimulus 4 not presented in this condition so no reward update
        elseif tmpCnd == 2 %both-high
            R1(t) = 0; %stimulus 1 not presented in this condition so no reward update
            R2(t) = 0; %stimulus 2 not presented in this condition so no reward update
            R3(t)=randn*5+60; %this is the reward for option 1 (safe-high)
            R4(t)=randn*15+60; %this is the reward for option 2 (risky-high)
        end
elseif distType == 2 

        reward_size = [50 200 75 300];
        reward_trials = [400 100 400 100];

        rewardDists = zeros(500, 4);
        
        if tmpCnd == 1 %both-low
            rewardDists((1:reward_trials(1)), 1) = reward_size(1);
            tmp_idx = randperm(500);
            R1(t)   = rewardDists(tmp_idx(t), 1); %this is the reward for option 1 (safe-low)

            rewardDists((1:reward_trials(2)), 2) = reward_size(2);
            tmp_idx = randperm(500);
            R2(t)   = rewardDists(tmp_idx(t), 2);%this is the reward for option 2 (risky-low)
            R3(t)   = 0; %stimulus 3 not presented in this condition so no reward update
            R4(t)   = 0; %stimulus 4 not presented in this condition so no reward update
        elseif tmpCnd == 2 %both-high
            R1(t) = 0; %stimulus 1 not presented in this condition so no reward update
            R2(t) = 0; %stimulus 2 not presented in this condition so no reward update

            rewardDists((1:reward_trials(3)), 3) = reward_size(3);
            tmp_idx = randperm(500);
            R3(t)= rewardDists(tmp_idx(t), 3); %this is the reward for option 1 (safe-high)

            rewardDists((1:reward_trials(4)), 4) = reward_size(4);
            tmp_idx = randperm(500);
            R4(t)= rewardDists(tmp_idx(t), 4); %this is the reward for option 2 (risky-high)
        end
end


        % update of the belief of the underlying mean distribution
        % the term following alpha* is the reward prediction error:
        % delta-outcome
        Q1(t)=Q1(t-1)+alpha_q*(R1(t)-Q1(t-1));
        Q2(t)=Q2(t-1)+alpha_q*(R2(t)-Q2(t-1));
        Q3(t)=Q3(t-1)+alpha_q*(R3(t)-Q3(t-1));
        Q4(t)=Q4(t-1)+alpha_q*(R4(t)-Q4(t-1));

        % Q2 - RISKY for BOTH-LOW
        % Q4 - RISKY for BOTH-HIGH

        % calculate stimulus present error: delta-stim
        % will differ depending on the condition
        if tmpCnd == 1
            % should be 0 on the first trial irrespective of trial type
            delta_stim(t) = (Q1(t) + Q2(t))/2 - sum([Q1(t), Q2(t), Q3(t), Q4(t)])/4;
            Qj(t) = sum([Q1(t) Q2(t)]); % j - both options shown on the screen
        else
            % should be 0 on the first trial irrespective of trial type
            delta_stim(t) = (Q3(t) + Q4(t))/2 - sum([Q1(t), Q2(t), Q3(t), Q4(t)])/4;
            Qj(t) = sum([Q3(t) Q4(t)]); % j - both options shown on the screen
        end


        % variant of the softmax function
        % p(risky choice| both-high OR both-low)
        if tmpCnd == 1  % BOTH-LOW
            V1 = Q2(t) + PEIRS(t) * S2(t);
            V2 = Q1(t) + PEIRS(t) * S1(t);
        else            % BOTH-HIGH
            V1 = Q4(t) + PEIRS(t) * S4(t);
            V2 = Q3(t) + PEIRS(t) * S3(t);
        end

        % Compute differential between stim2 and stim1
        dV = V1 - V2;

        pt(tmpCnd, t) = VBA_sigmoid( beta * dV );

    end

    out1(i,:)= Q1+S1;
    out2(i,:)= Q2+S2;
    out3(i, :) = Q3+S3;
    out4(i, :) = Q4+S4;

    %             tmpIdx = find(~isnan(pt(1, :)));
    out_low(i,:)=pt(1, :);
    %             tmpIdx = find(~isnan(pt(2, :)));
    out_high(i, :)=pt(2, :);

end


end
