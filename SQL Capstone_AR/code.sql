/* Learn SQL from Scratch - Capstone Project - Archana Ram | 08/19/18*/

/* # of CoolTShirts Campaigns*/
SELECT COUNT(DISTINCT utm_campaign) 
AS 'Total Campaigns'
FROM page_visits;


/* # of CTS Sources */
SELECT COUNT(DISTINCT utm_source) 
AS 'Total Sources' 
FROM page_visits;


/*Campaigns to Sources relationship*/
SELECT DISTINCT utm_campaign, 
utm_source
FROM page_visits;


/* CTS WebPages*/
SELECT DISTINCT page_name AS 'CTS webpages'
FROM page_visits;


/* First touch Campaigns*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS 'first_touch_at'
    FROM page_visits
    GROUP BY 1),
ft_attr AS(
  SELECT ft.user_id, 
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_campaign AS 'Campaign', 
      /* ft_attr.utm_source AS 'Source', */
       COUNT(*) AS 'Total First Touches'
  FROM ft_attr
  GROUP BY 1
  ORDER BY 2 ASC;


/* Last touch Campaigns*/
WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY 1),
lt_attr AS(
  SELECT lt.user_id, 
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS 'Campaign', 
      /* lt_attr.utm_source AS 'Source', */
       COUNT(*) AS 'Total Last Touches'
  FROM lt_attr
  GROUP BY 1
  ORDER BY 2 ASC;


/* Visitors who made a purchase query 1*/
SELECT page_name AS 'Page',
       COUNT(DISTINCT user_id) AS 'Total Visitors'
FROM page_visits 
WHERE page_name = '4 - purchase';

/* Visitors who made a purchase query 2*/
SELECT page_name AS 'Page',
       COUNT(DISTINCT user_id) AS 'Total Visitors'
FROM page_visits 
GROUP BY 1
HAVING page_name LIKE '%purchase%';


/* Last touches on purchase page each campaign responsible for*/
WITH last_touch_purchase AS (
    SELECT user_id,
          MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY 1),
lt_attr AS(
  SELECT lt.user_id, 
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch_purchase lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS 'Campaign', 
      /* lt_attr.utm_source AS 'Source', */
       COUNT(*) AS 'Last Touch At Purchase'
  FROM lt_attr
  GROUP BY 1
  ORDER BY 2 ASC;


/*user journey through the pages*/
SELECT page_name AS 'Page', 
      COUNT(*) AS 'Visits per page'
FROM page_visits
GROUP BY 1;
