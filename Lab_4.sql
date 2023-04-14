--3)Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

select cus_gender, count(1) from customer c, 'order' o where c.cus_id = o.cus_id and o.ord_amount >3000 group by cus_gender;


--4)Display all the orders along with product name ordered by a customer having Customer_Id=2
select o.* , p.pro_name from 'order' o, product p, supplier_pricing sp where o.pricing_id = sp.pricing_id and sp.pro_id = p.pro_id and o.cus_id = 2;

--5)Display the Supplier details who can supply more than one product.
select s.* from supplier s where supp_id in (select sp.supp_id from supplier_pricing sp group by sp.supp_id having count(sp.supp_id) > 1);


--6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product.
select cat_id,cat_name,pro_name,supp_price from (select c.cat_id,c.cat_name,p.pro_name,sp.supp_price,dense_rank() over (partition by c.cat_id 
													order by sp.supp_price) rnk
from supplier_pricing sp,product p,category c
where sp.pro_id = p.pro_id and p.cat_id = c.cat_id group by
c.cat_id,c.cat_name,p.pro_name,sp.supp_price)
where rnk = 1;

--7)	Display the Id and Name of the Product ordered after “2021-10-05”.
select p.pro_id,p.pro_name from product p, 'order' o, supplier_pricing sp
where p.pro_id = sp.pro_id and sp.pricing_id = o.pricing_id
and o.ord_date > to_date('2021-10-05','yyyy-mm-dd');

--8)	Display customer name and gender whose names start or end with character 'A'.
select cus_name,cus_gender from customer where cus_name like '%A' or cus_name like 'A';


--9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
create or replace procedure proc_display_items
as
begin
for i in (select s.supp_id , s.supp_name, r.rat_ratstars,
case
when r.rat_ratstars = 5 then 'Excellent Service'
when r.rat_ratstars between 4 and 5 then 'Good Service'
when r.rat_ratstars between 2 and 4 then 'Average servcice'
else 'Poor Service'
end service_type
from supplier s, supplier_pricing sp, 'order' o, rating r
where s.supp_id = sp.supp_id and sp.pricing_id = o.pricing_id and o.ord_id =
r.ord_id)
loop

dbms_output.put_line('supplier id: ' || i.supp_id|| ' suplier name: '||i.supp_name||'Rating:
'||i.rat_ratstars||'Type of service: '||i.service_type);
end loop;
end;
 
