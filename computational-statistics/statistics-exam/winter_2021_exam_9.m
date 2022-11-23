function winter_2021_exam_9()
    % A computer virus can damage a file with probability 0.2,
    % independently of other files. A computer manager checks the condition
    % of important files. Conduct a Monte Carlo study to estimate:
    % a) the probability that the manager has to check 8 files in order to
    % find 3 damaged ones;
    % b) the expected number of clean files found before finding the third
    % damaged one.
    % Compare your results with the exact values.

    % NEGATIVE BINOMIAL, because multiple successes are required

    p = 0.2;
    n = 3;  % we want three damaged computers

    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    
    for i = 1 : N
        for j = 1 : n
            Y(j) = 0;
            while rand >= p
                Y(j) = Y(j) + 1;
            end
        end
        X(i) = sum(Y);
    end

    q = 1 - p;
    % Application/Comparison
    fprintf('simulated probab. P(X = 8) = %1.5f\n', mean(X == 8))
    fprintf('true probab. P(X = 8) = %1.5f\n', nbinpdf(8, n, p))
    fprintf('error = %e\n\n', abs(nbinpdf(8, n, p) - mean(X == 8)))
    
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', n * q / p)
    fprintf('error = %e\n\n', abs(n*q / p - mean(X)))
end