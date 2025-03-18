                                                          # NETFLIX PROJECT:-

-- 1. Using the Viewing History table, identify the top 3 most-watched movies based on average viewing hours.
		
        select c.TitleName as movie,round(avg(v.Runtime),2) as viewing_hours from viewinghistory v 
        join content c on
        c.ContentID=v.ContentID
        where Category = "movie"
        group by c.TitleName
        order by round(avg(v.Runtime),2) desc
        limit 3;
	
-- 2. Partition the viewing hours by category and genre to find the top genre in each category. Use the rank function to rank genres within each category.
  
  select Genre,Category,VIEWING_HOUR FROM 
(SELECT C.Genre,C.Category,AVG(V.Runtime) AS VIEWING_HOUR,
RANK() OVER (PARTITION BY C.Category ORDER BY AVG(V.Runtime)DESC) AS GENRE_RANK
FROM viewinghistory V JOIN content C ON V.ContentID = C.ContentID
group by C.Category,C.Genre) AS GENRE_RANK
WHERE GENRE_RANK = 1;

-- 3. Determine the number of subscriptions for each plan. Display Plan ID, Plan Name and Subscriber count in descending order of Subscriber count.
		
        select  p.PlanID,p.PlanName,count(s.PlanID)as subscriber_count from plans p 
        join  subscribes s on 
        s.PlanID=p.PlanID
        group by p.PlanID
        order by subscriber_count desc;

-- 4. Which device type is most commonly used to access Netflix content? Provide the Device Type and count of accesses.
		
         SELECT DeviceType,COUNT(*)AS USED_TIME FROM devices
         group by DeviceType
         order by USED_TIME DESC
         LIMIT 1 ;
        
-- 5. Compare the viewing trends of movies versus TV shows. What is the average viewing time for movies and TV shows separately?
		
       select c.Category,round(avg(v.Runtime),2)as avg_time from content c 
       join viewinghistory v on c.ContentID = v.ContentID
       group by c.Category;
      
-- 6. Identify the most preferred language by customers. Provide the number of customers, and language.
		
        select (l.Language) as language_,count(c.CUSTID) as no_of_customers
		from customers c join 
		customerslanguagepreferred l on c.CUSTID=l.CustID
		group by language_
		order by no_of_customers desc
		limit 1;

-- 7. How many customers have adult accounts versus child accounts? Provide the count for each type.
        
        select "adult" as account_type,count(*) from adultacc
        
        union all 
        
        select "child" as account_type,count(*) from childacc;
	
        
-- 8. Determine the average number of profiles created per customer account.
		
        SELECT ROUND(AVG(no_of_profiles),0)AS AVG_PROFILE_PER_CUSTOMER FROM 
				(select c.CUSTID,count(p.ProfileID) as no_of_profiles from customers c 
				join profiles p 
				on c.CUSTID=p.CustID 
				group by c.CUSTID) AS AVG_;
       
        
-- 9. Identify the content that has the lowest average viewing time per user. Provide the titles and their average viewing time.
		
        select c.TitleName, round(avg(v.Runtime),0) as avg_view_time from content c 
        join viewinghistory v on v.ContentID = c.ContentID
        group by c.TitleName
        order by avg_view_time asc
        limit 1;
        
					
-- 10. Determine the count for each content type.
		
        select Genre,Category, count(*)as count_ from content
        group by Genre,Category
        order by Genre,Category ;


-- 11. Compare the number of customers that have unlimited access and who do not.

     SELECT UnlimitedAccess,COUNT(*)AS CUSTOMER_COUNT FROM content C 
     JOIN viewinghistory V ON V.ContentID = C.ContentID
     JOIN profiles P ON P.ProfileID = V.ProfileID
     group by UnlimitedAccess;
	
-- 12. Find Average monthly price for plans with Content Access as "unlimited".
		
        select *,
        (select avg(MonthlyPrice) from plans
        where ContentAccess = "unlimited") as avg_monthly_price
        from plans
        where ContentAccess = "unlimited";



-- 13. List all the customers who have taken the plan for till 2028 and later. Display CustomerID, Customer name and Expiration Date of the plan, ordered by Expiration Date in descending order first, and then by Customer Name.
		
        select c.CUSTID, concat(c.FNAME,' ',c.LNAME)as full_name , pm.ExpirationDate from paymentmethod pm 
        join customers c on
        c.CUSTID = pm.CUSTID
        where year(ExpirationDate) >= 2028
        order by ExpirationDate , full_name;

-- 14. Display Average Revenue generated from each city. Rank city based on average revenue.
        
        select pm.City,avg(ph.PaymentAmount) as avg_revenue, DENSE_RANK() OVER (ORDER BY avg(ph.PaymentAmount) DESC) AS RANKING
        FROM paymenthistory ph join paymentmethod pm on 
        pm.CardID = ph.CardID
        group by pm.City
        order by avg_revenue DESC;

-- 15. Display most frequently viewed genre among adults for each category.
	
		select c.Genre,count(c.Genre) as times_of_viewed from content c 
        join viewinghistory v on v.ContentID= c.ContentID
        join profiles p on p.ProfileID = v.ProfileID
        join adultacc a on a.ProfileID=p.ProfileID
        group by Genre
        order by times_of_viewed desc;