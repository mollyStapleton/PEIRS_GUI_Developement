function PEIRS_paramExplor_GUI

clc 
clear
close all hidden

mainFig = figure;
mainFig.Name = 'mainWindow';
mainFig.Position = [185.8000 172.2000 1.3296e+03 453.6000];

modelFig = figure;
modelFig.Name = 'modelFig';
modelFig.Position =[419.4000 180.2000 372.8000 355.2000];

accFig = figure;
accFig.Name = 'accWindow';
accFig.Position =  [23.4000 47.4000 564 712];


%----------------------------------------------------------------------------
% GENERATE BASIC GRAPHICS FOR USER INPUT AND THE AXES FOR PLOTS 
%------------------------------------------------------------------------------------
% create axes for simulated average reward and spread to be plotted onto
ax_valueRate  = uiaxes(mainFig, 'position', [420 250 400 200]);
ax_spreadRate = uiaxes(mainFig, 'position', [420 30 400 200]);
ax_deltaStim  = uiaxes(mainFig, 'position', [850 250 400 200]);
ax_probRisky = uiaxes(mainFig, 'position', [850 30 400 200]);
ax_model = uiaxes(modelFig, 'Position', [30 30 300 300]);
ax_gauss    = uiaxes(accFig, 'Position', [30 375 300 300]);
ax_bimodal  = uiaxes(accFig, 'Position', [30 30 300 300]);

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
condSel.Callback = @plotPEIRS_simulated;

DistSel         = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [230 385 130 20]);
DistSel.String = {'Gaussian', 'Bimodal', 'Compare'};
DistSel.FontSize = 12;
DistSel.FontName = 'times';
DistSel.Callback = @plotPEIRS_simulated;


paramPanel      = uipanel(mainFig, 'title', 'Set Parameters', 'FontSize', 14,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white', 'Position', [.02 .18 .27 .55]);

%%%% Starting Paramaters
varPanel      = uipanel(mainFig, 'title', 'Initial Parameters', 'FontSize', 12,...
    'FontName', 'Times', 'FontWeight', 'Bold', 'Background', 'white',...
    'TitlePosition', 'centertop',  'Position', [.032 .53 .25 .15]);
text_qstart   = uicontrol(mainFig, 'Style', 'Text', 'string', 'Q0',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [55 250 100 40]);
prompt_qstart = uicontrol(mainFig, 'Style', 'popupmenu', 'position', [80 255 50 20]);
prompt_qstart.String = {'50'};
text_sstart   = uicontrol(mainFig, 'Style', 'Text', 'string', 'S0',...
    'FontSize', 8, 'FontWeight', 'bold', 'FontName', 'times', 'position', [260 250 100 40]);
prompt_sstart = uicontrol(mainFig, 'Style', 'edit', 'position', [285 255 50 20]);
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

%-------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------
%------ PUSH BUTTON AND SUBSEQUENT FUNCTIONS------------------------------
%-------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------

%initialise variables to be input into the plotting function
Q0 = []; S0 = []; alpha_q = []; alpha_s = [];
beta = []; omega = []; distType = []; condType = [];
filename = []; filename_1 = []; filename_2 = [];
data2save = []; deltaStim = []; 
inp = []; accCol =[];

    function plotPEIRS_simulated(src, event)


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

        if condSel.Value == 1
            condType = 1; %all
        else
            condType = 2; %risk preference only
        end

        Q0 = str2num(prompt_qstart.String{1});
        cla(ax_valueRate);
        cla(ax_probRisky);
        cla(ax_spreadRate);
        cla(ax_deltaStim);
        cla(ax_gauss);
        cla(ax_bimodal);
        cla(ax_model);

        for idist = 1: length(distType)

            callback_simParams;
    
            [Q_out, S_out, P_out, p_risky_out, deltaStim, prop_accuracy] = simulatePEIRS_allCond(Q0, S0, alpha_q,...
                alpha_s, beta, omega, distType(idist), condType);


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
    
            axes(ax_spreadRate);
            plot(nanmean(S_out{1}), 'linestyle', '--', 'color', lowcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(S_out{2}), 'linestyle', '-', 'color', lowcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(S_out{3}), 'linestyle', '--', 'color', highcol{idist}, 'LineWidth', 2);
            hold on
            plot(nanmean(S_out{4}), 'linestyle', '-', 'color', highcol{idist}, 'LineWidth', 2);
            legend({'Low-Safe', 'Low-Risky', 'High-Safe', 'High-Risky'});
            xlabel('No. Trials');
            ylabel({'Simulated Average',  'Spread (Learned)'});
            title('\bf \fontsize{12} Change in Spread over Trials');
            set(gca, 'FontName', 'times');
    
            axes(ax_deltaStim);
            plot(deltaStim, 'Color', highcol{idist}, 'lineStyle', '-', 'linew', 1.2);
            hold on 
            plot([1 120], [0 0], 'k--');
            xlabel('No. Trials');
            ylabel({'Stimulus Prediction Error'});
            title('\bf \fontsize{12} \delta Stimulus');
            set(gca, 'FontName', 'times');
    
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

            % plot models on same axes for poster 
            bin = [1:24:120];
            binSize = 24;
            for ibin = 1: length(bin)

                 
                mean_low{idist}(ibin) = nanmean(p_risky_out((bin(ibin): (bin(ibin) + binSize -1)), 2));
                sem_low{idist}(ibin) = nanstd(p_risky_out((bin(ibin): (bin(ibin) + binSize -1)), 2))...
                    ./sqrt(length(p_risky_out((bin(ibin): (bin(ibin) + binSize -1)), 2)));

                mean_high{idist}(ibin) = nanmean(p_risky_out((bin(ibin): (bin(ibin) + binSize -1)), 4));
                sem_high{idist}(ibin) = nanstd(p_risky_out((bin(ibin): (bin(ibin) + binSize -1)), 4))...
                    ./sqrt(length(p_risky_out((bin(ibin): (bin(ibin) + binSize -1)), 4)));
            end
    
            axes(ax_model);
            box on
            hold on 
            errorbar(mean_high{idist}, sem_high{idist}, 'color', highcol{idist}, 'linew', 1.5);
            errorbar(mean_low{idist}, sem_low{idist}, 'color', lowcol{idist}, 'linew', 1.5); 
            set(gca, 'FontSize', 14);
            xlim([0 6]);          
            ylim([0 1]);
            hold on
            plot([0 6], [0.5 0.5], 'k--');
            
            set(gca, 'FontName', 'Arial');

            if distType(idist) == 1  
                axes(ax_gauss);
                box on
            else 
                axes(ax_bimodal);
                box on
            end
            hold on
            for iplot = 1:4
                for ibin = 1: length(bin)
                     
                    acc_mean{idist}(iplot, ibin) = nanmean(prop_accuracy(iplot, (bin(ibin): bin(ibin) + binSize -1)));
                    acc_sem{idist}(iplot, ibin)  = nanstd(prop_accuracy(iplot, (bin(ibin): bin(ibin) + binSize -1)))...
                        ./sqrt(length(prop_accuracy(iplot, (bin(ibin): bin(ibin) + binSize -1))));
                end
                errorbar(acc_mean{idist}(iplot, :) , acc_sem{idist}(iplot, :), 'color', C{idist}(iplot*10, :), 'linew', 1.5);

            end
            hold on
            xlim([0 6]);
            if distType(idist) == 1
                ylim([0.4 1]);
            else 
                ylim([0 1]);
            end
            set(gca, 'XTick', [1:5]);
            hold on
            plot([0 6], [0.5 0.5], 'k--');
            %             plot([1 120], [0.5 0.5], 'k--');
            if distType(idist) == 1  
                legend({'LLSafe-HHRisky', 'LLSafe-HHSafe', 'LLRisky-HHSafe', 'LLRisky-HHRisky'}, 'position', [0.7 0.6 0.2 0.2]);
            else 
                legend({'LLSafe-HHRisky', 'LLSafe-HHSafe', 'LLRisky-HHSafe', 'LLRisky-HHRisky'}, 'position', [0.7 0.1 0.2 0.2]);
            end
          
            set(gca, 'FontName', 'Arial');
            set(gca, 'FontSize', 14);

            data2save.Q0        = Q0;
            data2save.S0        = S0;
            data2save.alpha_q   = alpha_q;
            data2save.alpha_s   = alpha_s;
            data2save.beta      = beta;
            data2save.omega     = omega;
            data2save.s_Q(1, :) = nanstd(Q_out{1});
            data2save.s_Q(2, :) = nanstd(Q_out{2});
            data2save.s_Q(3, :) = nanstd(Q_out{3});
            data2save.s_Q(4, :) = nanstd(Q_out{4});
            data2save.Q{1}      = (Q_out{1});
            data2save.Q{2}      = (Q_out{2});
            data2save.Q{3}      = (Q_out{3});
            data2save.Q{4}      = (Q_out{4});
            data2save.risk_low  = p_risky_out(:, 2);
            data2save.risk_high = p_risky_out(:, 4);
    
            filename = [DistSel.String{DistSel.Value} '_S0_' num2str(S0) '_aq_' num2str(alpha_q) '_as_' num2str(alpha_s) '.mat'];
            cd('C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\riskPreference_GUI_Developement\saveFits\PEIRS');
            save(filename, 'data2save');

            cd('C:\Users\jf22662\OneDrive - University of Bristol\Documents\riskAversion\modelbasedneurosci_2023');
            figure(2);
            gcf;
            filename_1 = ['poster_simulated_riskPreferences_PEIRS'];
            print(figure(2), filename_1, '-dpdf');
            figure(3);
            gcf;
            filename_2 = ['poster_simulated_accuracy'];
            print(figure(3), filename_2, '-dpdf');


        
        end
      
    end

end
