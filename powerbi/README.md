# Power BI Report — Build Guide

A `.pbix` file is a binary format that only Power BI Desktop can produce, so it
isn't included as a file in this repo — instead this guide gets you from the
data in `/data` (or `/sql`) to a finished report in about 15 minutes.

## 1. Get data

Power BI Desktop → **Get Data** → **Folder**, point at `/data`, and load the
five CSVs (`vehicles`, `drivers`, `trips`, `maintenance`, `fuel_logs`) as
separate tables — or **Get Data → SQL Server** and connect to the
`FleetAnalytics` database created by the scripts in `/sql`.

## 2. Add a Date table

**Modeling → New table**:

```
Date = CALENDAR(DATE(2025,1,1), DATE(2025,12,31))
```

Mark it as a date table (**Table tools → Mark as date table**), and add
`Month`, `MonthName`, `Quarter` calculated columns for slicers.

## 3. Relationships (Model view)

| From | To | Type |
|---|---|---|
| Trips[vehicle_id] | Vehicles[vehicle_id] | many-to-one |
| Trips[driver_id] | Drivers[driver_id] | many-to-one |
| FuelLogs[vehicle_id] | Vehicles[vehicle_id] | many-to-one |
| Maintenance[vehicle_id] | Vehicles[vehicle_id] | many-to-one |
| Trips[trip_date] | Date[Date] | many-to-one |
| FuelLogs[log_date] | Date[Date] | many-to-one |
| Maintenance[service_date] | Date[Date] | many-to-one |

This is a star schema: `Vehicles` and `Drivers` are dimensions, `Trips`,
`FuelLogs` and `Maintenance` are fact tables, all filtered through `Date`.

## 4. Measures

Add every measure in [`measures.dax`](measures.dax) (**Modeling → New
measure**, paste one at a time).

## 5. Report pages

**Page 1 — Fleet Overview**
- KPI cards: `Total Distance (km)`, `Total Fuel Cost (AZN)`, `Total Maintenance Cost (AZN)`, `Avg Fuel Efficiency (km/L)`
- Line chart: `Total Operating Cost (AZN)` by `Date[Month]`
- Map or bar chart: `Total Distance (km)` by `Vehicles[home_city]`
- Slicers: `Date[Month]`, `Vehicles[fuel_type]`

**Page 2 — Vehicle Performance**
- Table: `vw_VehicleSummary` columns (plate_number, make/model, km_per_liter, total_maintenance_cost_azn)
- Bar chart: `Avg Fuel Efficiency (km/L)` by vehicle, sorted descending
- Bar chart: `Total Maintenance Cost (AZN)` by `Maintenance[service_type]`
- Scatter chart: `Total Distance (km)` vs `Total Maintenance Cost (AZN)` per vehicle

**Page 3 — Drivers**
- Table: driver, trip count, total distance, avg trip length
- Bar chart: `Total Trips` by driver
- Card: driver with highest `Avg Trip Length (km)`

## 6. Publish

Save as `FleetAnalytics.pbix`, then either keep it locally next to this repo
or publish to the Power BI Service and drop the published link at the top of
the main [README](../README.md).
