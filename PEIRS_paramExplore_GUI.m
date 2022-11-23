function PEIRS_paramExplor_GUI

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
ax_valueRate = uiaxes(mainFig, 'position', [420 30 400 400]);
ax_probRisky = uiaxes(mainFig, 'position', [860 30 400 400]);

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
DistSel         = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [230 385 130 20]);
DistSel.String = {'Gaussian', 'Bimodal'};
DistSel.FontSize = 12;
DistSel.FontName = 'times';


paramPanel      = uipanel(mainFig, 'title', 'Set Parameters', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white', 'Position', [.02 .18 .27 .55]);

% text_cndAll     = uicontrol(mainFig, 'Style', 'Text', 'String', 'ALL',...
%         'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'times', 'position',  [50 325 130 20]);
% prompt_cndAll   = uicontrol(mainFig, 'Style', 'edit', 'position', [50 290 130 20]);
% text_prefCond   = uicontrol(mainFig, 'Style', 'Text', 'String', 'Risk Pref. Only',...
%         'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'times', 'position',  [200 325 130 20]); 
% prompt_prefCond   = uicontrol(mainFig, 'Style', 'edit', 'position', [200 290 130 20]);

% prompts for parameter inputs 
%%%% Variance paramaters
varPanel      = uipanel(mainFig, 'title', 'Variance:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .53 .25 .15]);
text_ssafe   = uicontrol(mainFig, 'Style', 'Text', 'string', 'SAFE',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [55 250 100 40]);
prompt_ssafe = uicontrol(mainFig, 'Style', 'edit', 'position', [80 255 50 20]);
text_srisky   = uicontrol(mainFig, 'Style', 'Text', 'string', 'RISKY',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [260 250 100 40]);
prompt_srisky = uicontrol(mainFig, 'Style', 'edit', 'position', [285 255 50 20]);
%%%% Learning rate parameters
lrPanel      = uipanel(mainFig, 'title', 'Learing Rates:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .37 .25 .15]);
text_aq   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Q',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [55 178 100 40]);
prompt_aq = uicontrol(mainFig, 'Style', 'edit', 'position', [80 184 50 20]);
text_as   = uicontrol(mainFig, 'Style', 'Text', 'string', 'S',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [260 178 100 40]);
prompt_as = uicontrol(mainFig, 'Style', 'edit', 'position', [285 184 50 20]);
%%%% Choice Parameters
smPanel      = uipanel(mainFig, 'title', 'softmax:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .21 .25 .15]);
text_beta  = uicontrol(mainFig, 'Style', 'Text', 'string', 'Beta',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [55 108 100 40]);
prompt_beta = uicontrol(mainFig, 'Style', 'edit', 'FontName', 'times', 'position', [80 112 50 20]);
text_omega   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Omega',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [260 108 100 40]);
prompt_omega = uicontrol(mainFig, 'Style', 'edit', 'position', [285 112 50 20]);

% button to be clicked and generate plot
 
plotSim = uicontrol(mainFig, 'Style', 'pushbutton', 'string', 'Simulate',...
    'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'times', 'position', [90 20 250 50]);
plotSim.Callback = @plotPEIRS_simulated;

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
