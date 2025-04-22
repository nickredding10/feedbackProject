function ca = genCACODE(prn)

    % GPS C/A code generation (G1 & G2)

    g1 = -1 * ones(1, 10); g2 = -1 * ones(1, 10);

    ca = zeros(1, 1023);

    tapTable = [...  % Tap table for different PRNs

        2,6;3,7;4,8;5,9;1,9;2,10;1,8;2,9;3,10;2,3;

        3,4;5,6;6,7;7,8;8,9;9,10;1,4;2,5;3,6;4,7;

        5,8;6,9;1,3;4,6;5,7;6,8;7,9;8,10;1,6;2,7;

        3,8;4,9];

    taps = tapTable(prn, :);

 

    for i = 1:1023

        g1_out = g1(end);

        g2_out = g2(taps(1)) * g2(taps(2));

        ca(i) = g1_out * g2_out;

 

        % Shift G1

        g1_next = g1(3) * g1(10);

        g1 = [g1_next, g1(1:9)];

 

        % Shift G2

        g2_next = g2(2)*g2(3)*g2(6)*g2(8)*g2(9)*g2(10);

        g2 = [g2_next, g2(1:9)];

    end

 

    ca = (1 - ca) / 2 * 2 - 1; % Convert to bipolar {-1, +1}

end

 