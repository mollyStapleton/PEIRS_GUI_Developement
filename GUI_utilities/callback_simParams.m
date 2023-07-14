
% if ~hold_axes
%     cla(ax_valueRate);
%     cla(ax_probRisky);
%     cla(ax_spreadRate);
%     cla(ax_deltaStim);
%     cla(ax_accuracy);
% end

% return all of the values input by the user within each prompt
inp = get(prompt_sstart, 'string');
inp = str2num(inp);
S0  = inp;
% inp = get(prompt_srisky, 'string');
% inp = str2num(inp);
% s_risky  = inp;

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

