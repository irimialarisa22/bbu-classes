function winter_2021_exam_6()
    % Before a computer is assembled, its vital component (motherboard)
    % goes through a special inspection. Only 90% of components pass this
    % inspection. Conduct a Monte Carlo study to estimate:
    % a) the probability that at least 2 components have to be inspected to
    % find one that passes inspection;
    % b) the expected number of components that have to be inspected to
    % find one that passes it.
    % Compare your results with the exact values.

    % GEOMETRIC, because failed inspections until good find

    p = 0.9;

    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1:N
        while rand() >= p
            X(i) = X(i) + 1;
        end
    end

    fprintf('simulated probab. P(X>=2) = %1.5f\n', mean(X >= 2))
    fprintf('true probab. 1 - P(X<1) = %1.5f\n', 1-geocdf(1, p))
    fprintf('error = %e\n\n', abs(1 - geocdf(1, p) - mean(X >= 2)))

    q = 1-p;
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', q/p)
    fprintf('error = %e\n\n', abs(q/p - mean(X)))
end