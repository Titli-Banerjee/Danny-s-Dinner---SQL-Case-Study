# Danny-s-Dinner---SQL-Case-Study

![image](https://user-images.githubusercontent.com/16962937/196020243-9e26dafc-6952-43dc-b478-a4ab3bbeec92.png)

This is first case study out of ‘8WeekSQLChallenge’ by Danny Ma and all details for this challenge can be found at https://8weeksqlchallenge.com/case-study-1/ .

This case study is about a new restaurant ‘Danny’s Diner’ where Danny is interested to find out useful
insights about Customer visiting patterns, how much money they’ve spent ,which menu items are
their favourite and whether he should expand the existing customer loyalty program or not. Danny
has given 10 questions for this ‘Case Study to be solved using SQL with 2 bonus questions. Danny has
shared 3 datasets for this case study : sales, menu, members. All datasets exist within dannys_diner
database schema.

## Database Schema

Below is the ER diagram of the database schema

![Danny's Diner](https://user-images.githubusercontent.com/16962937/196020115-3bdfad28-ea42-4d5e-a9b3-bb7e5551d91a.png)

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny is looking for answers to the following questions:
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


## Some Insights

1. Customer A spends the maximum no of dollars at the restaurant, followed by B and C
2. Customers A and B both have ordered from the restaurants 6 times while C ordered only 3 times
3. Ramen is the most ordered item in the menu
4. Ramen is customer A and C's favourite, while B likes curry
5. Customer A was the first to take the loyalty program, hence can be considered as the most loyal customer.
