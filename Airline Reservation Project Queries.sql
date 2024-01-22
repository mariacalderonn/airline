/*What are the favorite destinations of our frequent fliers?*/
SELECT a.Country, a.State, a.City, count(*) as DestinationCnt
FROM airport a
Join Itinerary i on a.AirportCode = i.ArrivalAirportCode
Join Booking b on i.Booking_BookingCode = b.BookingCode
Join User u on b.User_UserID = u.UserID
Where u.Frequentflyernumber IS NOT NULL
and i.ConnectingFlight = 0
Group By a.Country, a.State, a.City
Order By DestinationCnt desc;

/*What are the top 10 most occupied routes?*/
Select Concat(a1.Address,' to ',a2.Address) as Route, Count(*) as RouteCnt
From itinerary i 
Join airport a1 on i.DeptAirportCode = a1.AirportCode
Join airport a2 on i.ArrivalAirportCode = a2.AirportCode
Group By Route
Order By RouteCnt desc
Limit 10;

/*Number of Bookings Per Month Over the Course of the Year*/
SELECT MONTHNAME(BookingDate) AS "Booking Month", COUNT(BookingCode) AS "Number of Bookings Per Month" 
FROM booking 
GROUP BY 1, FIELD(MONTHNAME(BookingDate),'January', 'February', 'March', 'April', 'May', 'June', 
'July','August','September','October','November','December')
ORDER BY FIELD(MONTHNAME(BookingDate),'January', 'February', 'March', 'April', 'May', 'June', 
'July','August','September','October','November','December');

/*What are the ticket profits for each airline for a specific date range?*/
SELECT a.Description as AirlineDesc
,IFNULL(SUM(b.Totalcost),0)  as Profits
FROM airline a
Left Join itinerary i on a.AirlineCode = i.AirlineCode
Left Join booking b on i.Booking_BookingCode = b.BookingCode
Where DepartureDatetime BETWEEN '2023-10-01' and '2023-12-31' #Q4
Group By a.Description;

/*Busiest calendar days per category of customers*/
SELECT Concat(Month(i.DepartureDatetime),'/',Day(i.DepartureDatetime)) as MonthDay
, Case When u.Category = 'Platinum' then Count(i.ItineraryId)else 0 end as PlatinumCnt
, Case When u.Category = 'Gold' then Count(i.ItineraryId)  else 0 end as GoldCnt
, Case When u.Category = 'Silver' then Count(i.ItineraryId)else 0 end as SilverCntCnt
,Count(IFNULL(i.ItineraryId,0)) as TotalCnt
FROM itinerary i
Join booking b on i.Booking_BookingCode = b.BookingCode
Join user u on u.UserID = b.User_UserID
Group By Concat(Month(i.DepartureDatetime),'/',Day(i.DepartureDatetime)), u.Category
Order By TotalCnt desc;

/*Top 5 favorite airlines for preferred/platinum customers*/
Select a.Description as AirlineDesc, count(u.Category) as PlatinumCnt
From airline a 
Join itinerary i on a.AirlineCode = i.AirlineCode
Join booking b on i.Booking_BookingCode = b.BookingCode
Join user u on b.User_UserID = u.UserID
Where u.Category = 'Platinum'
Group By AirlineDesc
Order By PlatinumCnt desc
Limit 5;

/*Who are our non returning customers within the year to promote offers?*/
Select u.Name, u.Address, u.Email, u.Category, b.BookingDate
From user u
Left Join booking b on u.UserID = b.User_UserID and year(b.BookingDate) = year(now())
Where b.BookingDate IS NULL;

