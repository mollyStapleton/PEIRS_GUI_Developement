function exploration_paramExplor_GUI

clc 
clear
close all hidden

mainFig = figure;
mainFig.Name = 'mainWindow';
mainFig.Position = [185.8000 1.8000 867.2000 780.8000];

%----------------------------------------------------------------------------
% GENERATE BASIC GRAPHICS FOR USER INPUT AND THE AXES FOR PLOTS 
%------------------------------------------------------------------------------------
% create axes for simulated average reward and spread to be plotted onto
ax_probRisky = uiaxes(mainFig, 'position', [300 540 500 220]);
ax_ucbRate = uiaxes(mainFig, 'Position', [300 280 500 220]);
ax_valueRate  = uiaxes(mainFig, 'position', [300 30 500 220]);

DistPanel       = uipanel(mainFig, 'title', 'Rewards', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop', 'Position', [.05 .82 .25 .1]);

% create dropdown menu for conditions to simulate selection
DistSel         = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [100 665 130 20]);
DistSel.String = {'Gaussian', 'Bimodal', 'Compare'};
DistSel.FontSize = 12;
DistSel.FontName = 'times';
DistSel.Callback = @plotExploration_simulated;

paramPanel      = uipanel(mainFig, 'title', 'Set Parameters', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white', 'Position', [.05 .35 .25 .45]);

%%%% Starting Paramaters
varPanel      = uipanel(mainFig, 'title', 'Initial Parameters', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.078 .67 .2 .1]);
text_qstart   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Q0',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [75 535 60 40]);
prompt_qstart = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [80 540 50 20]);
prompt_qstart.String = {'50'};
text_sstart   = uicontrol(mainFig, 'Style', 'Text', 'string', 'S0',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [175 535 60 40]);
prompt_sstart = uicontrol(mainFig, 'Style', 'edit', 'position', [180 540 50 20]);

%%%% Learning Rates Parameters
lrPanel      = uipanel(mainFig, 'title', 'Learning Rates:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.078 .57 .2 .1]);
text_lr  = uicontrol(mainFig, 'Style', 'Text', 'string', 'Alpha',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [125 455 60 40]);
prompt_lr = uicontrol(mainFig, 'Style', 'edit', 'FontName', 'times', 'position', [130 460 50 20]);

%%%% UCB Parameters
ucbPanel      = uipanel(mainFig, 'title', 'UCB:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.078 .47 .2 .1]);
text_ucb  = uicontrol(mainFig, 'Style', 'Text', 'string', 'c',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [125 380 60 40]);
prompt_ucb = uicontrol(mainFig, 'Style', 'edit', 'FontName', 'times', 'position', [130 385 50 20]);


%%%% Choice Parameters
smPanel      = uipanel(mainFig, 'title', 'softmax:', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.078 .37 .2 .1]);
text_beta  = uicontrol(mainFig, 'Style', 'Text', 'string', 'Beta',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [75 300 60 40]);
prompt_beta = uicontrol(mainFig, 'Style', 'edit', 'FontName', 'times', 'position', [80 305 50 20]);
text_omega   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Omega',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [175 300 60 40]);
prompt_omega = uicontrol(mainFig, 'Style', 'edit', 'position', [180 305 50 20]);


% button to be clicked and generate plot
 
plotSim = uicontrol(mainFig, 'Style', 'pushbutton', 'string', 'Simulate',...
    'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'times', 'position', [30 50 250 50]);
plotSim.Callback = @plotExploration_simulated;

%-------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------
%------ PUSH BUTTON AND SUBSEQUENT FUNCTIONS------------------------------
%-------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------

%initialise variables to be input into the plotting function
Q0 = []; S0 = []; c = []; alpha = []; beta = []; omega = []; distType = []; 
inp = []; accCol =[];

    function plotExploration_simulated(src, event)


        if DistSel.Value == 1 %gaussian
            distType = 1;
            hold_axes = 0;
            lowcol = {[0.83 0.71 0.98]};
            highcol = {[0.62 0.35 0.99]};
            C       = {[colormap(cbrewer2('BuPu', 40))]};
        elseif DistSel.Value == 2
            distType = 2;
            hold_axes = 0;
            lowcol = {[0.58 0.99 0.56]};
            highcol = {[0.19 0.62 0.14]};
            C       = {[colormap(cbrewer2('YlGn', 40))]};
        elseif DistSel.Value == 3
            distType = [1 2];
            hold_axes = 1;
            lowcol = {[0.83 0.71 0.98], [0.58 0.99 0.56]};
            highcol = {[0.62 0.35 0.99], [0.19 0.62 0.14]};
            C = [{colormap(cbrewer2('BuPu', 40))}, {colormap(cbrewer2('YlGn', 40))}];
        end

        Q0 = str2num(prompt_qstart.String{1});
        cla(ax_ucbRate);
        cla(ax_probRisky);
        cla(ax_valueRate);

        for idist = 1: length(distType)

            callbackSims_exploration;
    
            [Q_out, P_out, p_risky_out, V_out] = simulateExploration_allCond(Q0, S0, c, alpha, beta, omega, distType(idist));

            axes(ax_probRisky);
            % low-risky
            plot(p_risky_out(:, 2), 'color', lowcol{idist}, 'lineStyle', '-', 'linew', 1.2);
            hold on 
            smoothLow = smoothdata(p_risky_out(:, 2), 'movmean', 24);
            plot(smoothLow, 'color', lowcol{idist}, 'lineStyle', '-', 'linew', 3);
            % high-risk
            plot(p_risky_out(:, 4), 'color', highcol{idist}, 'lineStyle', '-', 'linew', 1.2);
            hold on
            smoothHigh = smoothdata(p_risky_out(:, 4), 'movmean', 24);
            plot(smoothHigh, 'color', highcol{idist}, 'lineStyle', '-', 'linew', 3);
            ylabel('P(Risky)');
            xlabel('No. Trials');
            title({'\bf \fontsize{12}  Risk Preferences'});
            set(gca, 'FontName', 'times')
            hold on 
            plot([0 120], [0.5 0.5], 'k--');
            legend({'Low-Risky (Sim.)', 'Low-Risky (Smoothed)', 'High-Risky (Sim.)',...
                'High-Risky (Smoothed)', ''},'location', 'best');

            axes(ax_ucbRate);
            plot(nanmean(V_out{1}), 'linestyle', '--', 'color', lowcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(V_out{2}), 'linestyle', '-', 'color', lowcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(V_out{3}), 'linestyle', '--', 'color', highcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(V_out{4}), 'linestyle', '-', 'color', highcol{idist}, 'LineWidth', 2);
            hold on 
            plot([0 120], [60 60], 'k--');
            hold on
            plot([0 120], [40 40], 'k--');        
            legend({'Low-Safe', 'Low-Risky', 'High-Safe', 'High-Risky'});
            xlabel('No. Trials');
            ylabel({'Average UCB Values'});
            title('\bf \fontsize{12} Change in UCB over Trials');
            set(gca, 'FontName', 'times');

            axes(ax_valueRate);
            plot(nanmean(Q_out{1}), 'linestyle', '--', 'color', lowcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(Q_out{2}), 'linestyle', '-', 'color', lowcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(Q_out{3}), 'linestyle', '--', 'color', highcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(Q_out{4}), 'linestyle', '-', 'color', highcol{idist}, 'LineWidth', 2);
            hold on 
            plot([0 120], [60 60], 'k--');
            hold on
            plot([0 120], [40 40], 'k--');        
            legend({'Low-Safe', 'Low-Risky', 'High-Safe', 'High-Risky'});
            xlabel('No. Trials');
            ylabel({'Simulated Average',  'Value (Learned)'});
            title('\bf \fontsize{12} Change in Value over Trials');
            set(gca, 'FontName', 'times');
    

        end


    end

end
