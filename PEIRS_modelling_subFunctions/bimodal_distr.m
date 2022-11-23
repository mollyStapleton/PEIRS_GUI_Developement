function [rewardDists] = bimodal_distr

% return 4 separate bimodal reward distributions 
% 120 trials with 10 x 12 stimulus combinations 

%EG HIGH-SAFE (EV = 60)
%  0.8 * 75 + 0.2 * 0 = 60
%  ev_mat =[40 40 60 60];

    reward_size = [50 200 75 300];
    reward_trials = [48 12 48 12];

% a single stimulus will be shown 60 times in a single block 
% 80% = 48 trials, 20% = 12 trials 

    rewardDists = zeros(60,4);

    for i = 1:4

        rewardDists((1:reward_trials(i)), i) = reward_size(i);

        % randomize the reward values
        
        tmp_idx = randperm(60);
        rewardDists(:, i) = rewardDists(tmp_idx, i);

        % check that due to the randomization, there is no runs of 10
        % identical values 

%         diffIdx = diff(rewardDists(:, 1));
%         diffBlock = [1 10 20 30 40 50 59];
%         for idiff = 2: length(diffBlock)
% 
%             tmpVec = diffIdx(diffBlock(idiff-1): diffBlock(idiff+1));
%             tmpZeros = find((tmpVec) == 0);
%             tmpConsec = find(diff(tmpZeros) == 1);
% 
%             if length(tmpConsec) >= 9
%                    
%                 tmpIdx_new = randperm(diffBlock(idiff): diffBlock(idiff+1));
% 
%             end
% 
%         end


    end


end 