-- Active: 1741351947031@@127.0.0.1@5432@hopital
-- Création des rôles
CREATE ROLE medecin;
GRANT INSERT, SELECT, UPDATE, DELETE ON prescription TO medecin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO medecin;
--------------------------------------------
CREATE ROLE administrateur;
GRANT ALL ON ALL TABLES IN SCHEMA public TO administrateur;
 
--------------------------------------------
CREATE ROLE secretaire;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO secretaire;
GRANT INSERT,SELECT, DELETE, UPDATE ON rendez_vous TO secretaire;