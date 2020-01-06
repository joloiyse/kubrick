---- data quality check


---delete derived columns and non relevant columns 
alter table dbo.nhs
drop column bedyear, epidur, newnhsno_check

alter table dbo.nhs drop column newnhsno_check

alter table dbo.nhs drop column endage

alter table dbo.nhs drop column spell

alter table dbo.nhs drop column mydob



-- Checking some simple data quality issues 
/*
with test as (
select
epistart, 
epiend, 
bedyear,
case
when 
datediff(dd,cast(epistart as date),cast(epiend as date)) = bedyear or bedyear is null then 'fine'
else 'error'
end 'Error'
from nhs) 

select * from test 
where Error = 'error'

---Date of birth error 

select dob from nhs 
where datediff(yy,dob,getdate()) > 100


select newnhsno from nhs where len(newnhsno) <> 10 */


--- creating lookup tables 

--  epitype look up table 

select distinct
epitype as id 
, 
case 
when epitype = 1 then 'General'
when epitype = 2 then 'Delivery'  
when epitype = 3 then 'Birth' 
when epitype = 4 then 'Formally detained or long-term psychiatric'
when epitype = 5 then 'Other delivery' 
when epitype = 6 then 'Other birth'
else 'Incorrect Entry'
end as 'Description'
into epitype 
from nhs

--- sex lookup table 

select distinct 
sex as ID
, 
case 
when sex = 1 then 'Male'
 when sex = 2 then 'Female'
 when sex = 9 then 'Not Specified'
 when sex = 0 then 'Not Known'
else 'Incorrect Entry'
end as 'Description'
into sex 
from nhs 

---Epistat look up table
select distinct 
epistat as ID
, 
case 
when epistat = 1 then 'Unfinished'
 when epistat = 3 then 'Finished'
 when epistat = 9 then 'Derived Unfinished'
else 'Incorrect Entry'
end as 'Description'
into epistat
from nhs 


---Spellbgin look up 
select distinct 
spellbgin as ID, 
case 
when spellbgin = 0 then 'Not first episode'
 when spellbgin = 1 then 'First episode of spell that began in previous year'
 when spellbgin = 2 then 'First episode of spell that started in current year'
 when spellbgin is NULL then 'Not Applicable'
else 'Incorrect Entry'
end as 'Description'
into spellbgin
from nhs 
--admincat lookup

select distinct 
 admincat as id
 ,
case 
when admincat = 01 then 'NHS' 
when admincat = 02 then 'Private'
when admincat = 03 then 'Amenity'
when admincat = 04 then 'Category II'
when admincat = 98 then 'Not applicable'
when admincat = 99 then 'Validation Error'
else 'Incorrect Entry' end as 'Description'
into admincat
from nhs 

--admincatst lookup
select distinct 
 admincatst as id
 ,
case 
when admincatst = 01 then 'NHS' 
when admincatst = 02 then 'Private'
when admincatst = 03 then 'Amenity'
when admincatst = 04 then 'Category II'
when admincatst = 98 then 'Not applicable'
when admincatst = 99 then 'Validation Error'
else 'Incorrect Entry' end as 'Description'
into admincatst
from nhs 

--category lookup
select distinct 
category  as id,
case 
when category = 10 then 'NHS patient: not formally detained'
when category = 11 then 'NHS patient: formally detained under Part II of the Mental Health Act 1983' 
when category = 12 then 'NHS patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'
when category = 13 then 'NHS patient: formally detained under part X, Mental Health Act 1983'
when category = 20 then 'Private patient: not formally detained'
when category = 21 then 'Private patient: formally detained under Part II of the Mental Health Act 1983'  
when category = 22 then 'Private patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'  
when category = 23 then 'Private patient: formally detained under part X, Mental health Act 1983'  
when category = 30 then 'Amenity patient: not formally detained'
when category = 31 then 'Amenity patient: formally detained under Part II of the Mental Health Act 1983'  
when category = 32 then 'Amenity patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'  
when category = 33 then 'Amenity patient: formally detained under part X, Mental health Act 1983'  
when category is Null then 'Other maternity event'
else 'Incorrect Entry' end as 'Description' 
into category
from nhs 

--ethnos lookup
select distinct 
ethnos as id, 
case 
when ethnos = 'A' then'British (White)'
when ethnos = 'B' then'Irish (White)' 
when ethnos = 'C' then'Any other White background' 
when ethnos = 'D' then'White and Black Caribbean (Mixed)' 
when ethnos = 'E' then'White and Black African (Mixed)' 
when ethnos = 'F' then'White and Asian (Mixed)' 
when ethnos = 'G' then'Any other Mixed background' 
when ethnos = 'H' then'Indian (Asian or Asian British)' 
when ethnos = 'J' then'Pakistani (Asian or Asian British)'
when ethnos = 'K' then'Bangladeshi (Asian or Asian British)' 
when ethnos = 'L' then'Any other Asian background' 
when ethnos = 'M' then'Caribbean (Black or Black British)' 
when ethnos = 'N' then'African (Black or Black British)' 
when ethnos = 'P' then'Any other Black background' 
when ethnos = 'R' then'Chinese (other ethnic group)' 
when ethnos = 'S' then'Any other ethnic group'
when ethnos = 'Z' then'Not stated'
when ethnos = 'X' then 'Not known (prior to 2013)'
when ethnos = '99' then 'Not known (2013 onwards)'
when ethnos = '0' then 'White'
when ethnos = '1' then'Black - Caribbean'
when ethnos = '2' then'Black - African'
when ethnos = '3' then'Black - Other' 
when ethnos = '4' then'Indian' 
when ethnos = '5' then'Pakistani' 
when ethnos = '6' then'Bangladeshi' 
when ethnos = '7' then'Chinese' 
when ethnos = '8' then'Any other ethnic group' 
when ethnos = '9' then'Not given' 
when ethnos = '99' then'Not known' 
else 'Incorrect entry'
end as 'Description'
into ethnos 
from nhs

--legalcat lookup
select distinct 
leglcat as id, 
case
when leglcat = '01' then 'Informal'
when leglcat = '02' then 'Formally detained under the Mental Health Act, Section 2'  
when leglcat = '03' then 'Formally detained under the Mental Health Act, Section 3'  
when leglcat = '04' then 'Formally detained under the Mental Health Act, Section 4'  
when leglcat = '05' then 'Formally detained under the Mental Health Act, Section 5(2)'  
when leglcat = '06' then 'Formally detained under the Mental Health Act, Section 5(4)'  
when leglcat = '07' then 'Formally detained under the Mental Health Act, Section 35'  
when leglcat = '08' then 'Formally detained under the Mental Health Act, Section 36'  
when leglcat = '09' then 'Formally detained under the Mental Health Act, Section 37 with Section 41 restrictions'  
when leglcat = '10' then 'Formally detained under the Mental Health Act, Section 37 excluding Section 37(4)'  
when leglcat = '11' then 'Formally detained under the Mental Health Act, Section 37(4)'  
when leglcat = '12' then 'Formally detained under the Mental Health Act, Section 38'  
when leglcat = '13' then 'Formally detained under the Mental Health Act, Section 44'  
when leglcat = '14' then 'Formally detained under the Mental Health Act, Section 46'  
when leglcat = '15' then 'Formally detained under the Mental Health Act, Section 47 with Section 49 restrictions'  
when leglcat = '16' then 'Formally detained under the Mental Health Act, Section 47'  
when leglcat = '17' then 'Formally detained under the Mental Health Act, Section 48 with Section 49 restrictions'  
when leglcat = '18' then 'Formally detained under the Mental Health Act, Section 48'  
when leglcat = '19' then 'Formally detained under the Mental Health Act, Section 135'  
when leglcat = '20' then 'Formally detained under the Mental Health Act, Section 136'  
when leglcat = '21' then 'Formally detained under the previous legislation (fifth schedule)'  
when leglcat = '22' then 'Formally detained under Criminal Procedure (Insanity) Act 1964 as amended by the Criminal Procedures (Insanity and Unfitness to Plead) Act 1991'  
when leglcat = '23' then 'Formally detained under other Acts'  
when leglcat = '24' then 'Supervised discharge under the Mental Health (Patients in the Community) Act 1995'  
when leglcat = '25' then 'Formally detained under the Mental Health Act, Section 45A'  
when leglcat = '26' then 'Not applicable ' 
when leglcat = '27' then 'Not known'
else 'Incorrect Entry'
end 'Description'
into leglcat
from nhs 


--admimeth lookup
select distinct
admimeth as id, 
case
when admimeth = '11' then 'Elective: Waiting list'
when admimeth = '12' then 'Elective: Booked'
when admimeth = '13' then 'Elective: Planned'
when admimeth = '21' then 'Emergency: A&E or dental casualty department of provider'  
when admimeth = '22' then 'Emergency: General Practitioner'
when admimeth = '23' then 'Emergency: Bed bureau'
when admimeth = '24' then 'Emergency: Consultant Clinic'
when admimeth = '25' then 'Emergency: Mental Health Crisis Resolution Team'
when admimeth = '2A' then 'Emergency: A&E of another provider'
when admimeth = '2B' then 'Emergency: Transfer of an admitted patient from another Hospital Provider'
when admimeth = '2C' then 'Emergency: Baby born at home as intended'
when admimeth = '2D' then 'Emergency: Other'
when admimeth = '28' then 'Emergency: Other means'
when admimeth = '31' then 'Maternity : Ante-partum'
when admimeth = '32' then 'Maternity: Post-partum'
when admimeth = '82' then 'Other: Birth of a baby in this Health Care Provider'
when admimeth = '83' then 'Other: Baby born outside the Health Care Provider'
when admimeth = '81' then 'Other: Transfer of any admitted patient from other Hospital Provider (non-emergency)'
when admimeth = '84' then 'Other: Admission by Admissions Panel of a High Security Psychiatric Hospital (non wait-list)'
when admimeth = '89' then 'Other: HSPH Admissions Waiting List of a High Security Psychiatric Hospital'
when admimeth = '98' then 'Not applicable'
when admimeth = '99' then 'Validation error' 
end as 'Description'
into admimeth 
from nhs

--- admisorc lookup
select distinct 
admisorc as id, 
case 
when admisorc = 19 then 'Usual Residence'
when admisorc = 29 then 'Temporary place of residence'
when admisorc = 30 then 'Repatriation from high security psychiatric hospital'
when admisorc = 37 then 'Penal establishment: Court'
when admisorc = 38 then 'Penal establishment: Police station'
when admisorc = 39 then 'Penal establishment: Court/Police Station/Police Custody Suite'
when admisorc = 48 then 'High security psychiatric hospital: Scotland'
when admisorc = 49 then 'NHS other hospital provider: high security psychiatric accommodation'
when admisorc = 50 then 'NHS other hospital provider: medium secure unit'
when admisorc = 51 then 'NHS other hospital provider: Ward for general patients or the younger physically disabled or A&E department'
when admisorc = 52 then 'NHS other hospital provider: ward for maternity patients or neonates'
when admisorc = 53 then 'NHS other hospital provider: ward for patients who are mentally ill or have learning disabilities'
when admisorc = 54 then 'NHS run Care Home'
when admisorc = 65 then 'Local authority residential accommodation i.e. where care is provided'
when admisorc = 66 then 'Local authority foster care, but not in residential accommodation '
when admisorc = 69 then 'Local authority home or care'
when admisorc = 79 then 'Babies born in or on the way to hospital'
when admisorc = 85 then 'Non-NHS run care home'
when admisorc = 86 then 'Non-NHS run nursing home'
when admisorc = 87 then 'Non-NHS run hospital'
when admisorc = 88 then 'Non-NHS run hospice'
when admisorc = 89 then 'Non-NHS institution'
when admisorc = 98 then 'Not applicable'
when admisorc = 99 then 'Not known'
else 'Incorrect Entry' 
end
as 'Description'
into admisorc
from nhs 

--- Elecdur Table 
--- errors in the elecdur table
create table elecdur (id varchar(50), Description varchar(50))

insert into elecdur VALUES (9998,'Not Applicable'),(9999, 'Not Known'),('Null', 'Not Known/Not Applicable') 


---Classpat table 

select distinct 
classpat as id, 
case
when classpat = 1 then 'Ordinary admission' 
when classpat = 2 then 'Day case admission'  
when classpat = 3 then 'Regular day attender'  
when classpat = 4 then 'Regular night attender'  
when classpat = 5 then 'Mothers and babies using only delivery facilities' 
when classpat = 8 then 'Not applicable (other maternity event)'
when classpat = 9 then 'Not known'
else 'Incorrect entry'
end as 'Description'
into classpat 
from nhs


---endage table 
--- endage error table
create table endage(id varchar(50), Description varchar(50))

insert into endage values
(7001 , 'Less than 1 day')
,(7002 , '1 to 6 days')
,(7003 , '7 to 28 days')  
,(7004 , '29 to 90 days') 
,(7005 , '91 to 181 days') 
,(7006 , '182 to 272 days') 
,(7007 , '273 to 365 days') 

--- create a personal data lookup table
select distinct hesid, newnhsno, lopatid, dob, sex, ethnos
into [Patient_Personal_Data]
from nhs 


--- final joined table, only showing necessary information
--- and columns ordered by relevant information
select
episode Episode,
hesid HessID , 
-- removing nulls-- 
COALESCE(newnhsno,'No Valid Entry') [NHS No.], 
lopatid [Local Identifier],
epistart [Episode Start Date], 
epiend [Episode End Date], 
spellbgin.description [Spell Begin Date], 
admincat.description  [Admin Category on Admission], 
admincatst.description [Admin Category], 
category.description Category, 
case
when dob like '%1800%' or dob like '%1801%' or dob like '%1600%' or dob like '%1582%' or dob is null then 'No Valid Entry'
Else dob
end
as [D.O.B] , 
--removing nulls--
COALESCE(ethnos.description,'No Valid Entry') as Ethnos, 
leglcat.description [Legal Category], 
admimeth.description [Admission Method], admisorc.description [Admission Source] , 
case
when elecdate like '%1800%' or elecdate like '%1801%' or elecdate like '%1600%' or elecdate like '%1582%' or elecdate is null then 'No Valid Entry'
Else elecdate
end
[Decided to Admit Date]
, 
classpat.description [Patient Classification], 
e.description Type,
s.description Sex, 
epistat.description Status, 
diag_01 Diagnosis
from nhs as n
left join sex as s on s.id = n.sex  
left join epitype as e on n.epitype = e.id
left join epistat on epistat.id = n.epistat
left join admincat on admincat.id = n.admincat
left join admincatst on admincatst.id = n.admincatst
left join spellbgin on spellbgin.id = n.spellbgin
left join category on category.id = n.category
left join ethnos on ethnos.id = n.ethnos
left join leglcat on leglcat.id = n.leglcat
left join admimeth on admimeth.id = n.admimeth
left join classpat on classpat.id = n.classpat
left join admisorc on admisorc.id = n.admisorc
