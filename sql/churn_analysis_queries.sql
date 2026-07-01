-- 1. Total customers
SELECT
    COUNT(*) AS total_customers
FROM customer_churn;

-- 2. Churn count
SELECT
    churn,
    COUNT(*) AS customer_count
FROM customer_churn
GROUP BY churn;

-- 3. Churn rate
SELECT
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM customer_churn;

-- 4. Churn by contract type
SELECT
    contract_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM customer_churn
GROUP BY contract_type
ORDER BY churn_rate_percent DESC;

-- 5. Churn by payment method
SELECT
    payment_method,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY payment_method
ORDER BY churned_customers DESC;

-- 6. Average monthly charges by churn
SELECT
    churn,
    ROUND(AVG(monthly_charges), 2) AS average_monthly_charges
FROM customer_churn
GROUP BY churn;

-- 7. Revenue at risk from churned customers
SELECT
    SUM(monthly_charges) AS monthly_revenue_at_risk,
    SUM(total_charges) AS total_revenue_lost
FROM customer_churn
WHERE churn = 'Yes';

-- 8. Churn by senior citizen status
SELECT
    senior_citizen,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY senior_citizen;

-- 9. Churn by tenure group
SELECT
    CASE
        WHEN tenure_months <= 6 THEN '0-6 months'
        WHEN tenure_months <= 12 THEN '7-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY tenure_group
ORDER BY tenure_group;

-- 10. High-risk customers
SELECT
    customer_id,
    contract_type,
    payment_method,
    tenure_months,
    monthly_charges,
    churn
FROM customer_churn
WHERE contract_type = 'Month-to-month'
  AND payment_method = 'Electronic check'
  AND monthly_charges >= 75;
