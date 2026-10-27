CREATE DATABASE parks_db;

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE parks (
  id      SERIAL PRIMARY KEY,
  name    VARCHAR(100) NOT NULL,
  type    VARCHAR(30)  NOT NULL,
  sector  VARCHAR(20)  NOT NULL,
  status  VARCHAR(20)  DEFAULT 'Open',
  geom    GEOMETRY(Point, 4326) NOT NULL
);

INSERT INTO parks (name, type, sector, status, geom) VALUES
('Fatima Jinnah Park','Park','F-9','Open',ST_SetSRID(ST_MakePoint(73.0225,33.7020),4326)),
('Lake View Park','Park','Rawal Lake','Open',ST_SetSRID(ST_MakePoint(73.1270,33.7130),4326)),
('Shakarparian Park','Park','Shakarparian','Open',ST_SetSRID(ST_MakePoint(73.0780,33.6920),4326)),
('Japanese Park','Playground','Zoo Area','Open',ST_SetSRID(ST_MakePoint(73.0540,33.7260),4326)),
('Daman-e-Koh','Park','Margalla','Open',ST_SetSRID(ST_MakePoint(73.0570,33.7390),4326)),
('Trail 3 Start','Walking Track','F-6','Open',ST_SetSRID(ST_MakePoint(73.0730,33.7380),4326)),
('Trail 5 Start','Walking Track','F-6','Open',ST_SetSRID(ST_MakePoint(73.0840,33.7340),4326)),
('Rose and Jasmine Garden','Park','Shakarparian','Open',ST_SetSRID(ST_MakePoint(73.1010,33.6960),4326)),
('F-7 Jogging Park','Walking Track','F-7','Open',ST_SetSRID(ST_MakePoint(73.0500,33.7210),4326)),
('F-10 Park','Park','F-10','Open',ST_SetSRID(ST_MakePoint(73.0130,33.6950),4326)),
('F-11 Park','Park','F-11','Open',ST_SetSRID(ST_MakePoint(72.9870,33.6830),4326)),
('G-9 Park','Park','G-9','Closed',ST_SetSRID(ST_MakePoint(73.0300,33.6880),4326)),
('G-6 Playground','Playground','G-6','Open',ST_SetSRID(ST_MakePoint(73.0880,33.7090),4326)),
('Sports Complex Ground','Sports Ground','Aabpara','Open',ST_SetSRID(ST_MakePoint(73.0820,33.7000),4326)),
('E-7 Park','Park','E-7','Open',ST_SetSRID(ST_MakePoint(73.0560,33.7310),4326)),
('I-8 Park','Park','I-8','Open',ST_SetSRID(ST_MakePoint(73.0750,33.6690),4326)),
('I-10 Playground','Playground','I-10','Under Repair',ST_SetSRID(ST_MakePoint(73.0400,33.6480),4326)),
('G-11 Cricket Ground','Sports Ground','G-11','Open',ST_SetSRID(ST_MakePoint(72.9960,33.6700),4326)),
('Bani Gala Track','Walking Track','Bani Gala','Open',ST_SetSRID(ST_MakePoint(73.1500,33.7160),4326)),
('Chattar Park','Park','Murree Road','Open',ST_SetSRID(ST_MakePoint(73.2800,33.7750),4326));

SELECT id, name, type, sector, ST_X(geom) lng, ST_Y(geom) lat FROM parks;
SELECT * FROM parks WHERE type = 'Park' AND sector = 'F-9';
SELECT type, COUNT(*) FROM parks GROUP BY type;
UPDATE parks SET status = 'Open' WHERE id = 12;
SELECT name FROM parks
WHERE ST_DWithin(geom::geography, ST_MakePoint(73.0225,33.7020)::geography, 3000);
