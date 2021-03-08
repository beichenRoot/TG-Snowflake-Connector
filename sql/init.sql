-- init.sql --


-- create database
CREATE DATABASE tg_spark COMMENT = 'data for snowflake-spark-TG connector dev & test';


-- switch database
use tg_spark;


-- create schema
CREATE SCHEMA synthea10k;


-- create file format & stage

CREATE OR REPLACE file format mycsvformat
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1;
  
CREATE or REPLACE stage my_csv_stage
  file_format = mycsvformat;

PUT file:///10k_synthea_covid19_csv/\*.csv @my_csv_stage auto_compress=true;


-- creata tables & load data
CREATE TABLE synthea10k.allergies(
	"START" date, 
	"STOP" date, 
	"PATIENT" varchar(36), 
	"ENCOUNTER" varchar(36), 
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.allergies
  FROM @my_csv_stage/allergies.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.careplans(
	"Id" varchar(36),
	"START" date, 
	"STOP" date, 
	"PATIENT" varchar(36), 
	"ENCOUNTER" varchar(36), 
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(64),
	"REASONCODE" varchar(20), 
	"REASONDESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.careplans
  FROM @my_csv_stage/careplans.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.conditions(
	"START" date, 
	"STOP" date, 
	"PATIENT" varchar(36), 
	"ENCOUNTER" varchar(36), 
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.conditions
  FROM @my_csv_stage/conditions.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.devices(
	"START" date, 
	"STOP" date, 
	"PATIENT" varchar(36), 
	"ENCOUNTER" varchar(36), 
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"UDI" varchar(128)
	);
COPY INTO synthea10k.devices
  FROM @my_csv_stage/devices.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.encounters(
	"Id" varchar(36),
	"START" timestamp, 
	"STOP" timestamp, 
	"PATIENT" varchar(36), 
	"ORGANIZATION" varchar(36), 
	"PROVIDER" varchar(36), 
	"PAYER" varchar(36), 
	"ENCOUNTERCLASS" varchar(36), 
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"BASE_ENCOUNTER_COST" float,
	"TOTAL_CLAIM_COST" float,
	"PAYER_COVERAGE" float,
	"REASONCODE" varchar(20), 
	"REASONDESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.encounters
  FROM @my_csv_stage/encounters.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.imaging_studies(
	"Id" varchar(36),
	"DATE" date,
	"PATIENT" varchar(36),
	"ENCOUNTER" varchar(36),
	"BODYSITE_CODE" varchar(20), 
	"BODYSITE_DESCRIPTION"  varchar(128),
	"MODALITY_CODE" varchar(20), 
	"MODALITY_DESCRIPTION"  varchar(128),
	"SOP_CODE" varchar(32), 
	"SOP_DESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.imaging_studies
  FROM @my_csv_stage/imaging_studies.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.immunizations(
	"DATE" date,
	"PATIENT" varchar(36),
	"ENCOUNTER" varchar(36),
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"BASE_COST" float
	);
COPY INTO synthea10k.immunizations
  FROM @my_csv_stage/immunizations.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';



CREATE TABLE synthea10k.medications(
	"START" date, 
	"STOP" date, 
	"PATIENT" varchar(36), 
	"PAYER" varchar(36), 
	"ENCOUNTER" varchar(36),
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"BASE_COST" float,
	"PAYER_COVERAGE" float,
	"DISPENSES" int,
	"TOTALCOST" float,
	"REASONCODE" varchar(20), 
	"REASONDESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.medications
  FROM @my_csv_stage/medications.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.observations(
	"DATE" date,
	"PATIENT" varchar(36),
	"ENCOUNTER" varchar(36),
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"VALUE" varchar(64),
	"UNITS" varchar(16),
	"TYPE" varchar(7)
	);
COPY INTO synthea10k.observations
  FROM @my_csv_stage/observations.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.organizations(
	"Id" varchar(36),
	"NAME" varchar(70),
	"ADDRESS" varchar(50),
	"CITY" varchar(20),
	"STATE" varchar(2),
	"ZIP" varchar(10),
	"LAT" float,
	"LON" float,
	"PHONE" varchar(40), 
	"REVENUE" int,
	"UTILIZATION" int
	);
COPY INTO synthea10k.organizations
  FROM @my_csv_stage/organizations.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.patients(
	"Id" varchar(36),
	"BIRTHDATE" date,
	"DEATHDATE" date,
	"SSN" varchar(11),
	"DRIVERS" varchar(9),
	"PASSPORT" varchar(10),
	"PREFIX" varchar(4),
	"FIRST" varchar(18),
	"LAST" varchar(16),
	"SUFFIX" varchar(3),
	"MAIDEN" varchar(16), 
	"MARITAL" varchar(3),
	"RACE" varchar(6),
	"ETHNICITY" varchar(11),
	"GENDER" varchar(1),
	"BIRTHPLACE" varchar(80),
	"ADDRESS" varchar(40),
	"CITY" varchar(21),
	"STATE" varchar(13),
	"COUNTY" varchar(17),
	"ZIP" varchar(10),
	"LAT" float,
	"LON" float,
	"HEALTHCARE_EXPENSES" float,
	"HEALTHCARE_COVERAGE" float
	);
COPY INTO synthea10k.patients
  FROM @my_csv_stage/patients.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.payer_transitions(
	"PATIENT" varchar(36),
	"START_YEAR" varchar(4),
	"END_YEAR" varchar(4),
	"PAYER" varchar(36),
	"OWNERSHIP" varchar(16)
	);
COPY INTO synthea10k.payer_transitions
  FROM @my_csv_stage/payer_transitions.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.payers(
	"Id" varchar(36),
	"NAME" varchar(70),
	"ADDRESS" varchar(50),
	"CITY" varchar(20),
	"STATE_HEADQUARTERED" varchar(2),
	"ZIP" varchar(10),
	"PHONE" varchar(40), 
	"AMOUNT_COVERED" float,
	"AMOUNT_UNCOVERED" float,
	"REVENUE" float,
	"COVERED_ENCOUNTERS" int,
	"UNCOVERED_ENCOUNTERS" int,
	"COVERED_MEDICATIONS" int,
	"UNCOVERED_MEDICATIONS" int,
	"COVERED_PROCEDURES" int,
	"UNCOVERED_PROCEDURES" int,
	"COVERED_IMMUNIZATIONS" int,
	"UNCOVERED_IMMUNIZATIONS" int,
	"UNIQUE_CUSTOMERS" int,
	"QOLS_AVG" float,
	"MEMBER_MONTHS" int
	);
COPY INTO synthea10k.payers
  FROM @my_csv_stage/payers.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.procedures(
	"DATE" date, 
	"PATIENT" varchar(36), 
	"ENCOUNTER" varchar(36),
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"BASE_COST" float,
	"REASONCODE" varchar(20), 
	"REASONDESCRIPTION" varchar(128)
	);
COPY INTO synthea10k.procedures
  FROM @my_csv_stage/procedures.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.providers(
	"Id" varchar(36),
	"ORGANIZATION" varchar(36), 
	"NAME" varchar(70),
	"GENDER" varchar(1),
	"SPECIALITY" varchar(64),
	"ADDRESS" varchar(50),
	"CITY" varchar(20),
	"STATE" varchar(2),
	"ZIP" varchar(10),
	"LAT" float,
	"LON" float,
	"UTILIZATION" int
	);
COPY INTO synthea10k.providers
  FROM @my_csv_stage/providers.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';


CREATE TABLE synthea10k.supplies(
	"DATE" date, 
	"PATIENT" varchar(36), 
	"ENCOUNTER" varchar(36),
	"CODE" varchar(20), 
	"DESCRIPTION" varchar(128),
	"QUANTITY" int
	);
COPY INTO synthea10k.supplies
  FROM @my_csv_stage/supplies.csv.gz
  file_format = (format_name = mycsvformat)
  on_error = 'skip_file';
