if ~hold_axes 
    cla(ax_valueRate);
    cla(ax_probRisky);
%     cla(ax_spreadRate);
%     cla(ax_deltaStim);
end
% return all of the values input by the user within each prompt

inp = get(prompt_ap, 'string');
inp = str2num(inp);
alpha_p  = inp;

inp = get(prompt_an, 'string');
inp = str2num(inp);
alpha_n  = inp;

inp = get(prompt_beta, 'string');
inp = str2num(inp);
beta  = inp;

inp = get(FilenameSel, 'string');
filename = inp;
