function PEIRS_paramExplor_GUI

clc 
clear
close all hidden

mainFig = figure;
mainFig.Name = 'mainWindow';
mainFig.Position = [228.2000 43.4000 1172 394.4000];

    
%----------------------------------------------------------------------------
% GENERATE BASIC GRAPHICS FOR USER INPUT AND THE AXES FOR PLOTS 
%------------------------------------------------------------------------------------
% create axes for simulated average reward and spread to be plotted onto
ax_valueRate = uiaxes(mainFig, 'position', [370 30 350 350]);
ax_probRisky = uiaxes(mainFig, 'position', [770 30 350 350]);


% prompts for parameter inputs 
%%%% Variance paramaters
text_ssafe   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Set SAFE Variance',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [25 350 150 20]);
prompt_ssafe = uicontrol(mainFig, 'Style', 'edit', 'position', [50 330 100 20]);
text_srisky   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Set RISKY Variance',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [25 300 150 20]);
prompt_srisky = uicontrol(mainFig, 'Style', 'edit', 'position', [50 280 100 20]);
%%%% Learning rate parameters
text_aq   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Set Q Learning Rate',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [30 230 150 20]);
prompt_aq = uicontrol(mainFig, 'Style', 'edit', 'position', [50 210 100 20]);
text_as   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Set S Learning Rate',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [30 180 150 20]);
prompt_as = uicontrol(mainFig, 'Style', 'edit', 'position', [50 160 100 20]);
%%%% Choice Parameters
text_beta  = uicontrol(mainFig, 'Style', 'Text', 'string', 'Set Beta',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [25 100 150 20]);
prompt_beta = uicontrol(mainFig, 'Style', 'edit', 'FontName', 'times', 'position', [50 80 100 20]);
text_omega   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Set Omega',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [25 50 150 20]);
prompt_omega = uicontrol(mainFig, 'Style', 'edit', 'position', [50 30 100 20]);

% button to be clicked and generate plot
 
plotGauss = uicontrol(mainFig, 'Style', 'pushbutton', 'string', 'Gaussian Distribution',...
    'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'times', 'position', [190 210 150 50]);

plotBimodal = uicontrol(mainFig, 'Style', 'pushbutton', 'string', 'Bimodal Distribution',...
    'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'times', 'position', [190 145 150 50]);

plotBimodal.Callback = @plotPEIRS_simulated;
plotGauss.Callback = @plotPEIRS_simulated;
%initialise variables to be input into the plotting function
s_safe = []; s_risky = []; alpha_q = []; alpha_s = []; beta = []; omega = []; distType = [];


    function plotPEIRS_simulated(src, event)

        if strfind(event.Source.String, 'Gaussian Distribution')
            distType = 1;
            lowcol = [0.83 0.71 0.98];
            highcol = [0.62 0.35 0.99];        
        else 
            distType = 2;
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

end
