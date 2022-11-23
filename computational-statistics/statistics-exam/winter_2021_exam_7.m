function winter_2021_exam_7()
    % Printing jobs arriving at a printer are rare events that occur at the
    % rate of 3 per minute. Conduct a Monte Carlo study to estimate:
    % a) the probability that at least 25 seconds pass between printing two
    % consecutive documents;
    % b) the expected time (in seconds) between printing two consecutive
    % documents.
    % Compare your results with the exact values.

    % EXPONENTIAL, because time between rare events

    lambda = 1/20; % 3/min = 3/60s = 1/20s

    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    Y = zeros(1, N);
    for i = 1 : N
        Y(i) = -1 / lambda * log(rand);
    end

    % Application/Comparison
    fprintf('simulated probab. P(Y >= 25) = %1.5f\n', mean(Y>=25))
    fprintf('true probab. 1 - P(Y < 25) = %1.5f\n', 1 - expcdf(25,1/lambda))
    fprintf('error = %e\n\n', abs(1 - expcdf(25,1/lambda) - mean(Y>=25)))
    
    fprintf('simulated mean E(Y) = %5.5f\n', mean(Y))
    fprintf('true mean E(Y) = %5.5f\n', 1/lambda)
    fprintf('error = %e\n\n', abs(1/lambda - mean(Y)))
end