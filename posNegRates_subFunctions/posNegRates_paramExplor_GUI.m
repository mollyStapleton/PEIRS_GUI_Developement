function posNegRates_paramExplor_GUI

clc 
clear
close all hidden

mainFig = figure;
mainFig.Name = 'mainWindow';
mainFig.Position = [185.8000 172.2000 1.3296e+03 453.6000];

%----------------------------------------------------------------------------
% GENERATE BASIC GRAPHICS FOR USER INPUT AND THE AXES FOR PLOTS 
%------------------------------------------------------------------------------------
% create axes for simulated average reward and spread to be plotted onto
ax_valueRate  = uiaxes(mainFig, 'position', [420 30 400 400]);
ax_probRisky  = uiaxes(mainFig, 'position', [860 30 400 400]);


CondPanel      = uipanel(mainFig, 'title', 'Conditions', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop', 'Position', [.02 .77 .125 .2]);

DistPanel       = uipanel(mainFig, 'title', 'Rewards', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop', 'Position', [.16 .77 .125 .2]);

% create dropdown menu for conditions to simulate selection 

condSel         = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [50 385 120 20]);
condSel.String = {'All Conditions', 'Risk Preference'};
condSel.FontSize = 12;
condSel.FontName = 'times';
condSel.Callback = @plotPosNegRates_simulated;

DistSel         = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [230 385 130 20]);
DistSel.String = {'Gaussian', 'Bimodal'};
DistSel.FontSize = 12;
DistSel.FontName = 'times';
DistSel.Callback = @plotPosNegRates_simulated;


paramPanel      = uipanel(mainFig, 'title', 'Set Parameters', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white', 'Position', [.02 .18 .27 .55]);

%%%% Starting Paramaters
varPanel      = uipanel(mainFig, 'title', 'Initial Parameters', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .53 .25 .15]);
text_qstart   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Q0',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [160 250 100 40]);
prompt_qstart = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [190 255 50 20]);
prompt_qstart.String = {'50'};

%%%% Learning rate parameters
lrPanel      = uipanel(mainFig, 'title', 'Learing Rates:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .37 .25 .15]);
text_ap   = uicontrol(mainFig, 'Style', 'Text', 'string', '+ve',...
    'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'times', 'position', [55 178 100 40]);
prompt_ap = uicontrol(mainFig, 'Style', 'edit', 'position', [80 184 50 20]);
text_an   = uicontrol(mainFig, 'Style', 'Text', 'string', '-ve',...
    'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'times', 'position', [260 178 100 40]);
prompt_an = uicontrol(mainFig, 'Style', 'edit', 'position', [285 184 50 20]);
%%%% Choice Parameters
smPanel      = uipanel(mainFig, 'title', 'softmax:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .21 .25 .15]);
text_beta  = uicontrol(mainFig, 'Style', 'Text', 'string', 'Beta',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [160 105 100 40]);
prompt_beta = uicontrol(mainFig, 'Style', 'edit', 'FontName', 'times', 'position', [185 112 50 20]);

% button to be clicked and generate plot
 
plotSim = uicontrol(mainFig, 'Style', 'pushbutton', 'string', 'Simulate',...
    'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'times', 'position', [90 20 250 50]);
plotSim.Callback = @plot_posNegRates_simulated;

%initialise variables to be input into the plotting function
Q0 = []; alpha_p = []; alpha_n = [];
beta = []; distType = []; condType = [];
inp = [];

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

end