 function plot_posNegRates_simulated(src, event)


        if DistSel.Value == 1 %gaussian
            distType = 1;
            lowcol = [0.83 0.71 0.98];
            highcol = [0.62 0.35 0.99];
        else
            distType = 2;
            lowcol = [0.58 0.99 0.56];
            highcol = [0.19 0.62 0.14];
        end

        if condSel.Value == 1
            condType = 1; %all
        else
            condType = 2; %risk preference only
        end

        Q0 = str2num(prompt_qstart.String{1});

        callbackParams_posNegRates;

        [Q_out, P_out, p_risky_out] = simulatePosNegRates_allCond(Q0, alpha_p,...
            alpha_n, beta, distType, condType);


        axes(ax_valueRate);
        plot(nanmean(Q_out{1}), 'linestyle', '--', 'color', lowcol, 'LineWidth', 2);
        hold on
        plot(nanmean(Q_out{2}), 'linestyle', '-', 'color', lowcol, 'LineWidth', 2);
        hold on
        plot(nanmean(Q_out{3}), 'linestyle', '--', 'color', highcol, 'LineWidth', 2);
        hold on
        plot(nanmean(Q_out{4}), 'linestyle', '-', 'color', highcol, 'LineWidth', 2);
        legend({'Low-Safe', 'Low-Risky', 'High-Safe', 'High-Risky'});
        xlabel('No. Trials');
        ylabel({'Simulated Average',  'Value (Learned)'});
        title('\bf \fontsize{12} Change in Value over Trials');
        set(gca, 'FontName', 'times');

        axes(ax_probRisky);
        % low-risky
        plot(p_risky_out(:, 2), 'color', lowcol, 'lineStyle', '-', 'linew', 1.2);
        hold on 
        smoothLow = smoothdata(p_risky_out(:, 2), 'movmean', 24);
        plot(smoothLow, 'color', lowcol, 'lineStyle', '-', 'linew', 3);
        % high-risk
        plot(p_risky_out(:, 4), 'color', highcol, 'lineStyle', '-', 'linew', 1.2);
        hold on
        smoothHigh = smoothdata(p_risky_out(:, 4), 'movmean', 24);
        plot(smoothHigh, 'color', highcol, 'lineStyle', '-', 'linew', 3);
        ylabel('P(Risky)');
        xlabel('No. Trials');
        title({'\bf \fontsize{12}  Risk Preferences'});
        set(gca, 'FontName', 'times')
        hold on 
        plot([0 120], [0.5 0.5], 'k--');
        legend({'Low-Risky (Sim.)', 'Low-Risky (Smoothed)', 'High-Risky (Sim.)',...
            'High-Risky (Smoothed)', ''},'location', 'best');

            
      
    end