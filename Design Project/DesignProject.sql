-- Joseph Gust  5/2/2017  Design Project
-- This is a database for the United Federation of Planets from Star Trek

-- Drop any tables that already exist
DROP TABLE IF EXISTS FacilityArmed;
DROP TABLE IF EXISTS Shields;
DROP TABLE IF EXISTS Weapons;
DROP TABLE IF EXISTS CombatEquipment;
DROP TABLE IF EXISTS Missions;
DROP VIEW IF EXISTS FPOfficers;
DROP VIEW IF EXISTS FPCrew;
DROP TABLE IF EXISTS Officers;
DROP TABLE IF EXISTS Crew;
DROP TABLE IF EXISTS Starships;
DROP TABLE IF EXISTS Starbases;
DROP TABLE IF EXISTS FederationProperties;
DROP TABLE IF EXISTS People;
DROP ROLE IF EXISTS Administrator;
DROP ROLE IF EXISTS Officer;
DROP ROLE IF EXISTS CrewMember;

-- Make all of the tables
CREATE TABLE People (
   pid			char(5) NOT NULL,
   firstName 	TEXT NOT NULL,
   lastName		TEXT,
   gender 		char(1),
   species 		TEXT NOT NULL,
   birthyear 	integer,
   deathyear 	integer,
   inService 	boolean NOT NULL,
   sfRank		TEXT NOT NULL,
   occupation 	TEXT,
   PRIMARY KEY (pid)
);

CREATE TABLE FederationProperties (
  fpid 			char(4) NOT NULL,
  fpName 		TEXT NOT NULL,
  buildDate		integer NOT NULL,
  inService	 	boolean NOT NULL,
  maxCapacity	integer NOT NULL,
  coordinates	TEXT NOT NULL,
  PRIMARY KEY (fpid)
);

CREATE TABLE Starships (
   fpid 		char(4) NOT NULL REFERENCES FederationProperties(fpid),
   maximumWarp 	integer NOT NULL,
   PRIMARY KEY (fpid)
);

CREATE TABLE Starbases (
  fpid 			char(4) NOT NULL REFERENCES FederationProperties(fpid),
  PRIMARY KEY 	(fpid)
);

CREATE TABLE Officers (
  pid 			char(5) NOT NULL REFERENCES People(pid),
  fpid 			char(4) NOT NULL REFERENCES FederationProperties(fpid),
  PRIMARY KEY 	(pid,fpid)
);

CREATE TABLE Crew (
  pid 			char(5) NOT NULL REFERENCES People(pid),
  fpid 			char(4) NOT NULL REFERENCES FederationProperties(fpid),
  PRIMARY KEY 	(pid,fpid)
);

CREATE TABLE Missions (
  mid 			char(5) NOT NULL,
  fpid 			char(4) NOT NULL REFERENCES FederationProperties(fpid),
  missionType 	char(4) NOT NULL,
  description 	TEXT NOT NULL,
  region 		TEXT NOT NULL,
  urgency		integer NOT NULL,
  ended			boolean NOT NULL,
  PRIMARY KEY (mid)
);

CREATE TABLE CombatEquipment (
  ceid 			char(4) NOT NULL,
  ceType 		char(1) NOT NULL,
  ceName 		TEXT NOT NULL,
  PRIMARY KEY (ceid)
);

CREATE TABLE Weapons (
  ceid 			char(4) NOT NULL REFERENCES CombatEquipment(ceid),
  PRIMARY KEY 	(ceid)
);

CREATE TABLE Shields (
  ceid			char(4) NOT NULL REFERENCES CombatEquipment(ceid),
  PRIMARY KEY 	(ceid)
);

CREATE TABLE FacilityArmed (
  fpid 			char(4) NOT NULL REFERENCES FederationProperties(fpid),
  ceid			char(4) NOT NULL REFERENCES CombatEquipment(ceid),
  PRIMARY KEY 	(fpid, ceid)
);
-- Finished with making tables


-- stored procedure: type w -> insert ceid into weapons | type s-> insert into shields
CREATE OR REPLACE FUNCTION addCE()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.ceType = 'w' THEN
   		INSERT INTO Weapons(ceid)
    	values(NEW.ceid);
    END IF;
    IF NEW.ceType = 's' THEN
   		INSERT INTO Shields(ceid)
    	values(NEW.ceid);
    END IF;
    RETURN NEW;
 END;
$$ language plpgsql;

-- If something is inserted in combatEquipment, run addCE()
CREATE TRIGGER addCE
AFTER INSERT OR UPDATE ON combatEquipment
FOR EACH ROW
EXECUTE PROCEDURE addCE();



-- Let's add data to the tables

-- People --
INSERT INTO People(pid, firstName, lastName, gender, species, birthyear, deathyear, inService, sfRank, occupation)
	values('p0001', 'James', 'Kirk', 'm', 'human', 2233, null, true, 'Captain', 'Commanding Officer of the USS Enterprise' ),
    	  ('p0002', 'Spock', null, 'm', 'vulcan/human', 2230, null, true, 'Commander', 'First Officer of the USS Enterprise'),
          ('p0003', 'Leonard', 'McCoy', 'm', 'human', 2227, null, true, 'Lieutenant Commander', 'Chief medical officer'),
          ('p0004', 'Some', 'RedShirt', 'm', 'human', 2234, 2268, false, 'Security Officer', 'Expendable security detail'),
          ('p0005', 'Alan', 'McDatabase', 'm', 'human', 2236, null, true, 'Fleet Admiral', 'Commander in Chief of the UFP'),
          ('p0006', 'Joe', 'Tsug', 'm', 'human', 2244, null, true, 'Cadet', 'Janitor'),
          ('p0007', 'someone', 'name', 'f', 'vulcan', 2225, null, true, 'Lieutenant Commander', 'Science Officer'),
          ('p0008', 'Crewmate', 'person', 'f', 'human', 2235, null, false, 'Cadet', 'Button pusher');

INSERT INTO FederationProperties(fpid,fpName,BuildDate,inService,maxCapacity,coordinates)
	values('fp01','USS Enterprise',2245,true,2000,'23.17.46.11'),
    	  ('fp02','Another Starship',2225,true,800,'43.89.26.05'),
          ('fp03','Starbase1',2205,true,1500000,'12.56.39.88'),
          ('fp04','Other Starbase',2185,false,950000,'127.45.182.54');
          
INSERT INTO Officers(pid,fpid)
	values('p0001','fp01'),
    	  ('p0002','fp01'),
          ('p0003','fp01'),
          ('p0004','fp01'),
          ('p0005','fp03'),
          ('p0007','fp02');
          
INSERT INTO Crew(pid,fpid)
	values('p0006','fp01'),
    	  ('p0008','fp02');
          
INSERT INTO Starbases(fpid)
	values('fp03'),
    	  ('fp04');
INSERT INTO Starships(fpid,maximumWarp)
	values('fp01',8),
    	  ('fp02',6.5);
          
INSERT INTO CombatEquipment(ceid,ceType,ceName)
	values('ce01','w','Photon Torpedo'),
    	  ('ce02','w','Phaser'),
          ('ce03','s','Deflector Shield');
	
INSERT INTO Missions(mid,fpid,missionType,description,region,urgency,ended)
	values('m001','fp01','RESC','Rescue survivors of a ship crash landed on an asteroid','Far far away',5,false),
    	  ('m002','fp01','RSCH','Study life forms on planet X','Somewhere in space',1,false);
 
-- View shows on which ship or starbase each officer is stationed
CREATE view FPOfficers(fpid,fpName,pid,firstName,lastName,sfRank,occupation)
as
	select 	fp.fpid,fp.fpName,p.pid,p.firstName,p.lastName,p.sfRank,p.occupation
    from 	officers o 	inner join FederationProperties fp on o.fpid = fp.fpid
    					inner join People p on o.pid = p.pid
   ;
 
 -- View shows on which ship or starbase each (non-officer)crew member is stationed
CREATE view FPCrew(fpid,fpName,pid,firstName,lastName,sfRank,occupation)
as
	select 	fp.fpid,fp.fpName,p.pid,p.firstName,p.lastName,p.sfRank,p.occupation
    from 	crew c 	inner join FederationProperties fp on c.fpid = fp.fpid
    				inner join People p on c.pid = p.pid
   ;    
   
-- Security

-- An administrator can alter or even delete data
create role Administrator;
grant select, insert, update, delete
on all tables in schema public
to Administrator;

-- Officers can add updates to the data, but they cannot delete data
create role Officer;
grant select, insert, update
on all tables in schema public
to Officer;

-- other (non-officer) crew members can view people and federation
-- properties, as well as where crew members are stationed
-- but they cannot view where the officers are stationed
create role CrewMember;
grant select
on People, FederationProperties, Crew, Starships, Starbases
to CrewMember;
