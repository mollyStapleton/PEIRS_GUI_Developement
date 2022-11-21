function plotPEIRS_simulated(src, event)

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
        
    end