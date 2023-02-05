    function plotPEIRS_simulated(src, event)


        if DistSel.Value == 1 %gaussian
            lowcol = [0.83 0.71 0.98];
            highcol = [0.62 0.35 0.99];        
        else 
            DistSel.Value == 2 %bimodal
            lowcol = [0.58 0.99 0.56];
            highcol = [0.19 0.62 0.14]; 
        end

        cla(ax_valueRate);
        cla(ax_probRisky);
        % return all of the values input by the user within each prompt
        inp = get(prompt_ssafe, 'string');
        inp = str2num(inp);
        s_safe  = inp;
        inp = get(prompt_srisky, 'string');
        inp = str2num(inp);
        s_risky  = inp;

        inp = get(prompt_aq, 'string');
        inp = str2num(inp);
        alpha_q  = inp;

        inp = get(prompt_as, 'string');
        inp = str2num(inp);
        alpha_s  = inp;

        inp = get(prompt_beta, 'string');
        inp = str2num(inp);
        beta  = inp;

        inp = get(prompt_omega, 'string');
        inp = str2num(inp);
        omega  = inp;

out1 = []; out2 = []; out3 = [];  out4 = [];  out_low = []; out_high = [];



[out1, out2, out3, out4, out_low, out_high] = generatePlots_PEIRS_simulated(s_safe,...
    s_risky, alpha_q, alpha_s, beta, omega, distType);


    axes(ax_valueRate);
    plot(nanmean(out1), 'linestyle', '--', 'color', lowcol, 'LineWidth', 2);
    hold on 
    plot(nanmean(out2), 'linestyle', '-', 'color', lowcol, 'LineWidth', 2);
    hold on 
    plot(nanmean(out3), 'linestyle', '--', 'color', highcol, 'LineWidth', 2);
    hold on 
    plot(nanmean(out4), 'linestyle', '-', 'color', highcol, 'LineWidth', 2);
    legend({'Low-Safe', 'Low-Risky', 'High-Safe', 'High-Risky'});
    xlabel('No. Trials');
    ylabel('Simulated Average Value + Spread');
    title('\bf \fontsize{10} Change in Value over Trials');

% 
    axes(ax_probRisky);
    plot(nanmean(out_low), 'color', lowcol, 'linew', 1.2);
    hold on
    plot(nanmean(out_high), 'color', highcol,'linew', 1.2);
    legend({'P(Risky|Both-LOW)', 'P(Risky|Both-High)'});
    ylabel('P(Risky|ConditionType)');
    xlabel('No. Trials');
    title({'\bf \fontsize{10}  P(risky| Both-High)', 'vs', 'P(risky|Both-Low)'});


    end