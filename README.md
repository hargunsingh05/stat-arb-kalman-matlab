# Statistical Arbitrage & Dynamic Pairs Trading with Kalman Filter

An advanced statistical arbitrage framework implemented in MATLAB for pairs trading, utilizing a dynamic **Kalman Filter** to estimate time-varying hedge ratios and generate real-time cointegration residual z-score trading signals.

---

## Technical Features

* **Dynamic Hedge Ratio Estimation:** Replaces static Ordinary Least Squares (OLS) regression with a recursive state-space Kalman Filter to adapt to structural breaks in cointegrated asset pairs.
* **State-Space Modeling:** Formulates the cointegration relationship as a hidden state estimation problem:
  * *Observation Equation:* $y_t = \beta_t x_t + \epsilon_t$
  * *State Equation:* $\beta_t = \beta_{t-1} + w_t$
* **Z-Score Signal Generation:** Normalizes residuals dynamically using rolling moving averages and standard deviations to trigger mean-reversion entries and exits.
* **Performance Analytics:** Computes annualized Sharpe ratio, maximum drawdown, total return, and trade-by-trade hit ratios.

---

## Directory Structure

```text
├── data/
│   ├── asset_prices.mat      # Historical end-of-day price series for cointegrated pairs
├── src/
│   ├── kalman_filter.m       # Core recursive state-space estimation algorithm
│   ├── compute_zscore.m      # Spread normalization and z-score thresholding
│   └── backtest_strategy.m   # PnL simulation, execution rules, and performance metrics
├── README.md                 # System documentation
└── LICENSE                   # MIT License
