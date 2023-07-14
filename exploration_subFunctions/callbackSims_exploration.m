% cla(ax_ucbRate);
% cla(ax_probRisky);
% cla(ax_valueRate);
% return all of the values input by the user within each prompt
inp = get(prompt_sstart, 'string');
inp = str2num(inp);
S0  = inp;
% inp = get(prompt_srisky, 'string');
% inp = str2num(inp);
% s_risky  = inp;

inp = get(prompt_lr, 'string');
inp = str2num(inp);
alpha  = inp;

inp = get(prompt_ucb, 'string');
inp = str2num(inp);
c  = inp;

inp = get(prompt_beta, 'string');
inp = str2num(inp);
beta  = inp;

inp = get(prompt_omega, 'string');
inp = str2num(inp);
omega  = inp;