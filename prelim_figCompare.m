% prelim figures to assess comparison of fits using the posNeg vs the PEIRS
% model 
clc 
clear all 
close all hidden 

% load in posNeg fits for params taken from Caze & Van Der Meer (2013)
% paper
cd('C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\riskPreference_GUI_Developement\saveFits\posNeg');

modelTypes = {'rational', 'optimistic', 'pessimistic'};

modelText  = {'R', 'O', 'P'};
modelCols  = {'k', 'g', 'r'};

lin2plot   = {'--', '-', '--', '-'};

distTypes  = {'Gaussian', 'Bimodal'};


% % Bimodal 
% h4 = subplot(2, 3, 4);  % Q
% h5 = subplot(2, 3, 5);  % std of Q
% h6 = subplot(2, 3, 6);  % risk preferences

for itype = 1:2

    if itype ==1 
        figure(1);
        % Gaussian
        h1 = subplot(3, 2, 1);  % Q
        h2 = subplot(3, 2, 2);  % std of Q
        h3 = subplot(3, 2, 3);  % Q
        h4 = subplot(3, 2, 4);  % std of Q
        h5 = subplot(3, 2, 5);  % Q
        h6 = subplot(3, 2, 6);  % std of Q
    else
        clf;
        figure(1);
        % Bimodal
        h1 = subplot(3, 2, 1);  % Q
        h2 = subplot(3, 2, 2);  % std of Q
        h3 = subplot(3, 2, 3);  % Q
        h4 = subplot(3, 2, 4);  % std of Q
        h5 = subplot(3, 2, 5);  % Q
        h6 = subplot(3, 2, 6);  % std of Q
    end

    for im = 1: length(modelTypes)
    
        tmpModelFilename = [modelTypes{im} 'agent_' distTypes{itype} '.mat'];
        load(tmpModelFilename);
        axes(h1);
        for istim = 1:4
            hold on 

            if istim == 1 | istim == 3 
                faceCol = [1 1 1]; %safe options 
            else 
                faceCol = modelCols{im};
            end

            tmpData = [];
            tmpData = nanmean(data2save.Q(istim, :));
            if istim == 1 | istim == 2
                axes(h1)
                hold on 
                plot(im, tmpData, 'o', 'MarkerFaceColor', faceCol, 'MarkerEdgeColor',...
                    modelCols{im}, 'linew', 1.5, 'MarkerSize', 10);
            else 
                axes(h2)
                hold on 
                plot(im, tmpData, 'o', 'MarkerFaceColor', faceCol, 'MarkerEdgeColor',...
                    modelCols{im}, 'linew', 1.5, 'MarkerSize', 10);
            end

            tmpData = [];
            tmpData = nanmean(data2save.s_Q(istim, :));

            if istim == 1 | istim == 2
                axes(h3)
                hold on 
                plot(im, tmpData, 'o', 'MarkerFaceColor', faceCol, 'MarkerEdgeColor',...
                    modelCols{im}, 'linew', 1.5, 'MarkerSize', 10);
            else 
                axes(h4)
                hold on 
                plot(im, tmpData, 'o', 'MarkerFaceColor', faceCol, 'MarkerEdgeColor',...
                    modelCols{im}, 'linew', 1.5, 'MarkerSize', 10);
            end

           
            if istim == 1 | istim == 2
                tmpData = [];
                tmpData = nanmean(data2save.risk_low);
                axes(h5)
                hold on 
                plot(im, tmpData, 'o', 'MarkerFaceColor', faceCol, 'MarkerEdgeColor',...
                    modelCols{im}, 'linew', 1.5, 'MarkerSize', 10);
            else 
                tmpData = [];
                tmpData = nanmean(data2save.risk_high);
                axes(h6)
                hold on 
                plot(im, tmpData, 'o', 'MarkerFaceColor', faceCol, 'MarkerEdgeColor',...
                    modelCols{im}, 'linew', 1.5, 'MarkerSize', 10);
            end
        end
    end

    axes(h1);
    axis square
    hold on 
    if itype == 1
        ylim([30 50]);
    else 
        ylim([10 100]);
    end
    xlim([0 4]);
    hold on 
    plot([0 4], [40 40], 'k--');
    set(gca, 'XTick', [1 2 3]);
    set(gca, 'XTicklabels', {'R', 'O', 'P'});
    xlabel('ModelType');
    ylabel('Average Q');
    legend({'Safe', 'Risky'});
    title({'\fontsize{16} \bf Both-LOW', '\fontsize{12}Average Q'});
    set(gca, 'FontName', 'times');
    axes(h2);
    axis square
    hold on 

    if itype == 1
        ylim([50 80]);
    else 
        ylim([10 150]);
    end

    xlim([0 4]);
    hold on 
    plot([0 4], [60 60], 'k--');
    set(gca, 'XTick', [1 2 3]);
    set(gca, 'XTicklabels', {'R', 'O', 'P'});
    xlabel('ModelType');
    ylabel('Average Q');
    legend({'Safe', 'Risky'});
    title({'\fontsize{16} \bf Both-HIGH', '\fontsize{12}Average Q'});
    set(gca, 'FontName', 'times');

    axes(h3);
    axis square
    hold on 
    xlim([0 4]);
    if itype == 1 
        ylim([0 20]);
        hold on 
        plot([0 4], [5 5], 'k--');
    else 
        ylim([0 150]);
    end

    set(gca, 'XTick', [1 2 3]);
    set(gca, 'XTicklabels', {'R', 'O', 'P'});
    xlabel('ModelType');
    ylabel('Average S');
    legend({'Safe', 'Risky'});
    title({'\fontsize{12}Average S'});
    set(gca, 'FontName', 'times');
    axes(h4);
    axis square
    hold on 
    xlim([0 4]);    
    if itype == 1 
        ylim([0 20]);
        hold on 
        plot([0 4], [15 15], 'k--');
    else 
        ylim([0 150]);
    end

    set(gca, 'XTick', [1 2 3]);
    set(gca, 'XTicklabels', {'R', 'O', 'P'});
    xlabel('ModelType');
    ylabel('Average S');
    legend({'Safe', 'Risky'});
    title({'\fontsize{12}Average S'});
    set(gca, 'FontName', 'times');

    axes(h5);
    axis square
    hold on 
    ylim([0 1]);
    xlim([0 4]);
    plot([0 4], [0.5 0.5], 'k--');
    set(gca, 'XTick', [1 2 3]);
    set(gca, 'XTicklabels', {'R', 'O', 'P'});
    xlabel('ModelType');
    ylabel('Average P(Risky)');
    legend({'Safe', 'Risky'});
    title({'\fontsize{12}Average P(Risky)'});
    set(gca, 'FontName', 'times');
    axes(h6);
    axis square
    hold on 
    ylim([0 1]);
    xlim([0 4]);
    plot([0 4], [0.5 0.5], 'k--');
    set(gca, 'XTick', [1 2 3]);
    set(gca, 'XTicklabels', {'R', 'O', 'P'});
    xlabel('ModelType');
    ylabel('Average P(Risky)');
    legend({'Safe', 'Risky'});
    title({'\fontsize{12}Average P(Risky)'});
    set(gca, 'FontName', 'times');

    if itype == 1 
         t = sgtitle('\fontsize{18} \bf \fontname{times} Gaussian');
         t.Color = [0.62 0.35 0.99];

        saveFigName = ['paramComparison_Gaussian'];
    else 
        
        t = sgtitle('\fontsize{18} \bf \fontname{times} Bimodal');
        t.Color = [0.19 0.62 0.14];
        saveFigName = ['paramComparison_Bimodal'];
    end
    
    set(gcf, 'units', 'centimeters');
    set(gcf, 'position', [62.5898 -4.6567 25.6328 25.3365]);
    print(saveFigName, '-dpng');
end

cd('C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\riskPreference_GUI_Developement\saveFits\PEIRS');
paramTypes = {'aq_0.3_as_0.1', 'aq_0.5_as_0.1'};

clf;
figure(3);
set(gcf, 'units', 'centimeters');
h1 = subplot(1, 2, 1);
h2 = subplot(1, 2, 2);

for itype = 1:2


        if itype == 1
            col2plot = [0.7059 0.4745 0.9882];
%             col2plot_alpha = [0.9255    0.8039    0.9804];
        else
            col2plot = [0.3961 0.9608 0.3647];
%             col2plot_alpha = [ 0.7176    0.9882    0.7020];
        end


    for im = 1: length(paramTypes)

        x2plot  = {[1 1 2.5 2.5], [1.5 1.5 3 3]};

        tmpModelFilename = [distTypes{itype} '_S0_0.5_' paramTypes{im} '.mat'];
        load(tmpModelFilename);

        

        for istim = 1:4

            if istim == 1 | istim == 3 
                faceCol = [1 1 1]; %safe options 
            else 
                faceCol = col2plot;
            end

            
            tmpMean = [];
            tmpMean = nanmean(nanmean(data2save.Q{istim}));
            tmpSem  = [];
            tmpSem  = nanstd(nanstd(data2save.Q{istim}))./sqrt(length(data2save.Q{istim}));
    
            axes(h1);
            hold on 
            errorbar(x2plot{im}(istim), tmpMean, tmpSem, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor',...
                faceCol, 'MarkerEdgeColor', col2plot, 'color', col2plot, 'linew', 1.2);

            tmpRisk_low         = [];
            tmpRisk_high        = [];

            tmpRisk_low_mean    = nanmean(data2save.risk_low);
            tmpRisk_high_mean   = nanmean(data2save.risk_high);
            tmpRisk_low_std     = nanstd(data2save.risk_low)./sqrt(length(data2save.risk_low));
            tmpRisk_high_std    = nanstd(data2save.risk_high)./sqrt(length(data2save.risk_high));

            axes(h2);
            hold on
            if im == 1 
                errorbar(1, tmpRisk_low_mean, tmpRisk_low_std, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor',...
                    faceCol, 'MarkerEdgeColor', col2plot, 'color', col2plot, 'linew', 1.2);
                errorbar(2.5, tmpRisk_high_mean, tmpRisk_high_std, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor',...
                    faceCol, 'MarkerEdgeColor', col2plot, 'color', col2plot, 'linew', 1.2);
            else 
                errorbar(1.5, tmpRisk_low_mean, tmpRisk_low_std, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor',...
                    faceCol, 'MarkerEdgeColor', col2plot, 'color', col2plot, 'linew', 1.2);
                errorbar(3, tmpRisk_high_mean, tmpRisk_high_std, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor',...
                    faceCol, 'MarkerEdgeColor', col2plot, 'color', col2plot, 'linew', 1.2);
            end

        end

    end



end

