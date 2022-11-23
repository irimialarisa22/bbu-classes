function practic_34d08cc1()
    % A vaccine against a certain virus meets specifications with
    % probability 0.9. Conduct a Monte Carlo study to estimate:
    % a) the probability that 5 vaccines have to be teste to find three
    % that meet specifications;
    % b) the expected number of defective vaccines discovered before the
    % third good one is found.
    % Compare your results with the exact values.

    % NEGATIVE_BINOMIAL, because number of trials to achieve a number of successes

    p = 0.9;  % probability of meeting the specs
    n = 3;  % we want three good vaccines

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
    fprintf('simulated probab. P(X = 5) = %1.5f\n', mean(X == 5))
    fprintf('true probab. P(X = 5) = %1.5f\n', nbinpdf(5, n, p))
    fprintf('error = %e\n\n', abs(nbinpdf(5, n, p) - mean(X == 5)))
    
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', n * q / p)
    fprintf('error = %e\n\n', abs(n*q / p - mean(X)))
end