-- 1. first choose db/schema that you want
-- use database ...
-- use schema ...


-- 2. create table 
-- transient - just for datathon, variant - to store json data
create or replace TRANSIENT TABLE SOURCE ( PAYLOAD VARIANT );


-- 3. import data (e.g. you can use Snowflake classic console)
-- https://docs.snowflake.com/en/user-guide/data-load-web-ui.html
-- use JSON as an input format
-- you can load all fetched gzipped json files at once


-- 4. sample view to parse source json data
create or replace view PARSED(
	INCIDENT,
	CREATEDATE,
	DISTRICT,
	LAT,
	LON,
	NUMBER_TXT,
	STREET,
	STREET2,
	HOUSENUMBER,
	CITY,
	SOURCETYPE,
	CASEID,
	CATEGORYNAME,
	SUBCATEGORYNAME,
	DEVICETYPE,
	EVENTNAME,
	STATUS
) as
with parsed as (
 SELECT --s.payload:"result":"success"::BOOLEAN success,
        --s.payload:"result":"result",
        --s.payload:"result":"result":"message",
        --s.payload:"result":"result":"totalRecords"::NUMBER,
        --s.payload:"result":"result":"result",
        f.value incident,
  incident:"createDate"::DATETIME createDate,
  incident:"district" district,
  incident:"lat"::DOUBLE lat,
  incident:"lon"::DOUBLE lon,
  incident:"number" number_txt,
  incident:"street" street,
  incident:"street2" street2,
  incident:"houseNumber" houseNumber,
  incident:"city" city,
  incident:"sourceType" sourceType,
  incident:"caseId" caseId,
  incident:"categoryName" categoryName,
  incident:"subcategoryName" subcategoryName,
  incident:"deviceType" deviceType,
  incident:"eventName" eventName,
  incident:"status" status
 FROM source s,
 lateral flatten( input => s.payload:"result":"result":"result") f
)
SELECT *
FROM parsed;
