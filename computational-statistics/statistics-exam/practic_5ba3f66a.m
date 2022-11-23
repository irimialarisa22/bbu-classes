function practic_5ba3f66a()
    % An internet search engine looks for a certain keyword in a sequence
    % of independent web sites. It is believed that 30% of the sites
    % contain a keyword. Conduct a Monte Carlo study to estimate:
    % a) the probability that the search engine has to visit at least 5
    % sites in order to find the first occurrence of the keyword;
    % b) the expected number of sites visited to get the first occurrence
    % of the keyword.
    % Compare your results with the exact values.

    % GEOMETRIC, because we wait for the first success

    p = 0.3;
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1:N
        while rand() >= p
            X(i) = X(i) + 1;
        end
    end

    fprintf('simulated probab. P(X>=5) = %1.5f\n', mean(X >= 5))
    fprintf('true probab. 1 - P(X<4) = %1.5f\n', 1-geocdf(4, p))
    fprintf('error = %e\n\n', abs(1 - geocdf(4, p) - mean(X >= 5)))

    q = 1-p;
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', q/p)
    fprintf('error = %e\n\n', abs(q/p - mean(X)))
end