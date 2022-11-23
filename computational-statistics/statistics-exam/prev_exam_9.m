function prev_exam_9()
    % Computer shutdowns are rare events that occur, on average, at the
    % rate of 3 per year. Conduct a Monte Carlo study to estimate:
    % a) the probability that it takes at least 5 months until the next
    % computer shutdown;
    % b) the average time (in months) between computer shutdowns.

    % EXPONENTIAL, because time between rare events

    lambda = 1/4; % 3 per year = 1 every 4 months waiting time between 
    % poisson events has exponential distribution, thus we will generate an
    % exponential random variable with frequency 1/4 months.
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    Y = zeros(1, N);
    for i = 1 : N
        Y(i) = -1 / lambda * log(rand);
    end
    
    
    fprintf('a) P(Y >= 5) = %1.5f\n', 1-mean(Y<5))
    fprintf('a) but with 1 - expcdf(5,4) = %1.5f\n', 1 - expcdf(5,4))
    fprintf('b) E(Y) = %1.5f\n', mean(Y))
    fprintf('b) but with 1/lambda = %1.5f\n', 1/lambda)
end