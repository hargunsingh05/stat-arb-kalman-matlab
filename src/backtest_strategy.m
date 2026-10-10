% BACKTEST_STRATEGY Main execution script for Kalman Filter statistical arbitrage pairs trading.

clear; clc; close all;

% 1. Generate Synthetic Cointegrated Asset Prices for Demonstration
rng(42); % Reproducible seed
N = 1000;
dt = 1/252;
eps_price = randn(N, 1);
x = cumsum(randn(N, 1)) + 100; % Asset X (e.g., Stock A)
true_beta = 1.2;
y = true_beta * x + cumsum(randn(N, 1)) * 0.5 + 10; % Asset Y (e.g., Stock B)

% 2. Run Kalman Filter for Dynamic Hedge Ratio
delta = 1e-5;
R = 1e-3;
[beta_est, residuals, ~] = kalman_filter(y, x, delta, R);

% 3. Compute Rolling Z-Score
window = 30;
zscores = compute_zscore(residuals, window);

% 4. Backtest Trading Strategy Rules
entry_threshold = 1.5;
exit_threshold = 0.5;

positions = zeros(N, 1);
for t = window+1:N
    if zscores(t) > entry_threshold
        positions(t) = -1; % Short spread (Short Y, Long X)
    elseif zscores(t) < -entry_threshold
        positions(t) = 1;  % Long spread (Long Y, Short X)
    elseif abs(zscores(t)) < exit_threshold
        positions(t) = 0;  % Liquidate position
    else
        positions(t) = positions(t-1); % Hold position
    end
end

% 5. Performance Metrics
spread_returns = diff(residuals);
strategy_returns = positions(1:end-1) .* spread_returns;
cumulative_pnl = cumsum(strategy_returns);
sharpe_ratio = sqrt(252) * mean(strategy_returns) / std(strategy_returns);

fprintf('=========================================================\n');
fprintf(' STATISTICAL ARBITRAGE BACKTEST RESULTS                  \n');
fprintf('=========================================================\n');
fprintf(' Total Observations : %d\n', N);
fprintf(' Annualized Sharpe  : %.4f\n', sharpe_ratio);
fprintf(' Final Cumulative PnL: %.4f\n', cumulative_pnl(end));
fprintf('=========================================================\n');

% Plotting results
figure('Color', 'white');
subplot(2,1,1);
plot(zscores, 'LineWidth', 1.5);
hold on;
yline(entry_threshold, '--r', 'Upper Entry');
yline(-entry_threshold, '--g', 'Lower Entry');
yline(0, '-k');
title('Kalman Filter Cointegration Residual Z-Score');
grid on;

subplot(2,1,2);
plot(cumulative_pnl, 'LineWidth', 1.5, 'Color', 'b');
title('Strategy Cumulative PnL');
xlabel('Time Steps');
ylabel('Returns');
grid on;
