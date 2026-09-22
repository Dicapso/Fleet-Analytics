"""
Fleet Analytics - synthetic data generator.

Produces five related CSV files under ../data that model a mid-size
vehicle fleet: vehicles, drivers, trips, maintenance, and fuel logs.
The data is randomly generated but internally consistent (foreign keys,
plausible date ranges, plausible fuel/mileage relationships) so it can
be loaded into SQL Server and modeled in Power BI.

Usage:
    python generate_data.py
"""

import csv
import random
from datetime import date, timedelta
from pathlib import Path

random.seed(42)

OUT_DIR = Path(__file__).resolve().parent.parent / "data"
OUT_DIR.mkdir(exist_ok=True)

START_DATE = date(2025, 1, 1)
END_DATE = date(2025, 12, 31)

VEHICLE_MAKES = [
    ("Ford", "Transit"), ("Mercedes-Benz", "Sprinter"), ("Volkswagen", "Crafter"),
    ("Toyota", "Hiace"), ("Iveco", "Daily"), ("Renault", "Master"),
]
CITIES = ["Baku", "Ganja", "Sumgait", "Mingachevir", "Shaki", "Lankaran"]
FUEL_TYPES = ["Diesel", "Petrol"]
MAINTENANCE_TYPES = [
    "Oil Change", "Tire Replacement", "Brake Service", "Engine Repair",
    "Battery Replacement", "Scheduled Inspection", "AC Service",
]
FIRST_NAMES = ["Tural", "Elvin", "Kamran", "Rashad", "Vugar", "Orkhan",
               "Murad", "Nijat", "Farid", "Emil", "Aynur", "Leyla",
               "Gunel", "Sabina", "Nigar"]
LAST_NAMES = ["Aliyev", "Mammadov", "Huseynov", "Guliyev", "Hasanov",
              "Ismayilov", "Rzayev", "Novruzov", "Karimov", "Abbasov"]


def random_date(start: date, end: date) -> date:
    delta = (end - start).days
    return start + timedelta(days=random.randint(0, delta))


def build_vehicles(n=50):
    rows = []
    for i in range(1, n + 1):
        make, model = random.choice(VEHICLE_MAKES)
        purchase_date = random_date(date(2019, 1, 1), date(2024, 6, 1))
        rows.append({
            "vehicle_id": i,
            "plate_number": f"10-{random.randint(100,999)}-{random.choice('ABCDE')}{random.choice('ABCDE')}",
            "make": make,
            "model": model,
            "year": purchase_date.year,
            "fuel_type": random.choice(FUEL_TYPES),
            "purchase_date": purchase_date.isoformat(),
            "home_city": random.choice(CITIES),
            "odometer_start_km": random.randint(0, 20000),
        })
    return rows


def build_drivers(n=15):
    rows = []
    for i in range(1, n + 1):
        hire_date = random_date(date(2020, 1, 1), date(2025, 1, 1))
        rows.append({
            "driver_id": i,
            "full_name": f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}",
            "license_no": f"AZ{random.randint(1000000, 9999999)}",
            "hire_date": hire_date.isoformat(),
            "home_city": random.choice(CITIES),
        })
    return rows


def build_trips(vehicles, drivers, n=300):
    rows = []
    for i in range(1, n + 1):
        vehicle = random.choice(vehicles)
        trip_date = random_date(START_DATE, END_DATE)
        distance_km = round(random.uniform(15, 450), 1)
        duration_min = round(distance_km / random.uniform(35, 55) * 60)
        rows.append({
            "trip_id": i,
            "vehicle_id": vehicle["vehicle_id"],
            "driver_id": random.choice(drivers)["driver_id"],
            "trip_date": trip_date.isoformat(),
            "origin_city": random.choice(CITIES),
            "destination_city": random.choice(CITIES),
            "distance_km": distance_km,
            "duration_min": duration_min,
        })
    return rows


def build_maintenance(vehicles, n=100):
    rows = []
    for i in range(1, n + 1):
        vehicle = random.choice(vehicles)
        service_date = random_date(START_DATE, END_DATE)
        rows.append({
            "maintenance_id": i,
            "vehicle_id": vehicle["vehicle_id"],
            "service_date": service_date.isoformat(),
            "service_type": random.choice(MAINTENANCE_TYPES),
            "cost_azn": round(random.uniform(40, 900), 2),
            "downtime_hours": round(random.uniform(1, 48), 1),
        })
    return rows


def build_fuel_logs(vehicles, n=300):
    rows = []
    for i in range(1, n + 1):
        vehicle = random.choice(vehicles)
        log_date = random_date(START_DATE, END_DATE)
        liters = round(random.uniform(20, 90), 1)
        price_per_liter = round(random.uniform(1.0, 1.6), 2)
        rows.append({
            "fuel_log_id": i,
            "vehicle_id": vehicle["vehicle_id"],
            "log_date": log_date.isoformat(),
            "liters": liters,
            "price_per_liter_azn": price_per_liter,
            "total_cost_azn": round(liters * price_per_liter, 2),
            "odometer_km": vehicle["odometer_start_km"] + random.randint(0, 60000),
        })
    return rows


def write_csv(filename, rows):
    path = OUT_DIR / filename
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)
    print(f"wrote {len(rows):>4} rows -> {path}")


def main():
    vehicles = build_vehicles()
    drivers = build_drivers()
    trips = build_trips(vehicles, drivers)
    maintenance = build_maintenance(vehicles)
    fuel_logs = build_fuel_logs(vehicles)

    write_csv("vehicles.csv", vehicles)
    write_csv("drivers.csv", drivers)
    write_csv("trips.csv", trips)
    write_csv("maintenance.csv", maintenance)
    write_csv("fuel_logs.csv", fuel_logs)


if __name__ == "__main__":
    main()
