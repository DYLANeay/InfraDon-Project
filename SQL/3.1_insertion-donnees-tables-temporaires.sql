-- Active: 1741351947031@@127.0.0.1@5432@hopital
COPY temp_donnes_medecins (id, nom, prenom, specialite, hopital, telephone)
FROM '/home/dylan/InfraDon1/InfraDon-Project/csv-files/donnee_medecin.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_assurance_sexes (id, assurance, sexe, adresse_corrigee)
FROM '/home/dylan/InfraDon1/InfraDon-Project/csv-files/hopital_dataset_assurances_sexe_adresse.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_medicament (id, nom, dosage, type)
FROM '/home/dylan/InfraDon1/InfraDon-Project/csv-files/medicament.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_prescription (id, id_rendez_vous, id_medicament, duree_jours)
FROM '/home/dylan/InfraDon1/InfraDon-Project/csv-files/prescription.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_rendez_vous (id, id_patient, id_medecin, date, motif)
FROM '/home/dylan/InfraDon1/InfraDon-Project/csv-files/Rendez_vous.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_patient_nonperso (id, nom, prenom, date_de_naissance, adresse, telephone)
FROM '/home/dylan/InfraDon1/InfraDon-Project/csv-files/Patient_donnee_nonperso.csv'
DELIMITER ';'
CSV HEADER;
