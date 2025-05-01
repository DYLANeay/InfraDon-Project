-- Active: 1741351947031@@127.0.0.1@5432@hopital
-- Création des rôles
CREATE ROLE medecin;
GRANT INSERT, SELECT, UPDATE, DELETE ON prescription TO medecin;
GRANT SELECT ON ALL TABLES TO medecin;


CREATE ROLE administrateur;
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES TO administrateur;

GRANT 
CREATE ROLE secretaire;