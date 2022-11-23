function prev_exam_2()
    % Only 80% of the components for some electronic equipment pass a
    % special inspection. Conduct a Monte Carlo study to estimate:
    % a) the probability that at least 3 components fail the inspection
    % before one passes it;
    % b) the expected number of components that fail the inspection before
    % one passes it.

    % GEOMETRIC, because we wait for the first success
    % we will have a geometric distribution, simulate a geometric random variable
    p = 0.8;
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1:N
        while rand() >= p
            X(i) = X(i) + 1;
        end
    end
    
    fprintf('a) P(X >= 3) = %1.5f\n', mean(X>=3))
    fprintf('a) but with 1-geocdf(2,0.8) = %1.5f\n', 1-geocdf(2,0.8))
    fprintf('b) E(X) = %1.5f\n', mean(X))
    fprintf('b) but with (1-p)/p = %1.5f\n', (1-p)/p)
    % a) should give around 1-geocdf(2,0.8), a very small number since
    % intuitively, if 80% pass, we should be extremely unlucky to have 3
    % components fail consecutively
    % b) should give around (1-p)/p
end