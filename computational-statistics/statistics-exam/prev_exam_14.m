function prev_exam_14()
    % Messages (rare events) arrive at an electronic message center at
    % random times, 1 message every 75 seconds. Conduct a Monte Carlo study
    % to estimate:
    % a) the probability that it takes at least 2 minutes until the next
    % message arrives;
    % b) the average time (in minutes) between message arrivals.

    % EXPONENTIAL, because time between rare events

    % LAMBDA IS THE FREQUENCY (1 every x time units)
    lambda = 4/5; % 1 every 75 secs -> 4 every 5 minutes, (lambad=1/1.25)
    % thus 1 every 1.25 minutes -> 1.25 minutes is the waiting time between 
    % poisson events, that follows an exponential distribution, thus we 
    % will generate anexponential random variable considering lambda.
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    Y = zeros(1, N);
    for i = 1 : N
        Y(i) = -1 / lambda * log(rand);
    end
    
    
    fprintf('a) P(Y >= 2) = %1.5f\n', 1-mean(Y<2)) % should give around 1 - expcdf(2, 5/4)
    fprintf('a) but with 1 - expcdf(2, 5/4) = %1.5f\n', 1 - expcdf(2, 5/4))
    fprintf('b) E(Y) = %1.5f\n', mean(Y)) % should give around E(Exp(lambda)) = 1/lambda;
    fprintf('b) but with 1/lambda = %1.5f\n', 1/lambda)
end