function [beta, e, Q_hat] = kalman_filter(y, x, delta, R)
% KALMAN_FILTER Estimates time-varying hedge ratio for statistical arbitrage pairs trading.
%
% Inputs:
%   y     - Dependent asset price series (column vector)
%   x     - Independent asset price series (column vector)
%   delta - Transition variance parameter (noise covariance for state vector)
%   R     - Measurement noise variance
%
% Outputs:
%   beta  - Estimated time-varying hedge ratio sequence
%   e     - Cointegration residual errors
%   Q_hat - Filter covariance estimate

    N = length(y);
    beta = zeros(N, 1);
    e = zeros(N, 1);
    
    % Initialize state space variables
    x_state = [0; 0]; % [beta; intercept] -> simplified for slope-only or dynamic slope
    P = zeros(2, 2);
    R_var = R;
    W = delta * eye(2);
    
    % Initialize filter states
    beta_est = 0;
    P_est = 1.0;
    
    for t = 1:N
        % Prediction step
        beta_pred = beta_est;
        P_pred = P_est + delta;
        
        % Measurement update step
        y_pred = x(t) * beta_pred;
        e_t = y(t) - y_pred;
        
        S = x(t)^2 * P_pred + R_var;
        K = (P_pred * x(t)) / S;
        
        beta_est = beta_pred + K * e_t;
        P_est = (1 - K * x(t)) * P_pred;
        
        beta(t) = beta_est;
        e(t) = e_t;
    end
end
