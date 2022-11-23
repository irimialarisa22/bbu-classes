function winter_2021_exam_10()
    % About ten percent of users do not close Windows properly. Suppose
    % that Windows is installed in a public library that is used by random
    % people in a random order. Conduct a Monte Carlo study to estimate:
    % a) the probability that at least 7 users close Windows properly
    % before someone does not;
    % b) the expected number of people that close Windows properly before a
    % user does not.
    % Compare your results with the exact values.

    % GEOMETRIC, because we wait for the first successs (not closing ok)

    p = 0.1;  % 10% of users do NOT close Windows properly

    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1:N
        while rand() >= p
            X(i) = X(i) + 1;
        end
    end

    fprintf('simulated probab. P(X>=7) = %1.5f\n', mean(X >= 7))
    fprintf('true probab.   1 - P(X<6) = %1.5f\n', 1-geocdf(6, p))
    fprintf('error = %e\n\n', abs(1 - geocdf(6, p) - mean(X >= 7)))

    q = 1-p;
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean      E(X) = %5.5f\n', q/p)
    fprintf('error = %e\n\n', abs(q/p - mean(X)))
end