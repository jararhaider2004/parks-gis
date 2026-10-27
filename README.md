# Islamabad Parks & Recreational Facilities GIS

Live website: https://jararhaider2004.github.io/parks-gis/

Topic: Option 4 – Parks and Recreational Facilities Management
Stack: PostgreSQL + PostGIS → Node.js/Express API → Leaflet website

## Workflow
1. **Database** – Open pgAdmin, run `CREATE DATABASE parks_db;`, connect to it, then run the rest of `database.sql`
   (enables PostGIS, creates `parks` table with Point geometry, inserts 20 records, runs sample queries).
2. **Backend** – Copy `config.example.json` to `config.json` and put your postgres password in it, then run:
   ```
   npm install
   npm start
   ```
3. **Website** – Open http://localhost:3000

## API
| Method | URL | Purpose |
|---|---|---|
| GET | /api/parks?type=&sector= | Get / filter records (JSON) |
| POST | /api/parks | Add record |
| PUT | /api/parks/:id | Update record |
| DELETE | /api/parks/:id | Delete record |

## Features
- Map shows parks coloured by type (green Park, orange Playground, blue Track, red Sports)
- Filter by **type** and **sector** (2 attributes)
- Add: click map → coordinates fill → enter details → Save
- Edit/Delete: click marker → Edit / Delete
- Validation: name ≥ 3 letters, valid type, sector required, lat/lng inside Islamabad (frontend + backend)

## Persistence test (screenshots)
1. Edit a park's status on website → Save
2. Refresh page → change still there
3. pgAdmin: `SELECT * FROM parks WHERE id = X;` → shows new value

Data note: sample data with approximate locations, prepared for academic use.
