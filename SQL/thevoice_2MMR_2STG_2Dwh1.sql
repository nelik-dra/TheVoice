set nocount on
use [master] 
go 


--אם עוד אין בסיס נתונים כזה יש לייצר אותו
if not EXISTS
	(select NULL from sys.databases where name='TheVoice_MRR_STG_DWH')
	CREATE DATABASE [TheVoice_MRR_STG_DWH]
	collate Hebrew_CI_AS
go 



--*****************Integration*********************


Use thevoice_Mrr_Stg_DWH

DECLARE @sql nvarchar(max)=
		''SELECT @sql += ' Drop table ' + 
		QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U' and s.name = 'Integration'

Exec sp_executesql @sql



IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Integration')) 
BEGIN
    EXEC ('CREATE SCHEMA [INTEGRATION] AUTHORIZATION [dbo]')
END


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [INTEGRATION].[Lineage](
	[Lineage_Key] [int] NOT NULL IDENTITY,
	[Data_Load_Started] [datetime2](7) NOT NULL,
	[Table_Name] [sysname] NOT NULL,
	[Computer_Name] [sysname] NOT NULL,
	[User_Name] [sysname] NOT NULL,
	[Package_Name] [sysname] NOT NULL,
	[Data Load Completed] [datetime2](7) NULL,
	[Was Successful] [bit] NOT NULL,
	--[Source System Cutoff Time] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Integration_Lineage] PRIMARY KEY CLUSTERED 
(
	[Lineage_Key] ASC
))
GO






--***************** MRR ***********************************


DECLARE @sql nvarchar(max)=
		''SELECT @sql += ' Drop table ' + 
		QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U' and s.name = 'MRR'

Exec sp_executesql @sql
USE TheVoice_MRR_STG_DWH


IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MRR')) 
BEGIN
    EXEC ('CREATE SCHEMA [MRR] AUTHORIZATION [dbo]')
END

CREATE TABLE [MRR].[call_type](
	[call_type_code] [varchar](20) NULL,
	[call_type_desc] [varchar](100) NULL,
	[priceperminuter] [decimal](10, 2) NULL,
	[call_type] [varchar](50) NULL 
)


CREATE TABLE [MRR].[XXCOUNTRYPRE](
	[COUNTRY_CODE] [varchar](100) NOT NULL,
	[COUNTRY_PRE] [varchar](3) NULL
	)

	

CREATE TABLE [MRR].[countries](
	[COUNTRY_CODE] [varchar](100) NULL,
	[DESC] [varchar](100) NULL,
	[REGION] [varchar](100) NULL,
	[AREA] [varchar](100) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL
 
)

CREATE TABLE [MRR].[Package_Catalog](
	[PACKAGE_NUM] [int] NOT NULL,
	[createdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[status] [varchar](4) NULL,
	[pack_type] [varchar](10) NULL,
	[pack_desc] [varchar](100) NULL,
	[insert_date] [datetime] NULL,
	[update_date] [datetime] NULL
	
	)

CREATE TABLE [MRR].[OPFILEOPP](
	[OPCCC] [varchar](20) NULL,
	[OPDDD] [varchar](100) NULL,
	[prepre] [varchar](3) NULL
) 


CREATE TABLE [MRR].[customer_lines](
	[PHONE_NO] [varchar](20) NOT NULL,
	[createdate] [datetime] NOT NULL,
	[enddate] [datetime] NULL,
	[status] [varchar](4) NULL,
	[TYPE] [varchar](10) NULL,
	[DESC] [varchar](100) NULL,
	[insert_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[discountpct] [int] NULL,
	[numberoffreeminutes] [int] NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL
	)

	CREATE TABLE [MRR].[customer](
	[customer_id] [int] NOT NULL,
	[CUST_NUMBER] [varchar](20) NOT NULL,
	[cust_name] [varchar](100) NULL,
	[address] [varchar](100) NULL,
	[insert_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL
	)


CREATE TABLE [MRR].[USAGE_MAIN](
	[CALL_NO] [int] NOT NULL,
	[ANSWER_TIME] [datetime] NOT NULL,
	[SEIZED_TIME] [datetime] NOT NULL,
	[DISCONNECT_TIME] [datetime] NOT NULL,
	[CALL_DATETIME] [datetime] NULL,
	[CALLING_NO] [varchar](18) NULL,
	[CALLED_NO] [varchar](18) NULL,
	[DES_NO] [varchar](25) NULL,
	[DURATION] [int] NULL,
	[CUST_ID] [int] NULL,
	[CALL_TYPE] [varchar](20) NULL,
	[PROD_TYPE] [varchar](20) NULL,
	[RATED_AMNT] [int] NULL,
	[RATED_CURR_CODE] [varchar](10) NULL,
	[CELL] [int] NULL,
	[CELL_ORIGIN] [int] NULL,
	[HIGH_LOW_RATE] [int] NULL,
	[insert_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL

	)

 


CREATE TABLE [MRR].[CUSTOMER_INVOICE](
	[INVOICE_NUM] [int] NULL,
	[PHONE_NO] [varchar](20) NULL,
	[INVOICE_TYPE] [varchar](10) NULL,
	[INVOICE_DATE] [datetime] NULL,
	[INVOICE_IND] [tinyint] NULL,
	[INVOICE_DESC] [varchar](100) NULL,
	[INVOICE_CURRNCY] [varchar](10) NULL,
	[INVOICE_AMOUNT] [decimal](10, 4) NULL,
	[insert_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL
	)



--*****************************STAGE****************************

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




DECLARE @sql nvarchar(max)=
		''SELECT @sql += ' Drop table ' + 
		QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U' and s.name = 'STG'

Exec sp_executesql @sql


IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'STG')) 
BEGIN
    EXEC ('CREATE SCHEMA [STG] AUTHORIZATION [dbo]')
END


CREATE TABLE [STG].[countries](  
	
    [COUNTRY_CODE] varchar(100),
    [REGION] varchar(100),
    [AREA] varchar(100),
    )

CREATE TABLE [STG].[XXCOUNTRYPRE](
	[COUNTRY_CODE] [varchar](100) NOT NULL,
	[COUNTRY_PRE] [varchar](3) NULL
	)

CREATE TABLE [STG].[customer](
	[customer_id] int not null,
    [CUST_NUMBER] varchar(20)not null,
    [cust_name] varchar(100) null ,
    [address] varchar(100) null
   )




CREATE TABLE [STG].[customer_lines](
	[PHONE_NO] [varchar](20)  NULL,
	[TYPE] [varchar](10) NULL,
	[DESC] [varchar](100) NULL,
	[discountpct] [int] NULL,
	[numberoffreeminutes] [int] NULL
	)
 

Create table STG.Package_Catalog(
	PACKAGE_NUM int NOT NULL,
	pack_desc varchar(100) NULL,
	createdate datetime NULL,
	enddate datetime NULL,
	[status] varchar(4) NULL,
	[pack_type] [varchar](10) NULL,
)
    
CREATE   TABLE [STG].[USAGE_MAIN](
    CALL_NO int NOT NULL,
	ANSWER_TIME datetime NOT NULL,
	SEIZED_TIME datetime NOT NULL,
	CALL_DATETIME datetime NULL,
	CALLING_NO nvarchar(18) NULL,
	DES_NO nvarchar(25) NULL,
	DURATION int NULL,
	CUST_ID int NULL,
	CALL_TYPE nvarchar (20) NULL,
	PROD_TYPE nvarchar(20) NULL,
	RATED_AMNT int NULL,
	CELL_ORIGIN int NULL, 
	OriginCountry int NULL,
	DestinationCountry int null,
	OriginOperator int null,
	DestinationOperator int null,
	CallDate nvarchar(10) null,
	CallTime nvarchar(8) null
	Primary Key (CALL_NO)

)
 
---------


/*
CREATE TABLE [STG].[call_type] (
    KeyCallType int identity (1,1),
	call_type_code nvarchar(100) not NULL,
	call_type_desc nvarchar(100) NULL,
	priceperminuter decimal(10, 2) NULL,
	call_type nvarchar(50) NULL
	Primary Key (KeyCallType)
)
*/

CREATE TABLE [STG].[call_type] (
--	KeyCallType int identity (1,1),
   	DescCallTypeCode nvarchar(100) not NULL,
	DescCallType nvarchar(100) NULL,
	DescFullCallType nvarchar(100) NULL,
	DescCallTypePriceCategory nvarchar(100) NULL,
	DescCallTypeCategory nvarchar(100) NULL
--    Primary Key (KeyCallType)
)

CREATE TABLE [STG].[OPFILEOPP] (
    OPCCC nvarchar(100) NULL,
	OPDDD nvarchar(100) NULL,
	prepre nvarchar(100) NULL
)


--*******************************************************
--- טיפול בשלב ה- 
---DWH
--*********************************************************
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



DECLARE @sql nvarchar(max)=
		''SELECT @sql += ' Drop table ' + 
		QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U' and s.name = 'DWH'

Exec sp_executesql @sql

--יצירת הסכמה של ה- 
--DWH
IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'DWH')) 
BEGIN
    EXEC ('CREATE SCHEMA [DWH] AUTHORIZATION [dbo]')
END


	Create table DWH.DimCallOriginType
(
	SKeyCallOriginType int identity (100,1),
	KeyCallOriginType int,
	DescCallOriginType nvarchar(100),
	IsCurrent nvarchar(100),
	StartTime Datetime,
	Endtime Datetime
	Primary Key (SKeyCallOriginType)
)





Create table DWH.DimCallTypes
(
	SKeyCallType int identity (100,1),
	DescCallTypeCode nvarchar(100),
	DescCallType nvarchar(100),
	DescFullCallType nvarchar(200),
	DescCallTypePriceCategory nvarchar(100),
	DescCallTypeCategory nvarchar(100),
	IsCurrent nvarchar(100),
	StartTime Datetime,
	Endtime Datetime
	Primary Key (SKeyCallType)
)

	Create table DWH.DimCountries
(
	[SKeyCountry] [int] IDENTITY(100,1) NOT NULL,
	[KeyCountry] [int] NULL,
	[DescCountry] [nvarchar](100) NULL,
	[DescRegion] [nvarchar](100) NULL,
	[DescArea] [nvarchar](100) NULL
	Primary Key (SKeyCountry)
)


Create table DWH.DimCustomers
(
	SKeyCustomer int identity (100,1),
	KeyCustomer	int,
	DescCustomerLineOperator nvarchar(50),
	DescCustomerLineCountry nvarchar(100),
	DescCustomerName nvarchar(100),
	DescCustomerAddress nvarchar(100),
	DescCusomterPackage nvarchar(100),
	IsCurrent nvarchar(100),
	StartTime Datetime,
	Endtime Datetime
	Primary Key (SKeyCustomer)
	)


	Create table DWH.DimOperators
(
	SKeyOperator int identity (100,1),
	KeyOperator int,
	DescOperator nvarchar(50),
	DescKeyPrefix nvarchar(100),
	IsCurrent nvarchar(100),
	StartTime Datetime,
	Endtime Datetime
	Primary Key (SKeyOperator)
)
-----------

	Create table DWH.DimPackageCatalog
(
	SKeyPackage int identity (100,1),
	KeyPackage int,
	DescPackage nvarchar(120),
	DatePackageCreation date,
	DatePackageEnd date,
	DescPackageStatus nvarchar(100),
	CodePackageActivitiesDays int,
	IsCurrent nvarchar(100),
	StartTime Datetime,
	Endtime Datetime
	Primary Key (SKeyPackage)
)



Create table DWH.FactUsage
(
	CallId int,
	SKeyCustomer int,
	SKeyCallType int,
	SKeyOriginCountry int,
	SKeyDestinationCountry int,
	SKeyOriginOperator int,
	SKeyDestinationOperator int,
	SKeyPackage int,
	SKeyCallOriginType int,
	KeyCallDate int,
	KeyCallTime int,
	Duration int,
	BillableDuration int,
	Amount float,
	BillableAmount float
--	Primary Key (CallId)
)

create  table [DWH].dim_time (
TimeKey int ,
    TimeAltKey time(0) ,
    [HourOfDay] int,
    [MinuteOfHour] int,
    SecondOfMinute int,
    TimeString nvarchar(8)
	)


CREATE  TABLE	[DWH].[Dim_Date]
	(	[DateKey] INT primary key, 
		[Date] DATETIME,
		[FullDateUK] nvarchar(10), -- Date in dd-MM-yyyy format
		[FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
		[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
		[DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
		[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		[DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7
		[DayOfWeekUK] CHAR(1),-- First Day Monday=1 and Sunday=7
		[DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
		[DayOfWeekInYear] VARCHAR(2),
		[DayOfQuarter] VARCHAR(3),
		[DayOfYear] VARCHAR(3),
		[WeekOfMonth] VARCHAR(1),-- Week Number of Month 
		[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
		[WeekOfYear] VARCHAR(2),--Week Number of the Year
		[Month] VARCHAR(2), --Number of the Month 1 to 12
		[MonthName] VARCHAR(9),--January, February etc
		[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
		[Quarter] CHAR(1),
		[QuarterName] VARCHAR(9),--First,Second..
		[Year] CHAR(4),-- Year value of Date stored in Row
		[YearName] CHAR(7), --CY 2012,CY 2013
		[MonthYear] CHAR(10), --Jan-2013,Feb-2013
		[MMYYYY] CHAR(6),
		[FirstDayOfMonth] DATE,
		[LastDayOfMonth] DATE,
		[FirstDayOfQuarter] DATE,
		[LastDayOfQuarter] DATE,
		[FirstDayOfYear] DATE,
		[LastDayOfYear] DATE,
		[IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday
		[IsWeekdayStyle1] BIT,-- 0=Week End ,1=Week Day
		[IsWeekdayStyle2] BIT,-- 0=Week End ,1=Week Day
		[HolidayUSA] VARCHAR(50),--Name of Holiday in US
		[IsHolidayUK] BIT Null,-- Flag 1=National Holiday, 0-No National Holiday
		[HolidayUK] VARCHAR(50) Null --Name of Holiday in UK
	)



	/******************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = '01/01/2000' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2022' --End Value of Date Range

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
	@DayOfWeekInMonth INT,
	@DayOfWeekInYear INT,
	@DayOfQuarter INT,
	@WeekOfMonth INT,
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

--Extract and assign various parts of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
/*Begin day of week logic*/

         /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
	IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
	BEGIN
		UPDATE @DayOfWeek
		SET MonthCount = 0
		SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	END

        /* Check for Change in Quarter of the Current date if Quarter changed then change 
         Variable value*/

	IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET QuarterCount = 0
		SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
	END
       
        /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/
	

	IF @CurrentYear != DATEPART(YY, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET YearCount = 0
		SET @CurrentYear = DATEPART(YY, @CurrentDate)
	END
	
        -- Set values in table data type created above from variables 

	UPDATE @DayOfWeek
	SET 
		MonthCount = MonthCount + 1,
		QuarterCount = QuarterCount + 1,
		YearCount = YearCount + 1
	WHERE DOW = DATEPART(DW, @CurrentDate)

	SELECT
		@DayOfWeekInMonth = MonthCount,
		@DayOfQuarter = QuarterCount,
		@DayOfWeekInYear = YearCount
	FROM @DayOfWeek
	WHERE DOW = DATEPART(DW, @CurrentDate)
	
/*End day of week logic*/


/* Populate Your Dimension Table with values*/
	
	INSERT INTO [DWH].[Dim_Date]
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date,
		CONVERT (char(10),@CurrentDate,103) as FullDateUK,
		CONVERT (char(10),@CurrentDate,101) as FullDateUSA,
		DATEPART(DD, @CurrentDate) AS DayOfMonth,
		--Apply Suffix values like 1st, 2nd 3rd etc..
		CASE 
			WHEN DATEPART(DD,@CurrentDate) IN (11,12,13) 
			THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 1 
			THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'st'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 2 
			THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'nd'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 3 
			THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'rd'
			ELSE CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th' 
			END AS DaySuffix,
		
		DATENAME(DW, @CurrentDate) AS DayName,
		DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,

		-- check for day of week as Per US and change it as per UK format 
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 7
			WHEN 2 THEN 1
			WHEN 3 THEN 2
			WHEN 4 THEN 3
			WHEN 5 THEN 4
			WHEN 6 THEN 5
			WHEN 7 THEN 6
			END 
			AS DayOfWeekUK,
		
		@DayOfWeekInMonth AS DayOfWeekInMonth,
		@DayOfWeekInYear AS DayOfWeekInYear,
		@DayOfQuarter AS DayOfQuarter,
		DATEPART(DY, @CurrentDate) AS DayOfYear,
		DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR,
		DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR,
		DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
		(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0),
		@CurrentDate) / 7) + 1 AS WeekOfQuarter,
		DATEPART(WW, @CurrentDate) AS WeekOfYear,
		DATEPART(MM, @CurrentDate) AS Month,
		DATENAME(MM, @CurrentDate) AS MonthName,
		CASE
			WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
			WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
			WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
			END AS MonthOfQuarter,
		DATEPART(QQ, @CurrentDate) AS Quarter,
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS QuarterName,
		DATEPART(YEAR, @CurrentDate) AS Year,
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR,
		DATEPART(YY, @CurrentDate)) AS MonthYear,
		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) +
		CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD,
		@CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD,
		(DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1,
		@CurrentDate)))) AS LastDayOfMonth,
		DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
		DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
		CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY,
		@CurrentDate))) AS FirstDayOfYear,
		CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY,
		@CurrentDate))) AS LastDayOfYear,
		NULL AS IsHolidayUSA,
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END AS IsWeekdayStyle1,
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 1
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 0
			WHEN 7 THEN 0
			END AS IsWeekdayStyle2,
		NULL AS HolidayUSA, Null, Null

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END





--/*
--------------טיפול בטבלת זמן----------------------------------------------
set nocount on
--DS FIXED TIME TABLE
truncate table dwh.dim_time
--הכנסת ערכים לטבלת DIM_TIME
-------------------------------------------------
-- Declare and set variables for loop
Declare
@StartTime time(0),
@EndTime time(0),
@Time time(0),
@Interval int
Set @StartTime = '00:00:00'
Set @EndTime = '23:59:59'
Set @Time = @StartTime
Set @Interval = 1
-- Loop through Times
--86400 = מספר השניות ביום
while @Interval<= 86400
	BEGIN
	--מכניסה ערכים אל טבלת הזמנים  
		INSERT Into DWH.Dim_Time --with(rowlock)
	   (
		TimeKey,
		TimeAltKey,
		[HourOfDay],
		[MinuteOfHour],
		SecondOfMinute,
		TimeString
		)
		Values
		(
		@Interval,
		@Time,
		datename(hh,@Time),
		datename(minute,@time),
		datename(second,@time),
		CONVERT(varchar(8), @time)
		)
	
		Select @Time = Dateadd(ss,1, @Time)
		Select @Interval = @Interval + 1
	
	END

set nocount off







------ ***********************************************
--------הכנסת ערכים

----****************************************
---- from 09/10/2013 to 31/10/2013

--declare @num_Day_Calls int, @seizetdate datetime, @duration int ,@custOrig int,@custdest int,@numOfCustomers int,@ratedamnt int,@freeMin int,@ANSWER_TIME datetime,@DISCONNECT_TIME datetime,@CALL_DATETIME datetime
--DECLARE @CALL_TYPE varchar (10),@PROD_TYPE varchar(20),@CELL int, @CELL_ORIGIN int,@CALL_NO int,@CALLING_NO varchar(18) , @CALLED_NO varchar(18), @DES_NO varchar(25),@i int

--set @i=1
--select @CALL_NO=max(CALL_NO) from USAGE_MAIN
--while @i<=100000

--begin

--		set @CALL_NO=@CALL_NO +@i

--		select @CALL_NO=max(CALL_NO)+@i from USAGE_MAIN

--		set @num_Day_Calls= dbo.fn_rand (1,10)

--		select  @numOfCustomers= count(*) from customer

--		set @custOrig=dbo.fn_rand(1, @numOfCustomers)

--		set @custdest=dbo.fn_rand(1, @numOfCustomers)

--		if @custOrig=@custdest set @custdest=@custdest+1

--		set @duration = dbo.fn_rand(1,300)

--		select  @freeMin = numberoffreeminutes from customer_lines where PHONE_NO=(select CUST_NUMBER from customer where customer_id=@custOrig)

--		set @freeMin=ISNULL(@freemin,0)


--		set @ratedamnt=@duration - @freeMin

--		set @seizetdate = DATETIME2FROMPARTS(2013,datepart(mm,GETDATE()),datepart(dd,GETDATE()),datepart(HH,GETDATE()),datepart(MI,GETDATE()),datepart(SS,GETDATE()),0,1)
--		set @DISCONNECT_TIME = DATEADD(mi,@duration,@seizetdate)
--		set @ANSWER_TIME = @seizetdate
--		set @CALL_DATETIME = DATETIME2FROMPARTS(datepart(yyyy,GETDATE())-7,datepart(mm,GETDATE()),datepart(dd,GETDATE()),0,0,0,0,1)

--		SELECT TOP 1 @CALL_TYPE=call_type_code FROM call_type
--		ORDER BY NEWID()


--		select @CALLING_NO=CUST_NUMBER from customer where customer_id=@custOrig

--		select @CALLED_NO=CUST_NUMBER from customer where customer_id=@custdest

--		select @DES_NO=CUST_NUMBER from customer where customer_id=@custdest


--		SELECT @PROD_TYPE=call_type_desc FROM call_type WHERE call_type_code=@CALL_TYPE

--		set @CELL = dbo.fn_rand(0,1)

--		set @CELL_ORIGIN  = dbo.fn_rand(0,1)


--		INSERT INTO [dbo].[USAGE_MAIN]
--				   ([CALL_NO]
--				   ,[ANSWER_TIME]
--				   ,[SEIZED_TIME]
--				   ,[DISCONNECT_TIME]
--				   ,[CALL_DATETIME]
--				   ,[CALLING_NO]
--				   ,[CALLED_NO]
--				   ,[DES_NO]
--				   ,[DURATION]
--				   ,[CUST_ID]
--				   ,[CALL_TYPE]
--				   ,[PROD_TYPE]
--				   ,[RATED_AMNT]
--				   ,[RATED_CURR_CODE]
--				   ,[CELL]
--				   ,[CELL_ORIGIN]
--				   ,[HIGH_LOW_RATE]
--				   ,[insert_DATE]
--				   ,[update_date])
--			 VALUES 
--			 (@CALL_NO,
--			  @ANSWER_TIME,
--			  @seizetdate,
--			  @DISCONNECT_TIME,
--			  @CALL_DATETIME,
--			  @CALLING_NO,
--			  @CALLED_NO,
--			  @DES_NO,
--			  @duration,
--			  @custOrig,
--			  @CALL_TYPE,
--			  @PROD_TYPE,
--			  @ratedamnt,
--			  'SHEKEL',
--			  @CELL,
--			  @CELL_ORIGIN,
--			  1,
--			  getdate(),
--			  getdate()



--			 )

--set @i=@i+2
--end*/





--------------------END DIM