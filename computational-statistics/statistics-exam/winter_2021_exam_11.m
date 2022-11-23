function winter_2021_exam_11()
    % An internet virus can damage a file with probability 0.2,
    % independently of other files. A computer manager checks the condition
    % of all important files. Conduct a Monte Carlo study to estimate: 
    % a) the probability that the manager finds at least 8 clean files
    % before finding a damaged one;
    % b) the expected number of clean files found before finding a damaged
    % one.
    % Compare your results with the exact values.

    % very similar to winter_2021_exam_9; however, this is different
    % GEOMETRIC, because everything matters before finding a damaged file

    p = 0.2;  % finding clean a file represents a failure.
    % p is the probability of successfully finding a corrupted file.
    
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1:N
        while rand() >= p
            X(i) = X(i) + 1;
        end
    end

    fprintf('simulated probab. P(X>=8) = %1.5f\n', mean(X >= 8))
    fprintf('true probab.   1 - P(X<7) = %1.5f\n', 1-geocdf(7, p))
    fprintf('error = %e\n\n', abs(1 - geocdf(7, p) - mean(X >= 8)))

    q = 1-p;
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean      E(X) = %5.5f\n', q/p)
    fprintf('error = %e\n\n', abs(q/p - mean(X)))
end