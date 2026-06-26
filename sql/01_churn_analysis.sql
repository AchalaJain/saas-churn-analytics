-- Overall Churn Rate
select count(*) as total_customers,
  sum(Churn_Flag) as churned,
  round(100.0*sum(Churn_Flag)/count(*),1) as churn_rate_pct,
  round(sum(Revenue_at_risk),0) as monthly_rev_at_risk
  from customers

-- Churn by Contract Type
select Contract, count(*) as total_customers,
  sum(Churn_Flag) as churned,
  round(100.0*sum(Churn_Flag)/count(*),1) as churn_rate_pct,
  round(sum(Revenue_at_risk),0) as monthly_rev_at_risk
  from customers
  group by Contract
  order by churn_rate_pct desc

-- Churn Rate by Tenure Segment
select case when tenure <= 12 then '1-12 months'
              when tenure <= 24 then '13-24 months'
              when tenure <= 48 then '25-48 months'
              else '48+ months' end as tenure_segment,
  count(*) as total_customers,
  sum(Churn_Flag) as churned,
  round(100.0*sum(Churn_Flag)/count(*),1) as churn_rate_pct,
  round(avg(MonthlyCharges),0) as avg_monthly_charges
  from customers
  group by tenure_segment
  order by churn_rate_pct desc

-- Revenue Profile: Churned vs Retained
select Churn,
  count(*) as total_customers,
  round(avg(MonthlyCharges),0) as avg_monthly_charges,
  round(avg(TotalCharges),0) as avg_total_charges,
  round(sum(MonthlyCharges),0) as total_monthly_revenue
  from customers
  group by Churn

-- Churn by Internet Service
SELECT
    InternetService,
    COUNT(*)                                          AS total,
    SUM(Churn_Flag)                                   AS churned,
    ROUND(100.0 * SUM(Churn_Flag) / COUNT(*), 1)     AS churn_rate_pct,
    ROUND(SUM(Revenue_At_Risk), 0)                    AS monthly_rev_at_risk
FROM customers
GROUP BY InternetService
ORDER BY churn_rate_pct DESC

-- Top High-Risk Segments
SELECT
    Contract,
    InternetService,
    PaymentMethod,
    COUNT(*)                                          AS total,
    SUM(Churn_Flag)                                   AS churned,
    ROUND(100.0 * SUM(Churn_Flag) / COUNT(*), 1)     AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 0)                     AS avg_monthly_rev,
    ROUND(SUM(Revenue_At_Risk), 0)                    AS segment_rev_at_risk
FROM customers
GROUP BY Contract, InternetService, PaymentMethod
HAVING total > 30
ORDER BY churn_rate_pct DESC
LIMIT 10

-- Monthly Revenue at Risk
SELECT
    ROUND(SUM(MonthlyCharges), 0)                              AS total_mrr,
    ROUND(SUM(Revenue_At_Risk), 0)                             AS revenue_at_risk,
    ROUND(100.0 * SUM(Revenue_At_Risk) / SUM(MonthlyCharges), 1) AS pct_mrr_at_risk
FROM customers

-- Retention Rate by Tenure Cohort
SELECT
    CASE
        WHEN tenure <= 6  THEN '0–6 months'
        WHEN tenure <= 12 THEN '7–12 months'
        WHEN tenure <= 24 THEN '13–24 months'
        WHEN tenure <= 36 THEN '25–36 months'
        ELSE '36+ months'
    END                                               AS cohort,
    COUNT(*)                                          AS total,
    SUM(Churn_Flag)                                   AS churned,
    ROUND(100.0 * (COUNT(*) - SUM(Churn_Flag)) / COUNT(*), 1) AS retention_rate_pct,
    ROUND(AVG(MonthlyCharges), 0)                     AS avg_monthly_rev
FROM customers
GROUP BY cohort
ORDER BY MIN(tenure)

