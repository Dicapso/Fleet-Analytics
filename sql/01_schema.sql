-- Fleet Analytics - database schema (Microsoft SQL Server)
-- Run this first to create the database and tables.

CREATE DATABASE FleetAnalytics;
GO

USE FleetAnalytics;
GO

CREATE TABLE dbo.Vehicles (
    vehicle_id          INT PRIMARY KEY,
    plate_number        VARCHAR(20) NOT NULL,
    make                VARCHAR(50) NOT NULL,
    model                VARCHAR(50) NOT NULL,
    [year]               SMALLINT NOT NULL,
    fuel_type           VARCHAR(20) NOT NULL,
    purchase_date        DATE NOT NULL,
    home_city           VARCHAR(50) NOT NULL,
    odometer_start_km    INT NOT NULL
);
GO

CREATE TABLE dbo.Drivers (
    driver_id     INT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    license_no    VARCHAR(20) NOT NULL,
    hire_date     DATE NOT NULL,
    home_city     VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Trips (
    trip_id            INT PRIMARY KEY,
    vehicle_id         INT NOT NULL REFERENCES dbo.Vehicles(vehicle_id),
    driver_id          INT NOT NULL REFERENCES dbo.Drivers(driver_id),
    trip_date          DATE NOT NULL,
    origin_city        VARCHAR(50) NOT NULL,
    destination_city   VARCHAR(50) NOT NULL,
    distance_km        DECIMAL(6,1) NOT NULL,
    duration_min       INT NOT NULL
);
GO

CREATE TABLE dbo.Maintenance (
    maintenance_id   INT PRIMARY KEY,
    vehicle_id       INT NOT NULL REFERENCES dbo.Vehicles(vehicle_id),
    service_date      DATE NOT NULL,
    service_type      VARCHAR(50) NOT NULL,
    cost_azn         DECIMAL(8,2) NOT NULL,
    downtime_hours    DECIMAL(5,1) NOT NULL
);
GO

CREATE TABLE dbo.FuelLogs (
    fuel_log_id           INT PRIMARY KEY,
    vehicle_id            INT NOT NULL REFERENCES dbo.Vehicles(vehicle_id),
    log_date              DATE NOT NULL,
    liters                DECIMAL(6,1) NOT NULL,
    price_per_liter_azn   DECIMAL(5,2) NOT NULL,
    total_cost_azn        DECIMAL(8,2) NOT NULL,
    odometer_km           INT NOT NULL
);
GO
