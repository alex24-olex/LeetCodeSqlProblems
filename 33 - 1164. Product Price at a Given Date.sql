-- 33 - 1164. Product Price at a Given Date

-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key (combination of columns with unique values) of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
 

-- Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+
-- Output: 
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+



WITH a as (
    select product_id,
           new_price,
           ROW_NUMBER() over(partition by product_id order by change_date desc) as rk 
    from Products
    where change_date<='2019-08-16'
),
-- over here you need filter out the data as b because if you add the condition after left join then 
-- it will not return the id of 3 as there is no row number assign to it. Row number is assign to the values which date <='2019-08-16' so need to create data before the left join then the null value can come in
b as (
    select product_id,new_price from a where rk=1
)
select distinct p.product_id,ifnull(b.new_price,10) as price  from Products p
left join b using(product_id)
