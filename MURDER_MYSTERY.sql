select * from [dbo].[crime_scene_report]
select * from [dbo].[drivers_license] 
select * from [dbo].[facebook_event_checkin]
select * from [dbo].[get_fit_now_check_in]
select * from [dbo].[get_fit_now_member]
select * from [dbo].[income]
select * from [dbo].[interview]
select * from [dbo].[person]


select * from [dbo].[crime_scene_report] where city = 'SQL City' 

--I have taken below Murden incidense to find the villian

/*
Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave"
Got our crime scene report, as per the report there are 2 witnesses. Let's, look for them.
*/


--checking personal details of both the witnesses
SELECT *
FROM person
WHERE address_street_name = "Northwestern Dr"
ORDER BY address_number desc

/*
id	name	license_id	address_number	address_street_name	ssn
0	14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949
*/

SELECT *
FROM person
WHERE name like '%Annabel%' AND address_street_name = "Franklin Ave";

/*
id	name	license_id	address_number	address_street_name	ssn
0	16371	Annabel Miller	490173	103	Franklin Ave	318771143
*/

--lets view the interview of both the witnesses taken after the murder.
SELECT *
FROM interview
WHERE person_id = 14887 OR person_id = 16371;

/*
	person_id	transcript
0	14887	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
1	16371	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

So, we got 2 clues-

Killer is a man and a member of the gym with a status of gold and having a membership no. starting with 48Z and left in a car with a no. plate of H42W
He was working out in the gym on 9th of Jan
*/

SELECT *
FROM get_fit_now_check_in 
WHERE membership_id like "%48Z%" AND check_in_date = 20180109 
order by check_in_date;

/*
membership_id	check_in_date	check_in_time	check_out_time
0	48Z7A	20180109	1600	1730
1	48Z55	20180109	1530	1700
*/
--Two member's found and their membership id

--now, let's check the car details by the above details
SELECT *
FROM drivers_license
WHERE plate_number like "%H42W%";

--Two male with a plate no. containg H42W
/*
id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
0	183779	21	65	blue	blonde	female	H42W0X	Toyota	Prius
1	423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS
2	664760	21	71	black	black	male	4H42WR	Nissan	Altima
*/

SELECT *
FROM person
WHERE license_id = "423327" OR license_id = "664760";

/*

id	name	license_id	address_number	address_street_name	ssn
0	51739	Tushar Chandra	664760	312	Phi St	137882671
1	67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279
*/

--lets check which of this two are a member of the gym?
SELECT *
FROM get_fit_now_member
WHERE person_id = "51739" OR person_id = "67318";

/*
id	person_id	name	membership_start_date	membership_status
0	48Z55	67318	Jeremy Bowers	20160101	gold
*/

/*
Finally, found the murderer - Jeremy Bowers. Both the membership id and status also matches as per the information we found earlier.
Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime

*/
--#There's more to this, reading the transcript of the murderer
SELECT *
FROM interview
WHERE person_id = 67318;
/*

person_id	transcript
0	67318	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.\n

So, the real villain is a woman with a Tesla car and red hair. Using the above clues let find out who's the mastermind behind this murder.

*/

SELECT *
FROM drivers_license
WHERE car_make = "Tesla" AND car_model = "Model S" AND 
gender = "female" AND hair_color = "red";

/*
	id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
0	202298	68	66	green	red	female	500123	Tesla	Model S
1	291182	65	66	blue	red	female	08CM64	Tesla	Model S
2	918773	48	65	black	red	female	917UU3	Tesla	Model S

Three woman with Tesla Model S and red hair color
*/

--personal details of the above three woman are:
SELECT *
FROM person
WHERE license_id = "202298" OR license_id = "291182" OR license_id = "918773";

/*
id	name	license_id	address_number	address_street_name	ssn
0	78881	Red Korb	918773	107	Camerata Dr	961388910
1	90700	Regina George	291182	332	Maple Ave	337169072
2	99716	Miranda Priestly	202298	1883	Golden Ave	987756388
*/

--checking the event SQL symphony concert
SELECT person_id, count(*), event_name
FROM facebook_event_checkin 
GROUP BY person_id
having count(*) = 3 AND event_name = "SQL Symphony Concert" AND date like "%201712%";

/*
	person_id	count(*)	event_name
0	24556	3	SQL Symphony Concert
1	99716	3	SQL Symphony Concert

Finally, found the mastermind/real villian of this whole mystry - Miranda Priestly

*/











