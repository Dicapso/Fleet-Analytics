# Fleet Analytics

End-to-end fleet management analytics project: synthetic trip/fuel/maintenance
data generated in **Python**, modeled and queried in **SQL Server**, and
visualized in **Power BI** — tracking fleet cost, utilization, and fuel
efficiency for a mid-size vehicle fleet.

## Business questions

- What is the fleet's fuel efficiency (km/L) and cost per km, by vehicle and over time?
- Which vehicles and service types drive the highest maintenance cost and downtime?
- How utilized is each vehicle and driver (trips, distance)?
- Is total operating cost trending up or down month over month?

## Tech stack

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![MS SQL](https://img.shields.io/badge/MS_SQL-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=powerbi&logoColor=black)

## Project structure

```
Fleet-Analytics/
├── python/
│   └── generate_data.py     # generates the CSVs below (reproducible, seeded)
├── data/
│   ├── vehicles.csv         # 50 vehicles
│   ├── drivers.csv          # 15 drivers
│   ├── trips.csv            # 300 trips
│   ├── maintenance.csv      # 100 service records
│   └── fuel_logs.csv        # 300 fuel purchases
├── sql/
│   ├── 01_schema.sql        # table definitions (SQL Server)
│   ├── 02_load_data.sql     # BULK INSERT the CSVs
│   └── 03_analysis_views.sql# KPI views: vehicle summary, monthly trend, driver summary, maintenance by type
└── powerbi/
    ├── measures.dax         # every DAX measure used in the report
    └── README.md            # step-by-step guide to build the .pbix report
```

## How it fits together

1. **`python/generate_data.py`** creates a consistent, seeded synthetic
   dataset (same output every run) for five related entities: vehicles,
   drivers, trips, maintenance, and fuel logs.
2. **`sql/`** loads that data into SQL Server and exposes it through four
   analysis views (`vw_VehicleSummary`, `vw_MonthlyTrend`, `vw_DriverSummary`,
   `vw_MaintenanceByType`) that do the heavy joins/aggregations once, so the
   Power BI model stays simple.
3. **`powerbi/`** documents the star-schema data model, every DAX measure,
   and the three report pages (Fleet Overview, Vehicle Performance, Drivers)
   — see [`powerbi/README.md`](powerbi/README.md) for the full build guide.

## Getting started

```bash
cd python
python generate_data.py   # regenerates data/*.csv
```

Then either point Power BI directly at `data/` (Get Data → Folder), or run
the scripts in `sql/` against SQL Server and connect Power BI to the database.

---

**Tural Zamanlı** • Data Analytics × AI & Automation × IT Support • [@Dicapso](https://github.com/Dicapso)
