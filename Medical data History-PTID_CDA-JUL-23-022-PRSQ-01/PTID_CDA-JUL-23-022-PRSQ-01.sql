use project_medical_data_history;
select * from admissions;
select * from doctors;
select * from patients;
select * from province_names;
select * from patients;
-- Show first name, last name, and gender of patients who's gender is 'M'
select first_name,last_name,gender from patients where gender="M";

-- Show first name and last name of patients who does not have allergies
select first_name,last_name from patients where allergies is null;

-- Show first name of patients that start with the letter 'C'
select first_name from patients where first_name like "C%";

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name,last_name,weight from patients where weight between 100 and 120 order by(weight) ;

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
UPDATE patients SET allergies = 'NKA' WHERE allergies IS NULL;

-- Show first name and last name concatenated into one column to show their full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM patients;

-- Show first name, last name, and the full province name of each patient.
SELECT p.first_name, p.last_name, pn.province_name FROM patients AS p INNER JOIN 
province_names AS pn ON p.province_id = pn.province_id;

-- Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(*) AS patient_count FROM patients WHERE year(birth_date) = 2010;

-- Show the first_name, last_name, and height of the patient with the greatest height.
 select first_name,Last_name,height from patients where height=(select max(height) from patients);
 
 -- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
Select * from patients where patient_id in (1,45,534,879,1000);

-- Show the total number of admissions
select admission-id,count(*) from admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
select * from admissions where admission_date=discharge_date;

-- Show the total number of admissions for patient_id 579.
select count(*) from admissions where patient_id=579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct city,province_id from patients where province_id="NS";

-- Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name,last_name,birth_date from patients where height>160 and weight>70;
 
-- Show unique birth years from patients and order them by ascending.
select distinct(birth_date) from patients order by birth_date asc;

-- Show unique first names from the patients table which only occurs once in the list.
select first_name from patients GROUP BY first_name
HAVING COUNT(first_name) = 1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id,first_name from patients where first_name like"s%s" and length(first_name)>=6;

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
select p.first_name,p.last_name,a.patient_id,a.diagnosis from patients as p
join admissions as a
on p.patient_id=a.patient_id where diagnosis="Dementia";

-- Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select first_name from patients order by length(first_name) ,first_name;

-- Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select sum(gender="M") as male_patients, sum(gender="F") as Female_patients from patients;
select sum(case when Gender="M" then 1 else 0 end) as male_patients,sum(case when Gender="F" then 1 else 0 end) as Female_patients from patients;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT p.first_name, a.patient_id, a.diagnosis
FROM patients AS p
JOIN admissions AS a ON p.patient_id = a.patient_id
WHERE (a.patient_id, a.diagnosis) IN (
    SELECT a.patient_id, a.diagnosis
    FROM admissions a
    GROUP BY a.patient_id, a.diagnosis
    HAVING COUNT(*) > 1 
);

-- Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select city,count(city) as total_patients from patients group by city order by count(city) desc, city asc;

-- Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"
select first_name,last_name,"patient" as role from patients 
union all
select first_name,last_name,"doctor" as role from doctors;



-- Show all allergies ordered by popularity. Remove NULL values from query. 
select allergies,count(allergies) from patients where allergies is not null group by allergies order by allergies desc;


-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name,last_name,birth_date from patients where year(birth_date) between 1970 and 1979 order by  birth_date asc;

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane
SELECT
    CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY first_name DESC;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id,sum(height) from patients group by province_id having sum(height)>=7000; 

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight)-min(weight) from patients where last_name="Maroni";

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date),count(*)  from admissions  group by day(admission_date) order by day(admission_date) desc;

-- Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT
    FLOOR(weight / 10) * 10 AS weight_group,
    COUNT(*) AS total_patients
FROM
    patients
GROUP BY
    FLOOR(weight / 10) * 10
ORDER BY
    weight_group DESC; 
    
    -- Show patient_id, weight, height, isObese from the patients table.  Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm.
SELECT
    patient_id,
    weight,
    height,
    CASE WHEN (weight / (height / 100 * height / 100)) >= 30 THEN 1 ELSE 0 END AS isObese
FROM
    patients;
   
    
-- Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.
select p.patient_id, p.first_name, p.last_name,a.diagnosis,a.admission_date,d.specialty,d.first_name from patients as p
join doctors as d join admissions as a where a.diagnosis='Epilepsy' and d.first_name="Lisa";

-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
-- The password must be the following, in order:
   SELECT
    patient_id,
    temp_password
FROM (
    SELECT
        patient_id,
        CONCAT(patient_id, LENGTH(last_name), YEAR(birth_date)) AS temp_password,
        COUNT(*) AS password_check
    FROM
        patients
    GROUP BY
        patient_id, last_name, birth_date
) AS subquery
WHERE
    password_check = 1;
    
  
