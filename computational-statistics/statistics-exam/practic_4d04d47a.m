function practic_4d04d47a()
    % A computer processes tasks in the order they are received. Processing
    % a task is a rare event that occurs at the rate of 3 per minute.
    % Conduct a Monte Carlo study to estimate:
    % a) the probability that it takes at least 75 seconds to process a
    % package consisting of 5 tasks;
    % b) the average processing time (in seconds) for the entire package.
    % Compare your results with the exact values.

    % GAMMA, because the time of the occurence of the 5th rare event
    % also, TOTAL PROCESSING TIME

    a = 5;
    lambda = 20;  % 3/min = 3/60seconds = 1/20 seconds

    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);

    for i = 1 : N
        X(i) = sum(-lambda * log(rand(a, 1))); % the Gamma variables
    end

    % GAMMA is a continuous distribution, therefore P(X>=75)==1-P(X<75).
    
    fprintf("Simulated prob. P(X>=75) := %1.5f\n", mean(X >= 75))
    fprintf("Ground truth   1-P(X<75) := %1.5f\n", 1 - gamcdf(75, a, lambda))
    fprintf("Error                    := %e\n\n", abs(1 - gamcdf(75, a, lambda) - mean(X >= 75)))
    
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', a/(1/lambda))
    fprintf('error = %e\n\n', abs(a/(1/lambda) - mean(X)))

end