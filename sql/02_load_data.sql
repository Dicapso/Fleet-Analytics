-- Fleet Analytics - load the generated CSVs into SQL Server.
-- Adjust the file path to wherever you cloned the repo before running.

USE FleetAnalytics;
GO

BULK INSERT dbo.Vehicles
FROM 'C:\path\to\Fleet-Analytics\data\vehicles.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
GO

BULK INSERT dbo.Drivers
FROM 'C:\path\to\Fleet-Analytics\data\drivers.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
GO

BULK INSERT dbo.Trips
FROM 'C:\path\to\Fleet-Analytics\data\trips.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
GO

BULK INSERT dbo.Maintenance
FROM 'C:\path\to\Fleet-Analytics\data\maintenance.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
GO

BULK INSERT dbo.FuelLogs
FROM 'C:\path\to\Fleet-Analytics\data\fuel_logs.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
GO
