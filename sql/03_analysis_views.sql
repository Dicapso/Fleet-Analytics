-- Fleet Analytics - KPI views consumed by the Power BI report.

USE FleetAnalytics;
GO

-- Per-vehicle summary: distance driven, fuel spend, fuel efficiency, maintenance cost.
CREATE OR ALTER VIEW dbo.vw_VehicleSummary AS
SELECT
    v.vehicle_id,
    v.plate_number,
    v.make,
    v.model,
    v.fuel_type,
    v.home_city,
    ISNULL(t.total_distance_km, 0)          AS total_distance_km,
    ISNULL(t.trip_count, 0)                 AS trip_count,
    ISNULL(f.total_liters, 0)               AS total_liters,
    ISNULL(f.total_fuel_cost_azn, 0)        AS total_fuel_cost_azn,
    CASE WHEN ISNULL(f.total_liters, 0) = 0 THEN NULL
         ELSE ROUND(ISNULL(t.total_distance_km, 0) / f.total_liters, 2)
    END                                      AS km_per_liter,
    ISNULL(m.total_maintenance_cost_azn, 0) AS total_maintenance_cost_azn,
    ISNULL(m.total_downtime_hours, 0)       AS total_downtime_hours
FROM dbo.Vehicles v
LEFT JOIN (
    SELECT vehicle_id, SUM(distance_km) AS total_distance_km, COUNT(*) AS trip_count
    FROM dbo.Trips GROUP BY vehicle_id
) t ON t.vehicle_id = v.vehicle_id
LEFT JOIN (
    SELECT vehicle_id, SUM(liters) AS total_liters, SUM(total_cost_azn) AS total_fuel_cost_azn
    FROM dbo.FuelLogs GROUP BY vehicle_id
) f ON f.vehicle_id = v.vehicle_id
LEFT JOIN (
    SELECT vehicle_id, SUM(cost_azn) AS total_maintenance_cost_azn, SUM(downtime_hours) AS total_downtime_hours
    FROM dbo.Maintenance GROUP BY vehicle_id
) m ON m.vehicle_id = v.vehicle_id;
GO

-- Monthly fleet-wide trend: distance, fuel cost, maintenance cost.
CREATE OR ALTER VIEW dbo.vw_MonthlyTrend AS
SELECT
    FORMAT(month_start, 'yyyy-MM') AS year_month,
    SUM(distance_km)               AS total_distance_km,
    SUM(fuel_cost_azn)             AS total_fuel_cost_azn,
    SUM(maintenance_cost_azn)      AS total_maintenance_cost_azn
FROM (
    SELECT DATEFROMPARTS(YEAR(trip_date), MONTH(trip_date), 1) AS month_start,
           distance_km, 0 AS fuel_cost_azn, 0 AS maintenance_cost_azn
    FROM dbo.Trips
    UNION ALL
    SELECT DATEFROMPARTS(YEAR(log_date), MONTH(log_date), 1), 0, total_cost_azn, 0
    FROM dbo.FuelLogs
    UNION ALL
    SELECT DATEFROMPARTS(YEAR(service_date), MONTH(service_date), 1), 0, 0, cost_azn
    FROM dbo.Maintenance
) x
GROUP BY month_start;
GO

-- Driver activity: trips, distance, average trip length.
CREATE OR ALTER VIEW dbo.vw_DriverSummary AS
SELECT
    d.driver_id,
    d.full_name,
    d.home_city,
    COUNT(t.trip_id)                          AS trip_count,
    ISNULL(SUM(t.distance_km), 0)             AS total_distance_km,
    CASE WHEN COUNT(t.trip_id) = 0 THEN NULL
         ELSE ROUND(SUM(t.distance_km) / COUNT(t.trip_id), 1)
    END                                        AS avg_trip_km
FROM dbo.Drivers d
LEFT JOIN dbo.Trips t ON t.driver_id = d.driver_id
GROUP BY d.driver_id, d.full_name, d.home_city;
GO

-- Maintenance cost by service type - highlights the biggest cost drivers.
CREATE OR ALTER VIEW dbo.vw_MaintenanceByType AS
SELECT
    service_type,
    COUNT(*)              AS service_count,
    SUM(cost_azn)          AS total_cost_azn,
    AVG(downtime_hours)    AS avg_downtime_hours
FROM dbo.Maintenance
GROUP BY service_type;
GO
