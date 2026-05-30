CREATE TABLE customer_data (

    customer_id INT,
    age INT,
    gender VARCHAR(20),
    item_purchased VARCHAR(100),
    category VARCHAR(100),
    purchase_amount_usd NUMERIC(10,2),
    location VARCHAR(100),
    size VARCHAR(20),
    color VARCHAR(50),
    season VARCHAR(20),
    review_rating NUMERIC(2,1),
    subscription_status VARCHAR(10),
    shipping_type VARCHAR(50),
    discount_applied VARCHAR(10),
    promo_code_used VARCHAR(10),
    previous_purchases INT,
    payment_method VARCHAR(50),
    frequency_of_purchases VARCHAR(50),

    -- Engineered Features
    purchase_frequency_annual INT,
    purchase_count INT,
    repeat_purchase_ratio NUMERIC(10,4),

    promo_used_flag INT,
    organic_customer_flag INT,
    discount_dependency_score INT,
    low_promo_dependency_flag INT,

    satisfaction_flag INT,

    subscription_flag INT,
    engagement_score NUMERIC(10,2),

    purchase_count_percentile NUMERIC(10,4),
    frequency_percentile NUMERIC(10,4),

    behavioral_loyalty_score NUMERIC(10,2),
    behavioral_loyalty_flag INT,

    estimated_total_spend NUMERIC(12,2),

    spend_percentile NUMERIC(10,4),
    aov_percentile NUMERIC(10,4),
    rating_percentile NUMERIC(10,4),

    value_quality_loyalty_score NUMERIC(10,2),
    value_quality_loyalty_flag INT,

    age_group VARCHAR(20),
    spending_tier VARCHAR(20),
    loyalty_tier VARCHAR(20),

    customer_archetype VARCHAR(50),

    ideal_customer_flag INT
);

-- Total customers
SELECT COUNT(*) AS total_customers
FROM customer_data;

-- Distinct locations
SELECT COUNT(DISTINCT location) AS total_locations
FROM customer_data;

-- Distinct categories
SELECT DISTINCT category
FROM customer_data;

-- Dataset preview
SELECT *
FROM customer_data
LIMIT 10;


-- Customer archetype distribution
SELECT customer_archetype,
       COUNT(*) AS total_customers,
       ROUND(
           COUNT(*) * 100.0 /
           SUM(COUNT(*)) OVER (),
           2
       ) AS percentage
FROM customer_data
GROUP BY customer_archetype
ORDER BY total_customers DESC;

-- Loyalty tier distribution
SELECT loyalty_tier,
       COUNT(*) AS customers
FROM customer_data
GROUP BY loyalty_tier
ORDER BY customers DESC;

-- Spending tier distribution
SELECT spending_tier,
       COUNT(*) AS customers
FROM customer_data
GROUP BY spending_tier
ORDER BY customers DESC;


SELECT spending_tier,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(purchase_frequency_annual),2)
           AS avg_frequency,

       ROUND(AVG(review_rating),2)
           AS avg_rating,

       ROUND(AVG(repeat_purchase_ratio),2)
           AS avg_repeat_ratio,

       ROUND(AVG(subscription_flag) * 100,2)
           AS subscription_percentage

FROM customer_data

GROUP BY spending_tier

ORDER BY avg_spend DESC;


-- Average loyalty score by archetype
SELECT customer_archetype,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty_score,

       ROUND(AVG(value_quality_loyalty_score),2)
           AS avg_value_score,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY customer_archetype

ORDER BY avg_loyalty_score DESC;

-- Loyal vs non-loyal customers
SELECT behavioral_loyalty_flag,

       COUNT(*) AS customers,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(review_rating),2)
           AS avg_rating

FROM customer_data

GROUP BY behavioral_loyalty_flag;

-- Elite customers
SELECT COUNT(*) AS elite_customers
FROM customer_data
WHERE loyalty_tier = 'Elite';


-- Profiles with strongest repeat behavior
SELECT customer_archetype,

       ROUND(AVG(repeat_purchase_ratio),2)
           AS avg_repeat_ratio,

       ROUND(AVG(previous_purchases),2)
           AS avg_previous_purchases,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY customer_archetype

ORDER BY avg_repeat_ratio DESC;

-- Repeat behavior by age group
SELECT age_group,

       ROUND(AVG(repeat_purchase_ratio),2)
           AS avg_repeat_ratio,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty

FROM customer_data

GROUP BY age_group

ORDER BY avg_repeat_ratio DESC;

-- Promo users vs organic customers
SELECT promo_used_flag,

       COUNT(*) AS customers,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY promo_used_flag;

-- Categories most dependent on discounts
SELECT category,

       ROUND(AVG(promo_used_flag) * 100,2)
           AS promo_dependency_percentage

FROM customer_data

GROUP BY category

ORDER BY promo_dependency_percentage DESC;

-- True loyalists
SELECT COUNT(*) AS true_loyalists
FROM customer_data
WHERE customer_archetype = 'True Loyalist';

-- Discount hunters
SELECT COUNT(*) AS discount_hunters
FROM customer_data
WHERE customer_archetype = 'Discount Hunter';


-- Season vs customer tenure
SELECT season,

       ROUND(AVG(previous_purchases),2)
           AS avg_previous_purchases,

       ROUND(AVG(purchase_count),2)
           AS avg_purchase_count,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty

FROM customer_data

GROUP BY season

ORDER BY avg_previous_purchases DESC;

-- Category vs customer tenure
SELECT category,

       ROUND(AVG(previous_purchases),2)
           AS avg_previous_purchases,

       ROUND(AVG(purchase_count),2)
           AS avg_purchase_count,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY category

ORDER BY avg_previous_purchases DESC;


-- Age group analysis
SELECT age_group,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY age_group

ORDER BY avg_spend DESC;

-- Gender analysis
SELECT gender,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY gender;

-- Subscription impact
SELECT subscription_flag,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(review_rating),2)
           AS avg_rating

FROM customer_data

GROUP BY subscription_flag;


-- Category performance
SELECT category,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty

FROM customer_data

GROUP BY category

ORDER BY avg_spend DESC;

-- Most purchased items
SELECT item_purchased,

       COUNT(*) AS purchases

FROM customer_data

GROUP BY item_purchased

ORDER BY purchases DESC

LIMIT 10;

-- Seasonal trends
SELECT season,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty

FROM customer_data

GROUP BY season;


-- Geography organic demand analysis
SELECT location,

       ROUND(AVG(promo_used_flag) * 100,2)
           AS promo_dependency_percentage,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(review_rating),2)
           AS avg_rating

FROM customer_data

GROUP BY location

ORDER BY promo_dependency_percentage ASC;

-- Best organic markets
SELECT location,

       COUNT(*) AS customers,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend,

       ROUND(AVG(behavioral_loyalty_score),2)
           AS avg_loyalty

FROM customer_data

WHERE promo_used_flag = 0

GROUP BY location

ORDER BY avg_loyalty DESC,
         avg_spend DESC;

-- Discount-driven regions
SELECT location,

       COUNT(*) AS customers,

       ROUND(AVG(promo_used_flag) * 100,2)
           AS promo_dependency,

       ROUND(AVG(estimated_total_spend),2)
           AS avg_spend

FROM customer_data

GROUP BY location

ORDER BY promo_dependency DESC;

-- Ideal customer demographics
SELECT age_group,
       gender,

       COUNT(*) AS ideal_customers

FROM customer_data

WHERE ideal_customer_flag = 1

GROUP BY age_group, gender

ORDER BY ideal_customers DESC;

-- Ideal customer product preference
SELECT category,

       COUNT(*) AS purchases

FROM customer_data

WHERE ideal_customer_flag = 1

GROUP BY category

ORDER BY purchases DESC;

-- Ideal customer payment preference
SELECT payment_method,

       COUNT(*) AS usage_count

FROM customer_data

WHERE ideal_customer_flag = 1

GROUP BY payment_method

ORDER BY usage_count DESC;


-- Customers safe for promo reduction
SELECT COUNT(*) AS customers_safe_for_promo_reduction

FROM customer_data

WHERE behavioral_loyalty_flag = 1
AND promo_used_flag = 0;

-- High-value organic customers
SELECT COUNT(*) AS high_value_organic_customers

FROM customer_data

WHERE value_quality_loyalty_flag = 1
AND promo_used_flag = 0;

-- Revenue contribution by archetype
SELECT customer_archetype,

       ROUND(SUM(estimated_total_spend),2)
           AS total_revenue

FROM customer_data

GROUP BY customer_archetype

ORDER BY total_revenue DESC;


-- Rank customers by loyalty
SELECT customer_id,

       behavioral_loyalty_score,

       RANK() OVER(
           ORDER BY behavioral_loyalty_score DESC
       ) AS loyalty_rank

FROM customer_data;

-- Top 5 highest-value customers
SELECT customer_id,

       estimated_total_spend,

       behavioral_loyalty_score

FROM customer_data

ORDER BY estimated_total_spend DESC

LIMIT 5;