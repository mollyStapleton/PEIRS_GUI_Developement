function [R] = simulate_rewDist(distType)

R = [];


if distType == 1
    % Gaussian

    for irew = 1:60

        R1(irew) = round(randn*5+40);
        R2(irew) = round(randn*15+40);
        R3(irew) = round(randn*5+60);
        R4(irew) = round(randn*15+60);

    end

    R = [R1; R2; R3; R4];

else

    R = bimodal_distr;


end



    
end
