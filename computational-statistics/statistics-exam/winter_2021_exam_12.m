function winter_2021_exam_12()
    % A software package consists of 15 files. The download of each file is
    % a rare event that occurs at the rate of 2 per minute. Conduct a Monte
    % Carlo study to estimate:
    % a) the probability that it takes at least 6 minutes to download the
    % entire package;
    % b) the expected download time (in minutes) for the entire package.
    % Compare your results with the exact values.

    % GAMMA, because we have multiple independent files having same prob.

    lambda = 2; % 2/min
    a = 15; % 15 total files in the package

    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);

    for i = 1 : N
        X(i) = sum(-lambda * log(rand(a, 1))); % the Gamma variables
    end

    % GAMMA is a continuous distribution, therefore P(X>=6)==1-P(X<6).
    
    fprintf("Simulated prob. P(X>=6) := %f\n", mean(X >= 6))
    fprintf("Ground truth   1-P(X<6) := %f\n", 1 - gamcdf(6, a, lambda))
    fprintf("Error                    := %e\n\n", abs(1 - gamcdf(6, a, lambda) - mean(X >= 6)))
    
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', a/(1/lambda))
    fprintf('error = %e\n\n', abs(a/(1/lambda) - mean(X)))
end