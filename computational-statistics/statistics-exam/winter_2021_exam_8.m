function winter_2021_exam_8()
    % Messages arrive at an electronic message center at random times, 1
    % message every 6 minutes. Conduct a Monte Carlo study to estimate:
    % a) the probability of receiving at least 5 messages during the next
    % hour;
    % b) the average number of messages received in one hour.
    % Compare your results with the exact values.

    % POISSON, because fixed time interval
    
    lambda = 10;  % 1/6min => 10/60min = 10/h
    
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    X = zeros(1, N);
    for i = 1 : N
        % poisson
        U = rand;
        X(i) = 0;
        while U >= exp(-lambda)
            U = U * rand;
            X(i) = X(i) + 1;
        end
    end

    % POISSON is a discrete distribution, therefore P(X>=5)==1-P(X<4).

    % Application/Comparison
    fprintf('simulated probab. P(X >= 5) = %1.5f\n', mean(X>=5))
    fprintf('true probab. 1 - P(X < 4) = %1.5f\n', 1 - poisscdf(4, lambda))
    fprintf('error = %e\n\n', abs(1 - poisscdf(4, lambda) - mean(X>=5)))
    
    fprintf('simulated mean E(X) = %5.5f\n', mean(X))
    fprintf('true mean E(X) = %5.5f\n', lambda)
    fprintf('error = %e\n\n', abs(lambda - mean(X)))
end