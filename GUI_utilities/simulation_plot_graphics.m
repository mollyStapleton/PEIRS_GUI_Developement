axes(ax_valueRate);

plot(nanmean(Q_out{1, 1}'), 'linestyle', '--', 'color', lowcol, 'LineWidth', 2);
hold on
plot(nanmean(Q_out{2})', 'linestyle', '-', 'color', lowcol, 'LineWidth', 2);
hold on
plot(nanmean(Q_out{3})', 'linestyle', '--', 'color', highcol, 'LineWidth', 2);
hold on
plot(nanmean(Q_out{4})', 'linestyle', '-', 'color', highcol, 'LineWidth', 2);
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