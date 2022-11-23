function winter_2021_exam_1()
    % A lab network consisting of 20 computers is attacked by a computer
    % virus. The virus enters each computer with probability 0.4,
    % independently of other computers. Conduct a Monte Carlo study to
    % estimate:
    % a) the probability that the virus entered at least 10 computers;
    % b) the expected number of computers attacked by the virus.
    % Compare your results with the exact values.

    % BINOMIAL, because multiple parts with same probability implied

    p=0.4;
    n = 20;  % we have a total of 20 computers
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1:N
        U = rand(n, 1);
        X(i) = sum(U < p);
    end

    % BINOMIAL distribution is discrete, therefore P(X>=10)==P(X<9).

    % Application/Comparison
    fprintf('simulated probab. P(X>=10) = %1.5f\n', mean(X >= 10))
    fprintf('true probab. P(X<9) = %1.5f\n', 1 - binocdf(9, n, p))
    fprintf('error = %e\n\n', abs(1 - binocdf(9, n, p) - mean(X >= 10)))
    
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', n*p)
    fprintf('error = %e\n\n', abs(n*p - mean(X)))
end