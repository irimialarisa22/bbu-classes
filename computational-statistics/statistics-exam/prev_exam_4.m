function prev_exam_4()
    % Printing jobs arriving at a printer are rare events that occur at the
    % rate of 3 per minute. Conduct a Monte Carlo study to estimate:
    % a) the probability that at least 25 seconds pass between printing two
    % consecutive documents;
    % b) the expected time (in seconds) between printing two consecutive
    % documents.

    % EXPONENTIAL, because time between rare events

    lambda = 1/20; % 3 per minute 3/60 seconds = 1/20 seconds waiting time 
    % between poisson events has exponential distribution, thus we will
    % generate an exponential random variable with frequency 1/20 seconds.
    err = 1e-3;
    alpha = 0.01;
    N = ceil(0.25 * (norminv(alpha / 2, 0, 1) / err) ^ 2);
    Y = zeros(1, N);
    for i = 1 : N
        Y(i) = -1 / lambda * log(rand);
    end
    
    fprintf('a) P(Y >= 25) = %1.5f\n', mean(Y>=25)) % should give around 1 - expcdf(25,20)
    fprintf('a) but with 1 - expcdf(25,20) = %1.5f\n', 1 - expcdf(25,20))
    fprintf('b) E(Y) = %1.5f\n', mean(Y)) % should give around 1/lambda
    fprintf('b) but with 1/lambda = %1.5f\n', 1/lambda)
end