function zscore = compute_zscore(residuals, window)
% COMPUTE_ZSCORE Computes rolling z-score of cointegration residuals for mean-reversion signals.
%
% Inputs:
%   residuals - Cointegration residual error series
%   window    - Rolling window size for moving average and standard deviation
%
% Outputs:
%   zscore    - Standardized z-score vector

    N = length(residuals);
    zscore = zeros(N, 1);
    
    for t = window:N
        window_data = residuals(t - window + 1 : t);
        mu = mean(window_data);
        sigma = std(window_data);
        
        if sigma > 1e-8
            zscore(t) = (residuals(t) - mu) / sigma;
        else
            zscore(t) = 0;
        end
    end
end
