%%%%%% GENERATE P(RISKY) COMPARISON PLOTS FOR PARAMETER EXPLORATION OF THE
%%%%%% POSNEGRATES MODEL
clc 
clear all 
close all hidden 
fig = figure(1);
set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [8.4878 1.0795 23.7278 19.6003]);
h1= subplot(2, 2, 1);
h2 = subplot(2, 2, 2);
h3 = subplot(2, 2, 3);
h4 = subplot(2, 2, 4);


for itype = 1:2

countP=0;countN=0;
for P_RL=0.01:0.05:0.99
    countP=countP+1;
    countN=0;
    for N_RL = 0.01:0.05:0.99
               lowcol = {[0.83 0.71 0.98], [0.58 0.99 0.56]};
               highcol = {[0.62 0.35 0.99], [0.19 0.62 0.14]};
                countN=countN+1;
                [risky_HH, risky_LL] = compareLRs(50, P_RL, N_RL, 0.3, itype, 1);
                % risk preferences for both-HIGH 'risky' choice across range of LR
                HH2plot{itype}(countP, countN) = nanmean(risky_HH);
                % risk preferences for both-LOW 'risky' choice across range of LR
                LL2plot{itype}(countP, countN) = nanmean(risky_LL);
        
                
    end

end

labelAxes = string(0.01:0.2:0.96);

if itype == 1 

    axes(h1);
    hold on 
    imagesc(LL2plot{itype});
    set(gca,'Ydir','normal');
    set(gca, 'XTick', [1:4:20]);
    set(gca, 'YTick', [1:4:20]);
    set(gca, 'XLim', [1 20]);
    set(gca, 'YLim', [1 20]);
    set(gca, 'XTickLabel', labelAxes);
    xlabel('\fontsize{12} \bf -VE LR');
    ylabel('\fontsize{12} \bf +VE LR');
    set(gca, 'YTickLabel', labelAxes);
    title('\fontsize{14} \bf Gaussian: Low-Low');
    set(gca, 'FontName', 'times');
    C = colormap(cbrewer2('RdBu', 100));
    axes(h2);
    hold on 
    imagesc(HH2plot{itype});
    set(gca,'Ydir','normal');
    set(gca, 'XTick', [1:4:20]);
    set(gca, 'YTick', [1:4:20]);
    set(gca, 'XLim', [1 20]);
    set(gca, 'YLim', [1 20]);
    set(gca, 'XTickLabel', labelAxes);
    set(gca, 'YTickLabel', labelAxes);
    xlabel('\fontsize{12} \bf -VE LR');
    ylabel('\fontsize{12} \bf +VE LR');
    C = colormap(cbrewer2('RdBu', 100));
    title('\fontsize{14} \bf Gaussian: High-High');
    set(gca, 'FontName', 'times');
else 
    axes(h3);
    hold on 
    imagesc(LL2plot{itype});
    set(gca,'Ydir','normal');
    set(gca, 'XTick', [1:4:20]);
    set(gca, 'YTick', [1:4:20]);
    set(gca, 'XLim', [1 20]);
    set(gca, 'YLim', [1 20]);
    set(gca, 'XTickLabel', labelAxes);
    set(gca, 'YTickLabel', labelAxes);
    xlabel('\fontsize{12} \bf -VE LR');
    ylabel('\fontsize{12} \bf +VE LR');
    title('\fontsize{14} \bf Bimodal: Low-Low');
    C = colormap(cbrewer2('RdBu', 100));
    set(gca, 'FontName', 'times');
    axes(h4);
    hold on 
    imagesc(HH2plot{itype});
    set(gca,'Ydir','normal');
    set(gca, 'XTick', [1:4:20]);
    set(gca, 'YTick', [1:4:20]);
    set(gca, 'XLim', [1 20]);
    set(gca, 'YLim', [1 20]);
    set(gca, 'XTickLabel', labelAxes);
    set(gca, 'YTickLabel', labelAxes);
    xlabel('\fontsize{12} \bf -VE LR');
    ylabel('\fontsize{12} \bf +VE LR');
    title('\fontsize{14} \bf Bimodal: High-High');
    C = colormap(cbrewer2('RdBu', 100));
    set(gca, 'FontName', 'times');
end

end

gcf;
C1 = colorbar;
C1.Position = [0.93 0.27 0.03 0.5];
C1.Limits   = [0 1];




figure(2);
set(gcf, 'Units', 'centimeters');
set(gcf, 'position', [9.6732 9.5673 27.1992 10.5675]);
h5 = subplot(1, 2, 1);
h6 = subplot(1, 2, 2);
axes(h5);
hold on
imagesc(HH2plot{1} - LL2plot{1});
set(gca,'Ydir','normal');
set(gca, 'XTick', [1:4:20]);
set(gca, 'YTick', [1:4:20]);
set(gca, 'XLim', [1 20]);
set(gca, 'YLim', [1 20]);
set(gca, 'XTickLabel', labelAxes);
set(gca, 'YTickLabel', labelAxes);
xlabel('\fontsize{12} \bf -VE LR');
ylabel('\fontsize{12} \bf +VE LR');
C = colormap(cbrewer2('RdBu', 100));
title('\fontsize{14} \bf Gaussian: HH-LL');
set(gca, 'fontname', 'times');
axes(h6);
hold on
imagesc(HH2plot{2} - LL2plot{2});
set(gca,'Ydir','normal');
set(gca, 'XTick', [1:4:20]);
set(gca, 'YTick', [1:4:20]);
set(gca, 'XLim', [1 20]);
set(gca, 'YLim', [1 20]);
set(gca, 'XTickLabel', labelAxes);
set(gca, 'YTickLabel', labelAxes);
xlabel('\fontsize{12} \bf -VE LR');
ylabel('\fontsize{12} \bf +VE LR');
title('\fontsize{14} \bf Bimodal: HH-LL');
C = colormap(cbrewer2('RdBu', 100));
set(gca, 'fontname', 'times');
gcf;
C2 = colorbar;
C2.Position = [0.93 0.27 0.03 0.5];
C2.Limits   = [0 1];

modelTypes = {'PosLRHigher', 'NegLRHigher'};
figure(1);
set(gcf, 'Units', 'centimeters');
h1 = subplot(1, 2, 1);
h2 = subplot(1, 2, 2);
for itype = 1:2

    if itype == 1 
        distName = 'Gaussian';
    else 
        distName = 'Bimodal';
    end



    for imodel = 1: length(modelTypes)

        loadModelname = [modelTypes{imodel} '_' distName '.mat'];
        load(loadModelname);

        p_risky_low{imodel} = data2save.risk_low;
        p_risky_high{imodel} = data2save.risk_high;
        


    end 

    axes(h1); %both-LOW condition 
    % posLR higher vs negLR higher
    hold on 
    plot([p_risky_low{1}], [p_risky_low{2}], '.', 'color', lowcol{itype},...
        'MarkerSize', 25);

    axes(h2); %both-HIGH condition 
    % posLR higher vs negLR higher
    hold on 
    plot([p_risky_high{1}], [p_risky_high{2}], '.', 'color', lowcol{itype},...
        'MarkerSize', 25);


end

axes(h1);
axis square
xlim([0 1]);
ylim([0 1]);
hold on 
xlabel('NegativeLR = 0.9, PositiveLR = 0');
ylabel('NegativeLR = 0, PositiveLR = 0.9');
x2plot = linspace(0, 1);
hold on 
plot(x2plot, x2plot, 'k--');
plot([0 1], [0.5 0.5], 'k-');
plot([0.5 0.5], [0 1], 'k-');
title('\fontsize{14} \bf Both-LOW');
set(gca, 'FontName', 'times');
axes(h2);
axis square
xlim([0 1]);
ylim([0 1]);
hold on 
xlabel('NegativeLR = 0.9, PositiveLR = 0');
ylabel('NegativeLR = 0, PositiveLR = 0.9');
x2plot = linspace(0, 1);
hold on 
plot(x2plot, x2plot, 'k--');
plot([0 1], [0.5 0.5], 'k-');
plot([0.5 0.5], [0 1], 'k-');
title('\fontsize{14} \bf Both-HIGH');
set(gca, 'FontName', 'times');