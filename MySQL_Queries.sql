--  **  Scott Fike, June 23, 2026
--  ***********************************************************************************************************************************************
--  *                                                SMARTPHONE USAGE BEHAVIOR ANALYSIS PROJECT                                                   *
--  *                                                                                                                                             *
--  ***********************************************************************************************************************************************                                                                                       *


--  ***********************************************************************************************************************************************
--  *   Section I. Create Database, Table, Staging Table and Import Data                                                                                      *
--  *   Section II. Cleaning Data (using  CTEs, Windows Function Row_Number, Alter Table Modify, Null, Group By Having, TRIM() and DISTINCT )     *
--  *   Section III. Exploratory Data Analysis (usisng COUNT() and SUM()                                                                          *
--  *   Section IV. Validating dashboard page 1 KPI's (using ROW_NUMBER(), CTE's, Statistics Range-Mean-Median-Mode, Round() )                    *
--  *   Section V. Validating dashboard page 2 Total Hours (using FLOOR() creating Bins)                                                          *
--  *   Section VI. Validating dashboard page 3 Daily Usage (using AVG() nd SUM()                                                                 *
--  *   Section VII. Validating Dashboard Page 4 Stress, Sleep (using FLOOR() creating Bins, MAX(), AVG() and COUNT()                             *
--  *   Section VIII. Validating Dashboard Page 5 Addiction Levels (using COUNT(), MIN(), MAX()<,AVG() and Group By                               *
--  *   Section IX. Validating Dashboard Page 6 Classified as Addicted (using SUM(), AVG() and COUNT(). )                                         *
--  *   Section X. Validating Dashboard Page 7 Classsified as Addicted & Non-Addicted Statistics Matrix (using STDDEV_SAMP(), VAR_SAMP(),         *
--  *   CTE's(MODE), AVG()MEAN, Field <> ' ',                                                                                                     *
--  *********************************************************************************************************************************************** 


--  ***********************************************************************************************************************************************
--  *  Section I.                                                                                                                                 *
--  *  Create database smartphone, table smartphone_project AND import data FROM CSV file.                                                        *
--  ***********************************************************************************************************************************************
CREATE DATABASE  smartphone;
USE smartphone;
CREATE TABLE smartphone_project (
    Transaction_ID VARCHAR(20),
    User_ID VARCHAR(10),
    Age VARCHAR(10),
    Gender VARCHAR(10),
    Daily_screen_time_hours VARCHAR(26),
    Social_media_hours VARCHAR(26),
    Gaming_hours VARCHAR(20),
    Work_study_hours VARCHAR(20),
    Sleep_hours VARCHAR(20),
    Notifications_per_day VARCHAR(25),
    App_opens_per_day VARCHAR(20),
    Weekend_screen_time VARCHAR(25),
    Stress_level VARCHAR(10),
    Academic_work_impact VARCHAR(25),
    Addiction_level VARCHAR(20),
    Addicted_label VARCHAR(20)
);
--  **  Verify table before importing
SELECT 
    *
FROM
    smartphone_project; 
--  ** Right clicked on database, browsed AND SELECTed CSV file AND imported data.  Verified data AND schema column information using information_schema.columns 
DESCRIBE smartphone_project;
SELECT 
    *
FROM
    smartphone_project;
SELECT 
    *
FROM
    information_schema.columns
WHERE
    table_name = 'smartphone_project';

--  ** Created staging table
CREATE TABLE smartphone_project_staging LIKE smartphone_project;
INSERT Into smartphone_project_staging SELECT * FROM smartphone_project;
--  Verify data inserted into staging table successfully  
SELECT 
    *
FROM
    smartphone_project_staging;

--  *********************************************************************************************************************************************
--  *  Section II.                                                                                                                               *  
--  *  Cleaning Data                                                                                                                            *
-- *   Checked for duplicates with CTE and Windows Function Row_Number, COUNT(*), GROUP BY AND Having COUNT(*) > 1                                                                   *
-- *   Checked for NULLs with Column IS NULL OR Column = '';                                                                                    *
-- *   Checked for Standardization of data.  Variations in spelling, upper/lower case with Distinct.                                            *
-- *   Checked for  extra spaces with TRIM.                                                                                                     *
--  *  Changed data types FROM text to decimal AND numeric INT with ALTER TABLE.                                                                *
-- **********************************************************************************************************************************************
WITH duplicate_CTE AS 
  
  (SELECT 
		*,
  
  ROW_NUMBER()  over(partition by Transaction_ID, User_ID) AS row_num
  
  FROM   
	smartphone_project_staging)
 
 SELECT 
	* from duplicate_CTE
 
 WHERE 	
	row_num > 1 ;  --  No duplicates returned.  

SELECT 
    Transaction_ID, COUNT(*)
FROM
    smartphone_project_staging
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

SELECT 
    User_ID, COUNT(*)
FROM
    smartphone_project_staging
GROUP BY User_ID
HAVING COUNT(*) > 1;
--  ** Verified no duplicate userids or transaction ID's. Due to nature of data, the remaining columns will have repeating data ** --


SELECT 
    Transaction_ID
FROM
    smartphone_project_staging
WHERE
    Transaction_ID IS NULL
        OR Transaction_ID = '';
SELECT 
    User_ID
FROM
    smartphone_project_staging
WHERE
    User_ID IS NULL OR User_id = '';
SELECT 
    Age
FROM
    smartphone_project_staging
WHERE
    Age IS NULL OR Age = '';
SELECT 
    Gender
FROM
    smartphone_project_staging
WHERE
    Gender IS NULL OR Gender = '';
SELECT 
    Daily_screen_time_hours
FROM
    smartphone_project_staging
WHERE
    Daily_screen_time_hours IS NULL
        OR Daily_screen_time_hours = '';
SELECT 
    Social_media_hours
FROM
    smartphone_project_staging
WHERE
    Social_media_hours IS NULL
        OR Social_media_hours = '';
SELECT 
    Gaming_hours
FROM
    smartphone_project_staging
WHERE
    Gaming_hours IS NULL
        OR Gaming_hours = '';
SELECT 
    Work_study_hours
FROM
    smartphone_project_staging
WHERE
    Work_study_hours IS NULL
        OR Work_study_hours = '';
SELECT 
    Sleep_hours
FROM
    smartphone_project_staging
WHERE
    Sleep_hours IS NULL OR Sleep_hours = '';
SELECT 
    Notifications_per_day
FROM
    smartphone_project_staging
WHERE
    Notifications_per_day IS NULL
        OR Notifications_per_day = '';
SELECT 
    App_opens_per_day
FROM
    smartphone_project_staging
WHERE
    App_opens_per_day IS NULL
        OR App_opens_per_day = '';
SELECT 
    Weekend_screen_time
FROM
    smartphone_project_staging
WHERE
    Weekend_screen_time IS NULL
        OR Weekend_screen_time = '';
SELECT 
    Stress_level
FROM
    smartphone_project_staging
WHERE
    Stress_level IS NULL
        OR Stress_level = '';
SELECT 
    Academic_work_impact
FROM
    smartphone_project_staging
WHERE
    Academic_work_impact IS NULL
        OR Academic_work_impact = '';
SELECT 
    Addiction_level
FROM
    smartphone_project_staging
WHERE
    Addiction_level IS NULL
        OR Addiction_level = '';
SELECT 
    Addicted_label
FROM
    smartphone_project_staging
WHERE
    Addicted_label IS NULL
        OR Addicted_label = '';

-- ** Checking for variations in spelling, upper/lower case with Distinct, extra spaces with TRIM AND change
--    data type FROM text to decimal or numeric INT with ALTER TABLE. **
SELECT 
    *
FROM
    smartphone_project_staging;

ALTER TABLE smartphone_project_staging MODIFY Age INT;
ALTER TABLE smartphone_project_staging MODIFY Daily_screen_time_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Social_media_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Gaming_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Work_study_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Sleep_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Notifications_per_day INT;
ALTER TABLE smartphone_project_staging MODIFY App_opens_per_day INT;
ALTER TABLE smartphone_project_staging MODIFY Weekend_screen_time DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Addicted_label INT;
DESCRIBE smartphone_project_staging;

SELECT Addiction level, COUNT(Gaming_hours) 
WHERE Addiction_level = "Severe"
GROUP BY Addiction_level;

SELECT 
    Transaction_ID
FROM
    smartphone_project_staging;
SELECT DISTINCT
    Transaction_ID
FROM
    smartphone_project_staging;
SELECT 
    COUNT(DISTINCT Transaction_ID)
FROM
    smartphone_project_staging;
SELECT 
    Transaction_ID, TRIM(Transaction_ID)
FROM
    smartphone_project_staging;

SELECT 
    User_ID
FROM
    smartphone_project_staging;
SELECT DISTINCT
    User_ID
FROM
    smartphone_project_staging;
SELECT 
    COUNT(DISTINCT User_ID)
FROM
    smartphone_project_staging;
SELECT 
    User_ID, TRIM(User_ID)
FROM
    smartphone_project_staging;

SELECT 
    Age
FROM
    smartphone_project_staging;
SELECT 
    Age, TRIM(Age)
FROM
    smartphone_project_staging
ORDER BY age;

SELECT 
    Gender
FROM
    smartphone_project_staging
ORDER BY Gender;
SELECT DISTINCT
    Gender
FROM
    smartphone_project_staging
ORDER BY Gender;
SELECT 
    COUNT(DISTINCT Gender)
FROM
    smartphone_project_staging
ORDER BY Gender;
SELECT 
    Gender, TRIM(Gender)
FROM
    smartphone_project_staging
ORDER BY Gender;

SELECT 
    *
FROM
    smartphone_project_staging;

SELECT 
    Daily_screen_time_hours, TRIM(Daily_screen_time_hours)
FROM
    smartphone_project_staging
ORDER BY Daily_screen_time_hours;
SELECT 
    Social_media_hours, TRIM(social_media_hours)
FROM
    smartphone_project_staging
ORDER BY Social_media_hours;
SELECT 
    Gaming_hours, TRIM(Gaming_hours)
FROM
    smartphone_project_staging
ORDER BY Gaming_hours;
SELECT 
    Work_study_hours, TRIM(work_study_hours)
FROM
    smartphone_project_staging
ORDER BY Work_study_hours;
SELECT 
    Sleep_hours, TRIM(sleep_hours)
FROM
    smartphone_project_staging
ORDER BY Sleep_hours;
SELECT 
    Notifications_per_day, TRIM(Notifications_per_day)
FROM
    smartphone_project_staging
ORDER BY Notifications_per_day;
SELECT 
    App_opens_per_day, TRIM(app_opens_per_day)
FROM
    smartphone_project_staging
ORDER BY App_opens_per_day;
SELECT 
    Weekend_screen_time, TRIM(Weekend_screen_time)
FROM
    smartphone_project_staging
ORDER BY Weekend_screen_time;
SELECT 
    Work_study_hours, TRIM(work_study_hours)
FROM
    smartphone_project_staging
ORDER BY Work_study_hours;

SELECT 
    Stress_level
FROM
    smartphone_project_staging
ORDER BY Stress_level;
SELECT DISTINCT
    Stress_level
FROM
    smartphone_project_staging
ORDER BY Stress_level;
SELECT 
    COUNT(DISTINCT stress_level)
FROM
    smartphone_project_staging
ORDER BY Stress_level;
SELECT 
    Stress_level, TRIM(Stress_level)
FROM
    smartphone_project_staging
ORDER BY Stress_level;

SELECT 
    Academic_work_impact
FROM
    smartphone_project_staging
ORDER BY Academic_work_impact;
SELECT DISTINCT
    Academic_work_impact
FROM
    smartphone_project_staging
ORDER BY Academic_work_impact;
SELECT 
    COUNT(DISTINCT Academic_work_impact)
FROM
    smartphone_project_staging
ORDER BY Academic_work_impact;
SELECT 
    Academic_work_impact, TRIM(Academic_work_impact)
FROM
    smartphone_project_staging
ORDER BY Academic_work_impact;

SELECT 
    Addiction_level
FROM
    smartphone_project_staging
ORDER BY Addiction_level;
SELECT DISTINCT
    Addiction_level
FROM
    smartphone_project_staging
ORDER BY Addiction_level;
SELECT 
    COUNT(DISTINCT Addiction_level)
FROM
    smartphone_project_staging
ORDER BY Addiction_level;
SELECT 
    Addiction_level, TRIM(Addiction_level)
FROM
    smartphone_project_staging
ORDER BY Addiction_level;

SELECT 
    Addicted_label
FROM
    smartphone_project_staging
ORDER BY Addicted_label;
SELECT DISTINCT
    Addicted_label
FROM
    smartphone_project_staging
ORDER BY Addicted_label;
SELECT 
    COUNT(DISTINCT Addicted_label)
FROM
    smartphone_project_staging
ORDER BY Addicted_label;
SELECT 
    Addicted_label, TRIM(Addicted_label)
FROM
    smartphone_project_staging
ORDER BY Addicted_label;

--  *******************************************************************************************************************************************
--  *  Section III.                                                                                                                           *
--  *  Exploratory Data Analysis                                                                                                              *
--  *  Explored Usage Hours for outliers by addiction levels, stress levels, sleep levels, addicted, non-addicted by gender with Count()      *
--  *******************************************************************************************************************************************
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'; -- '2,434'
SELECT 
    Gaming_hours
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
ORDER BY Gaming_hours DESC; --  4.00 to 0.00
SELECT 
    Work_study_hours
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 'True'
ORDER BY Work_study_hours DESC; -- '2,192' records 6.00 to 4.55 to 0.50
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe';  --  '2.005431'
ALTER TABLE smartphone_project_staging MODIFY Gaming_hours DECIMAL(10,2);
DESCRIBE smartphone_project_staging;
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'None';  --  '2.006081'

SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'None';  -- '819'

SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Academic_work_impact = 'Yes';  -- '1190'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Academic_work_impact = 'No';  --  '1244'
ALTER TABLE smartphone_project_staging MODIFY Daily_screen_time_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Social_media_hours DECIMAL(10,2);
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe';  --  '2.005431'
ALTER TABLE smartphone_project_staging MODIFY Work_study_hours DECIMAL(10,2);
ALTER TABLE smartphone_project_staging MODIFY Weekend_screen_time DECIMAL(10,2);
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Gender = 'Other';  --  '824'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Gender = 'Male';  -- '848'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Gender = 'Female';  -- '762'
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Gender = 'Other';  -- '26.8325'
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Gender = 'Male';  -- '26.6356'
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Gender = 'Female';  -- '26.8189'
SELECT 
    COUNT(User_id)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'Severe'
        AND Addicted_label = 1;  -- '2434'
SELECT 
    SUM(Daily_screen_time_hours)
FROM
    smartphone_project_staging; -- '56249.34'
SELECT 
    SUM(Social_media_hours)
FROM
    smartphone_project_staging;-- WHERE Gender="Other";  -- '24551.13'
SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';  -- '8050.63'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging;  -- '7500'
SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging;  -- '24318.15'
SELECT 
    SUM(Daily_screen_time_hours)
FROM
    smartphone_project_staging; 
DESCRIBE smartphone_project_staging;  -- '56249.34'

SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0
ORDER BY Addiction_level ASC;  --  '2192' rows
SELECT 
    COUNT(sleep_hours),
    COUNT(Daily_screen_time_hours),
    COUNT(Gaming_hours),
    COUNT(Social_media_hours),
    COUNT(Work_study_hours),
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0;  --  2192 each
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0;  --  2192 rows
SELECT 
    SUM(sleep_hours),
    SUM(Daily_screen_time_hours),
    SUM(Gaming_hours),
    SUM(Social_media_hours),
    SUM(Work_study_hours),
    SUM(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0; --  '14613.33', '11303.84', '4381.92', '4935.54', '7101.36', '15112.82'

SELECT 
    SUM(sleep_hours),
    SUM(Daily_screen_time_hours),
    SUM(Gaming_hours),
    SUM(Social_media_hours),
    SUM(Work_study_hours),
    SUM(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1;  --  '35918.38', '44945.50', '10724.45', '19615.59', '17216.79', '54215.88'

--  GROUP BY sleep_hours;
SELECT 
    *
FROM
    smartphone_project_staging;
SELECT 
    COUNT(Addicted_label)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = '1'
GROUP BY Addiction_level;  --  '2874' '2434'
SELECT 
    COUNT(DISTINCT Daily_screen_time_hours)
FROM
    smartphone_project_staging;  -- '900'
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female'
        AND Addicted_label = '1';  -- '1728'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female'
        AND Addicted_label = '1';  -- '1728'
SELECT 
    SUM(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = '1';  -- '54215.88'

SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Sleep_hours >= 8
        AND Stress_level = 'High'; -- '504'
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Sleep_hours >= 8
        AND Stress_level = 'Medium'; -- '542'
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Sleep_hours >= 8
        AND Stress_level = 'Low';  -- '567'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  -- '1728'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  -- '733'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  -- '1844'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  -- '709'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  --  '1736'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  -- '750'
    
-- page 4 stress / sleep exploring
    
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
        AND Sleep_hours = 9;  -- '1'
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';  -- '2560'
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';  -- '2437'
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
        AND Sleep_hours = 8.96;  -- '12'
SELECT 
    *
FROM
    smartphone_project_staging;  -- 
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  -- '26.5821'
SELECT 
    gender, Social_media_hours, AVG(Age)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
GROUP BY Social_media_hours
ORDER BY Social_media_hours;  -- 0.50 to 6.00 hours

SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
GROUP BY Work_study_hours
ORDER BY COUNT(Work_study_hours);  
   SET session sql_mode = '';
SELECT 
    Work_study_hours
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND age = 18;
SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Age = 35;   -- '480.13'

SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0
ORDER BY Addiction_level;
SELECT 
    COUNT(age)
FROM
    smartphone_project_staging
WHERE
    age = 31;  -- '461'
SELECT 
    COUNT(age)
FROM
    smartphone_project_staging
WHERE
    age = 27;  -- '431'
SELECT 
    COUNT(age), age
FROM
    smartphone_project_staging
GROUP BY age
ORDER BY age, COUNT(age) DESC;

--  ***********************************************************************************************************************************************
--  *  Section IV.                                                                                                                                *
--  *  Dashboard Page 1 KPI's.  Validation using Window Function ROW_NUMBER(), CTE Windows, Range, Statistics Range-Mean-Median-Mode, Round()      *
-- ************************************************************************************************************************************************
--  **  Daily Screen Time Hours **
--  Range
SELECT 
    MAX(Daily_screen_time_hours) - MIN(Daily_screen_time_hours) AS screentime_range
FROM
    smartphone_project_staging;-- 9.00
--  Mean
SELECT 
    AVG(Daily_screen_time_hours) AS AVG_screentime_Mean
FROM
    smartphone_project_staging;   --  7.499912 converts to 7:30:00
--  Median
SELECT AVG(t1.Daily_screen_time_hours) AS median_hours
FROM (
        SELECT Daily_screen_time_hours, 
        row_number() over (order by Daily_screen_time_hours) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Daily_screen_time_hours IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  7.525000 converts to 7 hours 31 minutes AND 30 seconds clock time 7:31:30
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(Daily_screen_time_hours,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- hours_val 8.13 converts to 8 hours 8 minutes or

--  Range
SELECT 
    MAX(Social_media_hours) - MIN(Social_media_hours) AS screentime_range
FROM
    smartphone_project_staging;-- 5.50 converts to 5:30:00
-- Mean
SELECT 
    AVG(Social_media_hours) AS AVG_SM_Mean
FROM
    smartphone_project_staging;  -- 3.273484 converts to 3:16:25
--  Median
SELECT AVG(t1.Social_media_hours) AS median_hours
FROM (
        SELECT Social_media_hours, 
        row_number() over (order by Social_media_hours) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Social_media_hours IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  3.270000 converts to 3:16:12 clock hours min 
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(Social_media_hours,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 3.07 hours_val converts to 3 hours 4 minutes 12 sec 3:04:12 
          
--  Range
SELECT 
    MAX(Gaming_hours) - MIN(Gaming_hours) AS screentime_range
FROM
    smartphone_project_staging;-- 4.00 = 4:00:00 clock time
--  Mean
SELECT 
    AVG(Gaming_hours) AS AVG_screentime_Mean
FROM
    smartphone_project_staging;   --  2.014183 converts to 2:00:51
--  Median
SELECT AVG(t1.Gaming_hours) AS median_hours
FROM (
        SELECT Gaming_hours, 
        row_number() over (order by Gaming_hours) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Gaming_hours IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  2.040000 converts to 2:02:24 clock hours min
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(Gaming_hours,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- hours_val 2.37 converts to 2:22:12
--  Range
SELECT 
    MAX(Sleep_hours) - MIN(Sleep_hours) AS screentime_range
FROM
    smartphone_project_staging;--  4.50 converts to 4:30:00 clock hours min
-- Mean
SELECT 
    AVG(Sleep_hours) AS AVG_sleephours_Mean
FROM
    smartphone_project_staging;   --  6.737561 converts to 6:44:15 hours min sec
-- Median
SELECT AVG(t1.Sleep_hours) AS median_hours
FROM (
        SELECT Sleep_hours, 
        row_number() over (order by Sleep_hours) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Sleep_hours IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  6.720000 converts to 6:43:12 hours min sec 
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(Sleep_hours,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- hours_val 7.77 converts to 7:46:12 
          
--  Range
SELECT 
    MAX(Work_study_hours) - MIN(Work_study_hours) AS screentime_range
FROM
    smartphone_project_staging;--  5.50 converts to 05:30:00 clock hours min
--  Mean
SELECT 
    AVG(Work_study_hours) AS AVG_Worfkstudy_Mean
FROM
    smartphone_project_staging;  --  3.242420 converts to 3:14:33 hours min sec
-- Median
SELECT AVG(t1.Work_study_hours) AS median_hours
FROM (
        SELECT Work_study_hours, 
        row_number() over (order by Work_study_hours) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Work_study_hours IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  3.230000 converts to 3:14:48 hours min sec       
-- Mode
WITH FrequencyCTE AS (
      SELECT
          ROUND(Work_study_hours,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- hours_val 3.66 converts to 3:39:36 hours min sec 

--  Range
SELECT 
    MAX(Notifications_per_day) - MIN(Notifications_per_day) AS screentime_range
FROM
    smartphone_project_staging;--  230
--  Mean
SELECT 
    AVG(Notifications_per_day) AS AVG_notificationsperday_Mean
FROM
    smartphone_project_staging;   --  134.2573 to 34.26
--  Median
SELECT AVG(t1.Notifications_per_day) AS median_hours
FROM (
        SELECT Notifications_per_day, 
        row_number() over (order by Notifications_per_day) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Notifications_per_day IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  -- 134.0000 134
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(Notifications_per_day,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  184
          
--  Range
SELECT 
    MAX(App_opens_per_day) - MIN(App_opens_per_day) AS screentime_range
FROM
    smartphone_project_staging;-- 165
--  Mean
SELECT 
    AVG(App_opens_per_day) AS AVG_screentime_Mean
FROM
    smartphone_project_staging;   -- 97.8324   97.83
--  Median
SELECT AVG(t1.App_opens_per_day) AS median_hours
FROM (
        SELECT App_opens_per_day, 
        row_number() over (order by App_opens_per_day) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE App_opens_per_day IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  98.0000 98
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(App_opens_per_day,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 109 

--  Range
SELECT 
    MAX(Age) - MIN(Age) AS screentime_range
FROM
    smartphone_project_staging;-- 17
--  Mean
SELECT 
    AVG(Age) AS AVG_Age_Mean
FROM
    smartphone_project_staging;   --  26.58   27
--  Median
SELECT AVG(t1.Age) AS median_hours
FROM (
        SELECT Age, 
        row_number() over (order by Age) AS row_num,
        COUNT(*) over () AS total_rows
        FROM smartphone_project_staging
        WHERE Age IS NOT NULL
        ) t1
        WHERE t1.row_num IN (FLOOR((t1.total_rows +1) /2), CEIL((t1.total_rows +1) /2));  --  27.0000    27  
--  Mode        
WITH FrequencyCTE AS (
      SELECT
          ROUND(Age,2) AS hours_val,
          COUNT(*) AS frequency
          FROM smartphone_project_staging
          GROUP BY hours_val
          )
          SELECT hours_val, frequency FROM FrequencyCTE  WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  31

SELECT 
    COUNT(Addiction_level)
FROM
    smartphone_project_staging
WHERE
    Addiction_level = 'None';-- 819
SELECT 
    COUNT(Addiction_level)
FROM
    smartphone_project_staging;  -- 7,500

WITH ADCTnoneCTE AS ( 
                   SELECT COUNT(Addiction_level) AS none_COUNT
                   FROM smartphone_project_staging 
                   WHERE Addiction_level ='None'
                   )
                   SELECT
                   (SELECT none_COUNT FROM ADCTnoneCTE) * 1.0 / ( SELECT COUNT(Addiction_level) FROM smartphone_project_staging) * 100 As Addiction_ratio;  --  10.92
          
--  Mild
		WITH ADCTnoneCTE AS ( 
                   SELECT COUNT(Addiction_level) AS none_COUNT
                   FROM smartphone_project_staging 
                   WHERE Addiction_level ='Mild'
                   )
                   SELECT
                   (SELECT none_COUNT FROM ADCTnoneCTE) * 1.0 / ( SELECT COUNT(Addiction_level) FROM smartphone_project_staging) * 100 As Addiction_ratio; -- 18.30700 18.31
--  Moderate
		WITH ADCTnoneCTE AS ( 
                   SELECT COUNT(Addiction_level) AS none_COUNT
                   FROM smartphone_project_staging 
                   WHERE Addiction_level ='Moderate'
                   )
                   SELECT
                   (SELECT none_COUNT FROM ADCTnoneCTE) * 1.0 / ( SELECT COUNT(Addiction_level) FROM smartphone_project_staging) * 100 As Addiction_ratio; -- 38.45300 32.45
--  Severe
		WITH ADCTnoneCTE AS ( 
                   SELECT COUNT(Addiction_level) AS none_COUNT
                   FROM smartphone_project_staging 
                   WHERE Addiction_level ='Severe'
                   )
                   SELECT
                   (SELECT none_COUNT FROM ADCTnoneCTE) * 1.0 / ( SELECT COUNT(Addiction_level) FROM smartphone_project_staging) * 100 As Addiction_ratio;-- 18.30700 18.31
--  Gender COUNTs
SELECT 
    COUNT(Gender)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  2,461
SELECT 
    COUNT(Gender)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  2,553
SELECT 
    COUNT(Gender)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  2486

SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
GROUP BY Stress_level
ORDER BY Stress_level;  --  Medium 2,437, Low 2,503, High 2,560
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
GROUP BY age
ORDER BY age;--  399, 400, 440, 443, 396, 413, 376, 408, 429, 431, 369, 427, 410, 461, 433, 432, 418, 415
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging;--  7,500
--  ***********************************************************************************************************************************************
--  *  Section V.                                                                                                                                 *
--  *  Dashboard Page 2. Total Hours.  Validation using FLOOR() creating Bins.                                                                    *
--  ***********************************************************************************************************************************************
SELECT 
    FLOOR(Daily_screen_time_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Daily_screen_time_Hours) AS total_hours
FROM
    smartphone_project_staging
GROUP BY FLOOR(Daily_screen_time_hours)
ORDER BY hour_bin;--  users by hour:  3/859, 4/ 819, 5/854, 6/768, 7/850, 8/813, 9/816, 10/926, 11/791, 12/4

SELECT 
    FLOOR(Gaming_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Gaming_hours) AS total_hours
FROM
    smartphone_project_staging
GROUP BY FLOOR(gaming_hours)
ORDER BY hour_bin;--  users by hour:  0/1829, 1/1832, 2/1977, 3/1852, 4/10 
    
SELECT 
    FLOOR(Weekend_screen_time) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Weekend_screen_time) AS total_hours
FROM
    smartphone_project_staging
GROUP BY FLOOR(Weekend_screen_time)
ORDER BY hour_bin;--  users by hour:  3/45, 4/361, 5/665, 6/833, 7/824, 8/818, 9/811, 10/812, 11/875, 12/767, 13/520, 14/169 
    
SELECT 
    FLOOR(Social_media_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Social_media_hours) AS total_hours
FROM
    smartphone_project_staging
GROUP BY FLOOR(Social_media_hours)
ORDER BY hour_bin;--  users by hour:  0/642, 1/1351, 2/1381, 3/1358, 4/1358, 5/1400, 6/10
    
SELECT 
    FLOOR(Work_study_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Work_study_hours) AS total_hours
FROM
    smartphone_project_staging
GROUP BY FLOOR(Work_study_hours)
ORDER BY hour_bin;--  users by hour:  0/712, 1/1372, 2/1340. 3/1353, 4/1303, 5/1410, 6/10
    
SELECT 
    FLOOR(Sleep_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Sleep_hours) AS total_hours
FROM
    smartphone_project_staging
GROUP BY FLOOR(Sleep_hours)
ORDER BY hour_bin;--  users by hour:  4/787, 5/1687, 6/1748, 7/1665, 8/1606, 9/7
--  *********************************************************************************************************************************************
--  *  Section VI.                                                                                                                              *
--  *  Dashboard Page 3. Daily Usage.  Validation using AVG() nd SUM()                                                                          *
--  *********************************************************************************************************************************************
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--    26.44  26
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--      26.51  27
SELECT 
    AVG(Age)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--     26.67  27

SELECT 
    SUM(Daily_screen_time_hours)
FROM
    smartphone_project_staging;--  56,249.34
SELECT 
    SUM(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--  18,325.18
SELECT 
    SUM(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--     19,300.75
SELECT 
    SUM(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--    18,623.41


SELECT 
    SUM(Social_media_hours)
FROM
    smartphone_project_staging;--  24,551.13
SELECT 
    SUM(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--        8,027.00 
SELECT 
    SUM(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--           8,426.41
SELECT 
    SUM(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--          8.097.72

SELECT 
    SUM(Gaming_hours)
FROM
    smartphone_project_staging;--                                     15,106.37
SELECT 
    SUM(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--               4.979.52 
SELECT 
    SUM(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--                  5,128.38
SELECT 
    SUM(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--                 4,998.47

SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging;--                                 24,318.15
SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--            8,050.63 
SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--               8186.53
SELECT 
    SUM(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--              8080.99

--  ********************************************************************************************************************************************
--  *  Section VII.                                                                                                                            *
--  *  Dashboard Page 4. Stress and Sleep.  Validation using FLOOR() creating Bins, MAX(), AVG() and COUNT()                                    *
--  ********************************************************************************************************************************************
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Stress_level = 'High';--   818
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Stress_level = 'Medium';--  796
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Stress_level = 'Low';--  847

SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
        AND Stress_level = 'High';--   855
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
        AND Stress_level = 'Medium';--  846
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Stress_level = 'Low';--  852

SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Stress_level = 'High';--   887
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Stress_level = 'Medium';--  795
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Stress_level = 'Low';--  804

SELECT 
    FLOOR(Sleep_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Sleep_hours) AS total_hours
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female'
GROUP BY FLOOR(Sleep_hours)
ORDER BY hour_bin;--  users by hour:  4/250, 5/552, 6/581, 7/541, 8/553, 9/4
    
SELECT 
    FLOOR(Sleep_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Sleep_hours) AS total_hours
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male'
GROUP BY FLOOR(Sleep_hours)
ORDER BY hour_bin;--  users by hour:  4/248, 5/542, 6/607, 7/580, 8/575, 9/1
    
SELECT 
    FLOOR(Sleep_hours) AS hour_bin,
    COUNT(*) AS total_records,
    COUNT(User_ID) AS users,
    SUM(Sleep_hours) AS total_hours
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other'
GROUP BY FLOOR(Sleep_hours)
ORDER BY hour_bin;--  users by hour:  4/289, 5/593, 6/560, 7/544, 8/498, 9/2
    
SELECT 
    MIN(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--   4.50    
SELECT 
    MIN(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--  4.50
SELECT 
    MIN(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--    4.50

SELECT 
    MAX(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--    9.00
SELECT 
    MAX(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--  9.00
SELECT 
    MAX(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--     9.00

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--  9.3259     9.33
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--  9.1473   9.15  
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--   9.2538     9.25

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--          7.58
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--        7.42
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--           7.50

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--               3.25
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--             3.29
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--                3.29

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--                 3.30
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--               3.19
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--                  3.23

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--                     2.01
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--                   2.02
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--                      2.01

SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--            14.80
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--           14.79
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--              14.88

SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--          11.99
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--       12.00
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--          12.00

SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--               6.00
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--                6.00
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--             6.00

SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--                 6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--               6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--                  6.00

SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High';--                     4.00
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium';--                    4.00
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low';--                      4.00
    
    -- ccccccccccccccccccccccccccccccccccccccccccccccc
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
	AND 
		Gender ='Female';  --  '9.290110' 9.29
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Female'; --  '9.095465' 9.10
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Female';  -- '9.172621' 9.17

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Female'; --   '7.526308' 7.53
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Female';  --    '7.391671'  7.39
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Female'; --   '7.420177'  7.42       

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender = 'Female'; --   '3.198998' 3.20
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Female'; --  '3.292412'  3.29
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Female'; --  '3.293341'    3.29

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
 Gender='Female'; -- '3.350746'  3.35
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Female'; --    '3.171646'  3.17
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Female'; --  '3.288182'  3.29  

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Female';  --   '1.971919'  1.97
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Female'; --  '2.052437'  2.05
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Female'; -- '2.045750'  2.05  

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
	AND 
		Gender ='Male';  --  '9.363673'  9.36
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Male'; --  '9.205697'    9.21
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Male';  -- '9.378005'  9.38

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Male'; --  '7.628187'  7.63
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Male';  -- '7.457494' 7.46
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Male'; --  '7.593439'  7.59

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender = 'Male'; --   '3.305673'  3.31
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Male'; --  '3.265024'  3.27
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Male'; -- '3.330810'  3.33

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
 Gender='Male'; -- '3.243123' 3.24
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Male'; --    '3.233014' 3.23
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Male'; --  '3.143815'  3.14

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Male';  --   '2.015462'   2.02
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Male'; --  '2.008617'  2.01
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Male'; -- '2.002195'  2.00


SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
	AND 
		Gender ='Other';  --  '9.322570' 9.32
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Other'; --  '9.137082' 9.14
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Other';  -- '9.207799'  9.21

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Other'; --  '7.586990'  7.59
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Other';  -- '7.394780'  7.39
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Other'; --  '7.481219'  7.48

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender = 'Other'; --   '3.234521' 3.23
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Other'; --  '3.302201' 3.30
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Other'; -- '3.238122'  3.24

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
 Gender='Other'; -- '3.308737'  3.31
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Other'; --    '3.177409'  3.18
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Other'; --  '3.258831'  3.26

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Other';  --    '2.033878' 2.03
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Other'; --  '2.006579' 2.01
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Other'; -- '1.989042'  1.99


SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Female';  -- '14.77' 14.77
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Female'; -- '14.71'  14.71
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'

AND
	Gender ='Female'; -- '14.88' 14.88

SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'; -- '11.99'  11.99
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND 
	Gender ='Female'; --    11.99'  11.99  
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Female'; --   '11.98'  11.98

SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Female'; -- '6.00'  6.00
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Female'; --   '5.99'  
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Female'; --     '6.00'        6.00

SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
Gender ='Female'; --    '6.00'   6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Female'; --    '6.00'     6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Female'; -- '5.98'  5.98    

SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Female'; --  '4.00'    4.00
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Female'; --   '4.00'  4.00
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Female'; --    '4.00'  4.00


SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Male';  -- '14.68' 14.68
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Male'; -- '14.79'  14.79
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'

AND
	Gender ='Male'; -- '14.75'  14.75

SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Male'; -- '11.98'  11.98
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND 
	Gender ='Male'; --    11.99'  11.99  
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Male'; -- '11.99'

SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Male'; -- '6.00'  6.00
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Male'; --   '5.99'  5.99
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Male'; --  '5.99' 5.99

SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
Gender ='Male'; --    '6.00'   6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Male'; --    '6.00'     6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Male'; --   '6.00' 6.00

SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Male'; --  '3.99'  3.99
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Male'; --   '3.98'  3.98
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Male'; --    '4.00'  4.00

SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Other';  -- '14.80'
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Other'; -- '14.75' 14.75
SELECT 
    MAX(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'

AND
	Gender ='Other'; -- '14.84'

SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Other'; -- '11.97'
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND 
	Gender ='Other'; --   '12.00'  12.00
SELECT 
    MAX(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Other'; -- '12.00'  12.00

SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Other'; -- '6.00'  6.00
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender = 'Other'; --   '6.00'
SELECT 
    MAX(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Other'; --  '6.00' 6.00

SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
Gender ='Other'; --  '5.99' 5.99  
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender = 'Other'; --    '6.00'     6.00
SELECT 
    MAX(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Other'; --   '6.00' 6.00

SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
AND
	Gender ='Other'; --  '3.99'  3.99
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Medium'
AND
	Gender ='Other'; --   '3.99'  3.99
SELECT 
    MAX(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'Low'
AND
	Gender ='Other'; --    '4.00'  4.00
    
--  *******************************************************************************************************************************************
--  *  Section VIII.                                                                                                                          *
--  *  Dashboard Page 5. Addiction Levels and Device Interaction.  Validation using COUNT(), MIN(), MAX()<,AVG(), Group By                    *
--  *******************************************************************************************************************************************
SELECT 
    COUNT(Addiction_level)
FROM
    smartphone_project_staging
GROUP BY Addiction_level
ORDER BY Addiction_level DESC;--  819, 1373, 2434, 2874
SELECT 
    COUNT(Addiction_level)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
GROUP BY Addiction_level
ORDER BY Addiction_level DESC;--  762, 278, 966, 455
SELECT 
    COUNT(Addiction_level)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
GROUP BY Addiction_level
ORDER BY Addiction_level DESC;--   848, 269, 996, 440
SELECT 
    COUNT(Addiction_level)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
GROUP BY Addiction_level
ORDER BY Addiction_level DESC;--  824, 272, 912, 478

SELECT 
    COUNT(Academic_work_impact)
FROM
    smartphone_project_staging
GROUP BY Academic_work_impact;-- 3747 Impacted, 3753 Not Impacted
SELECT 
    COUNT(Academic_work_impact)
FROM
    smartphone_project_staging
WHERE
    Academic_work_impact = 'Yes'
GROUP BY Addiction_level;--   412, 1462, 1190, 683

SELECT 
    COUNT(Stress_level)
FROM
    smartphone_project_staging
WHERE
    Stress_level = 'High'
GROUP BY Addiction_level;--  470, 969, 289, 832

SELECT 
    MIN(Notifications_per_day),
    AVG(Notifications_per_day),
    MAX(Notifications_per_day)
FROM
    smartphone_project_staging;--  20, 134.26, 250

SELECT 
    MIN(App_opens_per_day),
    AVG(App_opens_per_day),
    MAX(App_opens_per_day)
FROM
    smartphone_project_staging;--  15, 97.83, 180
SELECT 
    AVG(App_opens_per_day)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 'True';--  97.0005  98
--  *********************************************************************************************************************************************
--  *  Section IX.                                                                                                                               *
--  *  Dashboard Page 6. Classified as Addicted.  Validation using SUM(), AVG() and COUNT().                                                                             *
--  *********************************************************************************************************************************************
SELECT
	SUM(Weekend_screen_time)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1 ; -- '54,215.88'

SELECT
	SUM(Daily_screen_time_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1 ; -- '44945.50'
    
SELECT
	SUM(Work_study_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1 ; -- '17216.79'
    
SELECT
	SUM(Social_media_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1 ; -- '19615.59'
    
SELECT
	SUM(Gaming_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1 ; -- '10724.45'
    
SELECT
	SUM(Weekend_screen_time)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =0 ; -- '15112.82'
    
SELECT
	SUM(Daily_screen_time_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =0 ; -- '11303.84'
    
SELECT
	SUM(Work_study_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =0 ; -- '7101.36'
    
SELECT
	SUM(Social_media_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =0 ; -- '4935.54'
    
SELECT
	SUM(Gaming_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =0 ; -- '4381.92'
    
SELECT
	SUM(Weekend_screen_time)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1
AND gender='Female'; -- '17562.79'

SELECT
	SUM(Daily_screen_time_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1
AND gender='Female'; -- '14563.68'

SELECT
	SUM(Work_study_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1
AND gender='Female'; -- '5642.45'

SELECT
	SUM(Social_media_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1
AND gender='Female'; -- '6351.86'

SELECT
	SUM(Gaming_hours)
FROM
	smartphone_project_staging
WHERE 
	Addicted_label =1
AND gender='Female'; -- '3523.55'

SELECT
	COUNT(Addicted_label)
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label =1; -- '5,308'

SELECT
	COUNT(Addicted_label)
FROM 	
	smartphone_project_staging
WHERE 
	Addicted_label =0; -- '2,192'

SELECT
	COUNT(Addicted_label)
FROM 	
	smartphone_project_staging
WHERE 
	Addicted_label =1 
AND 
	gender ='Female'; -- '1,728'

SELECT
	COUNT(Addicted_label)
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label =0 
AND 
	gender ='Female'; -- '733'

SELECT
	COUNT(Addicted_label)
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label =1 
AND 
	gender ='Male'; -- '1,844'

SELECT
	COUNT(Addicted_label)
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label =0 
AND 
	gender ='Male'; -- '709'

SELECT
	COUNT(Addicted_label)
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label =1 
AND 
	gender ='Other'; -- '1,736'

SELECT
	COUNT(Addicted_label)
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label =0
AND 
	gender ='Other'; -- '750'

SELECT
	COUNT(Addicted_label), Addiction_level
FROM 
	smartphone_project_staging
WHERE 	
	Addicted_label=1
GROUP BY 
	Addiction_level; -- Moderate 2,874, Severe 2,434

SELECT
	COUNT(Addicted_label), Addiction_level
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=1
AND 
	gender ='Female'
GROUP BY 
	Addiction_level; -- Moderate 966, Severe 762

SELECT
	COUNT(Addicted_label), Addiction_level
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=1
AND 
	gender ='Male'
GROUP BY 
	Addiction_level; -- Moderate 996, Severe 848

SELECT
	COUNT(Addicted_label), Addiction_level
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=1
AND 
	gender ='Other'
GROUP BY 
	Addiction_level; -- Moderate 912, Severe 824

SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=0
GROUP BY 
	age 
ORDER BY 
	age; -- 15,112.82

SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=0
AND 
	gender ='FEMALE'
GROUP BY 
	age 
ORDER BY 
	age; -- 5,045.72

SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=0
AND 
	gender ='Male'
GROUP BY 
	age 
ORDER BY 
	age; -- 4,859.04

SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=0
AND 
	gender ='Other'
GROUP BY 
	age 
ORDER BY 
	age; -- 5,208.06


SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=1
GROUP BY 
	age 
ORDER BY 
	age; -- 54,215.88

SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=1
AND 
	gender ='FEMALE'
GROUP BY 
	age 
ORDER BY 
	age; -- 17,562.79

SELECT 
	SUM(Weekend_screen_time), Age
FROM 	
	smartphone_project_staging
WHERE 
	Addicted_label=1
AND 
	gender ='Male'
GROUP BY 
	age 
ORDER BY 
	age; -- 18,924.98

SELECT 
	SUM(Weekend_screen_time), Age
FROM 
	smartphone_project_staging
WHERE 
	Addicted_label=1
AND 
	gender ='Other'
GROUP BY 
	age 
ORDER BY 
	age; -- 17,728.11

SELECT
	COUNT(Addicted_label), age
FROM
	smartphone_project_staging
WHERE
	Addicted_label=1
GROUP BY 
	Age
ORDER BY 
	Age;  -- 5,308
    
SELECT
	COUNT(Addicted_label), age
FROM
	smartphone_project_staging
WHERE
	Addicted_label=1
AND 
	Gender ='Female'
GROUP BY 
	Age
ORDER BY 
	Age;  -- 1,728

SELECT
	AVG(Age) 
FROM 
	smartphone_project_staging 
WHERE 
	Gender ='Female' 
AND 
	Addicted_label =1;  -- 26.11
    
SELECT
	COUNT(Addicted_label), age
FROM
	smartphone_project_staging
WHERE
	Addicted_label=1
AND 
	Gender ='Male'
GROUP BY 
	Age
ORDER BY 
	Age;  -- 1,844

SELECT
	AVG(Age) 
FROM 
	smartphone_project_staging 
WHERE 
	Gender ='Male' 
AND 
	Addicted_label =1;  -- 26.46

SELECT
	COUNT(Addicted_label), age
FROM
	smartphone_project_staging
WHERE
	Addicted_label=1
AND 
	Gender ='Other'
GROUP BY 
	Age
ORDER BY 
	Age;  -- 1,736

SELECT
	AVG(Age) 
FROM 
	smartphone_project_staging 
WHERE 
	Gender ='Other' 
AND 
	Addicted_label =1;  -- 26.68

--  **********************************************************************************************************************************************
--  *  Section X.                                                                                                                               *
--  *  Dashboard Page 7. Addicted and Non-Addicted Statistics.  Validation using STDDEV_SAMP(), VAR_SAMP(), CTE's(MODE), AVG()MEAN, Field <> ' ',*                                                                                                                        *
-- ***********************************************************************************************************************************************
--  **  Validating only Gaming Hours Column has empty rows out of the 6 usage hours columns ** --
--
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Daily_screen_time_hours = ' '
        OR Daily_screen_time_hours = 0.00; --  No records
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Work_study_hours = ' '
        OR Work_study_hours = 0.00;--  No records
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Sleep_hours = ' ' OR Sleep_hours = 0.00;--  No records
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Gaming_hours = ' '
        OR Gaming_hours = 0.00;-- 6 records, 3 FEMALE 0.00, 1 MALE 0.00, 2 OTHER 0.00
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Weekend_screen_time = ' '
        OR Weekend_screen_time = 0.00;-- No records
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    Social_media_hours = ' '
        OR Social_media_hours = 0.00;--  No records


--  ** Screen Time Hours Matrix ** --
SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  7.446233  7.45
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  2,461
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Sleep_hours <> 0.00
        OR gender = 'Female'
        AND Daily_screen_time_hours <> ' ';-- 2,461
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--  2.62280    2.62
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';  --  '6.87908747240695'   6.88

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Female'
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.75

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  '8.428056' 8.43
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  1,728
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Female'
        AND Daily_screen_time_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Female'
        AND Daily_screen_time_hours <> ' ';--  1,728
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;--  '2.4078320222324834'  2.41
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  --  '5.7976550472881705'  5.80

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 1
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  10.50

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  5.13  
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  733
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Female'
        AND Daily_screen_time_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Female'
        AND Sleep_hours <> ' ';--  733
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;--  '1.3415190510003352' 1.34
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  --  '1.7996733641968397'  1.80

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 0
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.75

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--    '7.560027'   7.56
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  2553
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
        AND Daily_screen_time_hours <> 0.00
        OR gender = 'Male'
        AND Daily_screen_time_hours <> ' ';-- 2,553
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--  '2.6067048899444805'  2.61
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  --  '6.794910383260467'  6.79

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--    '8.499300' 8.50
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  1,844
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Male'
        AND Daily_screen_time_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Male'
        AND Sleep_hours <> ' ';--  1,844
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;-- '2.3513840947219493'  2.35
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  --  '5.529007160911361'  5.53

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 1
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  11.51

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--    '5.117123'
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--  '709'
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Male'
        AND Daily_screen_time_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Male'
        AND Daily_screen_time_hours <> ' ';--  709
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;-- '1.3512149431130827'  1.35
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  --  '1.8257818224920914'

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 0
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  4.90

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--   '7.491315'  7.49
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  ,2486
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Daily_screen_time_hours <> 0.00
        OR gender = 'Other'
        AND Daily_screen_time_hours <> ' ';-- 2,486
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';-- '2.597977111123331'  2.60
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';  --  '6.74948506992073'  6.75

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 7.81

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;--    '8.472990'  8.47
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;--  1736
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Other'
        AND Daily_screen_time_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Other'
        AND Daily_screen_time_hours <> ' ';--  1,736
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;-- '2.382717938517315'  2.38
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  --  '5.6773447745322025'  5.68

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 1
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  10.74

SELECT 
    AVG(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;--    '5.219067'  5.22
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;--  750
SELECT 
    COUNT(Daily_screen_time_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Other'
        AND Daily_screen_time_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Other'
        AND Daily_screen_time_hours <> ' ';--  750
SELECT 
    STDDEV_SAMP(Daily_screen_time_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;-- '1.3558878904679328'  1.36
SELECT 
    VAR_SAMP(Daily_screen_time_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  --  '1.8384319715175812'  1.84

WITH FrequencyCTE AS (
    SELECT 
        Daily_screen_time_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 0
    GROUP BY Daily_screen_time_hours
)
SELECT MAX(Daily_screen_time_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.17

--  ** Gaming Hours Matrix ** --
SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';-- '2.023373'  2.02

SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Gaming_hours <> 0.00
        OR gender = 'Female'
        AND Gaming_hours <> ' ';--  2,458
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--  '1.1416227587510754'  1.14
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';  --  '1.3033025232984163'  1.30

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Female'
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  3.88

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  '2.039091'  2.04
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female'
        AND Gaming_hours <> 0.00
        AND Addicted_label = 1;--  1,725
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Female'
        AND Gaming_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Female'
        AND Gaming_hours <> ' ';--  1,725
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;--  '1.138022409688253' 1.14
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  --  '1.295095004952658'  1.30

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 1
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  3.88

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  '1.986317'  1.99
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female'
        AND Gaming_hours <> 0.00
        AND Addicted_label = 0;--  733
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Female'
        AND Gaming_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Female'
        AND Gaming_hours <> ' ';--  733
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;-- '1.1499950430935333'  1.15
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  --  '1.3224885991396975'  1.32

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 0
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  3.88

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';-- '2.008766' 2.01
--  SELECT COUNT(User_ID) FROM smartphone_project_staging WHERE Gender ='Female' AND Gaming_hours =  ' '; --  2,461
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Gaming_hours <> 0.00
        OR gender = 'Male' AND Gaming_hours <> ' ';--  2,552
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Gaming_hours <> 0.00
        OR gender = 'Male' AND Gaming_hours <> ' ';-- 2,552
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';-- '1.146954296759131' 1.15
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  --  '1.3155041588542329'  1.32

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Male'
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  3.95

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  '2.014561'  2.01
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Gaming_hours <> 0.00
        AND Addicted_label = 1;--  1,843
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Male'
        AND Gaming_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Male'
        AND Gaming_hours <> ' ';--  1,843
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;--  '1.1529981546149686'  1.15
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  --  '1.3294047445455228' 1.33

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 1
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  1.81

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--  '1.993695'  1.99
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Gaming_hours <> 0.00
        AND Addicted_label = 0;--  709
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Male'
        AND Gaming_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Male'
        AND Gaming_hours <> ' ';--  709
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;--  '1.1317520030113108' 1.13
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  -- '1.2808625963201141'  1.28

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 0
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  2.47

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';-- '2.010648' 2.01
--  SELECT COUNT(User_ID) FROM smartphone_project_staging WHERE Gender ='Other' AND Gaming_hours =  ' '; --  2,461
SELECT 
    *
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Gaming_hours <> 0.00
        OR gender = 'Other' AND Gaming_hours <> ' ';--  2,484
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Gaming_hours <> 0.00
        OR gender = 'Other' AND Gaming_hours <> ' ';-- 2,484
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';-- '1.1498621485606682'  1.15
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';  --  '1.3155041588542329'  1.32

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Other'
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  2.65

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;-- '2.008093'    2.01
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other'
        AND Gaming_hours <> 0.00
        AND Addicted_label = 1;--  1734
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Other'
        AND Gaming_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Other'
        AND Gaming_hours <> ' ';--  1,734
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;-- '1.1523162962564348'   1.15
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  -- '1.3278328466181477'  1.33

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 1
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  3.13

SELECT 
    AVG(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;--  '2.016560'  2.02
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other'
        AND Gaming_hours <> 0.00
        AND Addicted_label = 0;--  750
SELECT 
    COUNT(Gaming_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Other'
        AND Gaming_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Other'
        AND Gaming_hours <> ' ';--  750
SELECT 
    STDDEV_SAMP(Gaming_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;-- '1.1449063632050192' 1.14
SELECT 
    VAR_SAMP(Gaming_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  -- '1.3108105805073431'  1.31

WITH FrequencyCTE AS (
    SELECT 
        Gaming_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 0
    GROUP BY Gaming_hours
)
SELECT MAX(Gaming_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  1.68

-- ** Social Media Hours Matrix ** --
SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  '3.261682' 3.26
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  2,461
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Social_media_hours <> 0.00
        OR gender = 'Female'
        AND Social_media_hours <> ' ';-- 2,461
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--  '1.5932076908375492' 1`.59
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';  --  '2.538310746143916'  2.54

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Female'
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 4.59

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  '3.675845'  3.68
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  1,728
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Female'
        AND Social_media_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Female'
        AND Social_media_hours <> ' ';--  1,728
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;--  '1.6102371845911232'  1.61
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  --  '2.5928637906399468' 2.59

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 1
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  4.59

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  '2.285321'  2.29
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  733
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Female'
        AND Social_media_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Female'
        AND Social_media_hours <> ' ';--  733
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;-- '1.0264319929474564'  1.03
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  --  '1.053562636146087' 1.05

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 0
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  1.58

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  '3.300591' 3.30
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  2,553
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
        AND Social_media_hours <> 0.00
        OR gender = 'Male'
        AND Social_media_hours <> ' ';-- 2,553
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--  '1.5683630633963914'  1.57
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  --  '2.4597626986261134'  2.46

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Male'
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 2.70

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  '3.699582'  3.70
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  1,844
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Male'
        AND Social_media_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Male'
        AND Social_media_hours <> ' ';--  1,844
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;-- '1.564237913094831'  1.56
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  -- '2.446840248763272'  2.45

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 1
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.61

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--  '2.262877' 2.26
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--  709
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Male'
        AND Social_media_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Male'
        AND Social_media_hours <> ' ';--  709
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;-- '1.0019383264765913' 1.00
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  -- '1.0038804100627123' 1.00

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 0
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  2.70

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';-- '3.257329'  3.26
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  2,486
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Social_media_hours <> 0.00
        OR gender = 'Other'
        AND Social_media_hours <> ' ';-- 2,486
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--  '1.5951219231253315'  1.60
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';  --  '2.544413949635056' 2.54

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Other'
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 3.54

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;--  '3.710657'  3.71
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;-- 1,736 
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Other'
        AND Social_media_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Other'
        AND Social_media_hours <> ' ';--  1,736
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;-- '1.58173975850044' 1.58
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  -- '2.5019006636210306' 2.50

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 1
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 5.81

SELECT 
    AVG(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;-- '2.208027' 2.21
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;-- 750
SELECT 
    COUNT(Social_media_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Other'
        AND Social_media_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Other'
        AND Social_media_hours <> ' ';--  750
SELECT 
    STDDEV_SAMP(Social_media_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;-- '1.0331850759457857'  1.03
SELECT 
    VAR_SAMP(Social_media_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  -- '1.067471401157099'  1.07

WITH FrequencyCTE AS (
    SELECT 
        Social_media_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 0
    GROUP BY Social_media_hours
)
SELECT MAX(Social_media_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  3.54

-- ** Weekend Screen Time Hours ** --
SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  9.19
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  2,461
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Weekend_screen_time <> 0.00
        OR gender = 'Female'
        AND Weekend_screen_time <> ' ';-- 2,461
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';--  '2.72623778642451'  2.73
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';  --  '7.432372468128812' 7.43

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Female'
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  6.08

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  '10.163652'  10.16
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;-- 1,728
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Female'
        AND Weekend_screen_time <> 0.00
        OR Addicted_label = 1 AND gender = 'Female'
        AND Weekend_screen_time <> ' ';--  1,728
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;--  '2.521418252649055' 2.52
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  --  '6.357550004791814'

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 1
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  11.92

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  '6.883656' 6.88
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;-- 733
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Female'
        AND Weekend_screen_time <> 0.00
        OR Addicted_label = 0 AND gender = 'Female'
        AND Weekend_screen_time <> ' ';--  733
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;-- '1.5537038425256726'  1.55
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  -- '2.41399563027904'  2.41

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 0
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  7.25

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  '9.316107' 9.32
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  2,553
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
        AND Weekend_screen_time <> 0.00
        OR gender = 'Male'
        AND Weekend_screen_time <> ' ';-- 2,553
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';--  '2.720396581807916' 2.72
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  --  '7.400557562312194' 7.40

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Male'
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 12.22

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  '10.263004' 10.26
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;-- 1,844 
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Male'
        AND Weekend_screen_time <> 0.00
        OR Addicted_label = 1 AND gender = 'Male'
        AND Weekend_screen_time <> ' ';--  1,844
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;--  '2.466566979010574' 2.47
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  -- '6.08395266194535'  6.08

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 1
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 12.22

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;-- '6.853371'
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;-- 709 
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Male'
        AND Weekend_screen_time <> 0.00
        OR Addicted_label = 0 AND gender = 'Male'
        AND Weekend_screen_time <> ' ';--  709
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;-- '1.5586495691582194' 1.56
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  -- '2.4293884794371032' 2.43

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 0
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 7.57

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  '9.226134' 9.23
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  2,486
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Weekend_screen_time <> 0.00
        OR gender = 'Other'
        AND Weekend_screen_time <> ' ';-- 2,486
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';--  '2.707653312225504'  2.71
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';  --  '7.331386459205745'  7.33

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Other'
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 12.46

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;--  '10.212045' 10.21
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;--  1,736 
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Other'
        AND Weekend_screen_time <> 0.00
        OR Addicted_label = 1 AND gender = 'Other'
        AND Weekend_screen_time <> ' ';--  1,736
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;-- '2.506870195873709'  2.51
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  -- '6.284398178959887' 6.28

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 1
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 12.46

SELECT 
    AVG(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;--  '6.944080'  6.94
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;--  750
SELECT 
    COUNT(Weekend_screen_time)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Other'
        AND Weekend_screen_time <> 0.00
        OR Addicted_label = 0 AND gender = 'Other'
        AND Weekend_screen_time <> ' ';--  750
SELECT 
    STDDEV_SAMP(Weekend_screen_time) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;-- 1.52
SELECT 
    VAR_SAMP(Weekend_screen_time) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  -- '2.2988108347129503'  2.30

WITH FrequencyCTE AS (
    SELECT 
        Weekend_screen_time, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 0
    GROUP BY Weekend_screen_time
)
SELECT MAX(Weekend_screen_time) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 7.66

-- ** Work Study Hours Matrix ** --
SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  '3.271284'  3.27
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  2,461
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Work_study_hours <> 0.00
        OR gender = 'Female'
        AND Gaming_hours <> ' ';--  2,461
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';-- '1.6142785574873943' 1.61
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';  --  '2.605895261163583'

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Female'
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.42

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  '3.265307'  3.27
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;-- 1,728
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Female'
        AND Work_study_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Female'
        AND Work_study_hours <> ' ';--  1,728
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;--  '1.6113870343733947'
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  --  '2.596568174546684' 2.60

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 1
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 3.07 

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  '3.285375'  3.29
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;-- 733
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Female'
        AND Work_study_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Female'
        AND Work_study_hours <> ' ';--  733
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;--  '1.6220904266483374' 1.62
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  -- '2.6311773522241855' 2.63

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 0
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 5.68

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  '3.206631' 3.21
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  2,553
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male'
        AND Work_study_hours <> 0.00
        OR gender = 'Male' AND Gaming_hours <> ' ';--  2,553
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';-- '1.586971745861671' 1.59
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  --  '2.5184793221632398'

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Male'
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  4.64

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  '3.213292'
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;-- 1,844
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Male'
        AND Work_study_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Male'
        AND Work_study_hours <> ' ';--  1,844
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;--  '1.5807458762398943'
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  --  '2.498757525249431'  2.50

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 1
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 1.35

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--  '3.189309'
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;-- 709
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Male'
        AND Work_study_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Male'
        AND Work_study_hours <> ' ';-- 709
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;--  '1.6040443946448473' 1.60
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  --  '2.5729584199915547'

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 0
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 5.27

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  '3.250599'  3.25
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  2,486
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other'
        AND Work_study_hours <> 0.00
        OR gender = 'Other' AND Gaming_hours <> ' ';--  2,486
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';-- '1.6013892116618482'  1.60
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';  --  '2.564447407226956'  2.56

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Other'
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.88

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;--  '3.254050'  3.25
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;-- 1,736
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Other'
        AND Work_study_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Other'
        AND Work_study_hours <> ' ';--  1,736
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;--  '1.606609624380648'  1.61
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  --  '2.581194485152527' 2.58

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 1
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 5.88

SELECT 
    AVG(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;--  '3.242613' 3.24
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;-- 750
SELECT 
    COUNT(Work_study_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Other'
        AND Work_study_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Other'
        AND Work_study_hours <> ' ';--  750
SELECT 
    STDDEV_SAMP(Work_study_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;--  '1.5902787446870088'  1.59
SELECT 
    VAR_SAMP(Work_study_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  --  '2.5289864858032884'  2.53

WITH FrequencyCTE AS (
    SELECT 
        Work_study_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 0
    GROUP BY Work_study_hours
)
SELECT MAX(Work_study_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 0.98

--  ** Sleep Hours Matrix ** --
SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  '6.752056' 6.75
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female';--  2,461
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Female'
        AND Sleep_hours <> 0.00
        OR gender = 'Female' AND Sleep_hours <> ' ';--  2,461
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';-- '1.2875020240352981'  1.29
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female';  --  '1.6576614618949892' 1.66

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Female'
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  5.94

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;--  '6.769028'  6.77
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 1;-- 1,728
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Female'
        AND Sleep_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Female'
        AND Sleep_hours <> ' ';--  1,728
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;--  '1.2916380587202474' 1.29
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 1;  --  '1.6683288747346094'  1.67

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 1
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 6.38

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;--  '6.712046'  6.71
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Female' AND Addicted_label = 0;-- 733
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Female'
        AND Sleep_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Female'
        AND Sleep_hours <> ' ';--  733
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;--  '1.2776836807322276' 1.28
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Female' AND Addicted_label = 0;  --  '1.632475588009453' 1.63

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Female'AND Addicted_label = 0
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 8.73

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  '6.786686' 6.79
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male';--  2,553
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Sleep_hours <> 0.00
        OR gender = 'Male' AND Sleep_hours <> ' ';--  2,553
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';-- '1.276870526242425'  1.28
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male';  --  '1.6303983407866072' 1.63

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Male'
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  6.76

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;--  '6.829680' 6.83
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 1;-- 1,844
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Male'
        AND Sleep_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Male'
        AND Sleep_hours <> ' ';--  1,844
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;--  '1.2761073114916848'  1.28
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 1;  --  '1.6284498704425356' 1.63

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 1
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- '7.38'

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;--  '6.674866' 6.67
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Male' AND Addicted_label = 0;-- 709
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Male'
        AND Sleep_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Male'
        AND Sleep_hours <> ' ';--  709
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;--  '1.2729640398338733'  1.27
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Male' AND Addicted_label = 0;  --  '1.6204374467101748' 1.62

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Male'AND Addicted_label = 0
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 4.89

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  '6.672763'  6.67
SELECT 
    COUNT(User_ID)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other';--  2,486
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Sleep_hours <> 0.00
        OR gender = 'Other' AND Sleep_hours <> ' ';--  2,486
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';-- '1.2844721163479882'  1.28
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other';  --  '1.6498686176754798'  1.65

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
        WHERE gender = 'Other'
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);--  8.78

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;-- '6.697909'  6.70
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 1;-- 1,736
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 1 AND gender = 'Other'
        AND Sleep_hours <> 0.00
        OR Addicted_label = 1 AND gender = 'Other'
        AND Sleep_hours <> ' ';--  1,736
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;--  '1.2826917638950366'
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 1;  --  '1.6452981611641602'

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 1
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 8.78

SELECT 
    AVG(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;-- '6.614560'
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Gender = 'Other' AND Addicted_label = 0;-- 750
SELECT 
    COUNT(Sleep_hours)
FROM
    smartphone_project_staging
WHERE
    Addicted_label = 0 AND gender = 'Other'
        AND Sleep_hours <> 0.00
        OR Addicted_label = 0 AND gender = 'Other'
        AND Sleep_hours <> ' ';--  750
SELECT 
    STDDEV_SAMP(Sleep_hours) AS sample_std_dev
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;--  '1.2875561376020217'
SELECT 
    VAR_SAMP(Sleep_hours) AS sample_variance
FROM
    smartphone_project_staging
WHERE
    gender = 'Other' AND Addicted_label = 0;  --  '1.6578008074766364'  1.66

WITH FrequencyCTE AS (
    SELECT 
        Sleep_hours, 
        COUNT(*) AS frequency
    FROM smartphone_project_staging
    WHERE gender = 'Other'AND Addicted_label = 0
    GROUP BY Sleep_hours
)
SELECT MAX(Sleep_hours) AS mode_value
FROM FrequencyCTE
WHERE frequency = (SELECT MAX(frequency) FROM FrequencyCTE);-- 4.63

--  ********************************************************************************************************************************************
--  **                                                                      End of File                                                       **
--  ********************************************************************************************************************************************
