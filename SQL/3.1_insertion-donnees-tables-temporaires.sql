-- Remplissez les tables temporaires à l'aide de COPY
COPY temp_donnes_medecins (id, nom, prenom, specialite, hopital, telephone)
FROM 'C:\Users\dylan\Desktop\shitty_csv\donnee_medecin.csv' -- changer le chemin d'accès ofc --
DELIMITER ';'
CSV HEADER;

COPY temp_assurance_sexes (id, assurance, sexe, adresse_corrigee)
FROM 'C:\Users\dylan\Desktop\shitty_csv\hopital_dataset_assurances_sexe_adresse.csv' -- changer le chemin d'accès ofc --
DELIMITER ';'
CSV HEADER;

COPY temp_medicament (id, nom, dosage, type)
FROM 'C:\Users\dylan\Desktop\shitty_csv\medicament.csv' -- changer le chemin d'accès ofc --
DELIMITER ';'
CSV HEADER;

COPY temp_prescription (id, id_rendez_vous, id_medicament, duree_jours)
FROM 'C:\Users\dylan\Desktop\shitty_csv\prescription.csv' -- changer le chemin d'accès ofc --
DELIMITER ';'
CSV HEADER;

COPY temp_rendez_vous (id, id_patient, id_medecin, date, motif)
FROM 'C:\Users\dylan\Desktop\shitty_csv\Rendez_vous.csv' -- changer le chemin d'accès ofc --
DELIMITER ';'
CSV HEADER;

COPY temp_patient_nonperso (id, nom, prenom, date_de_naissance, adresse, telephone)
FROM 'C:\Users\dylan\Desktop\shitty_csv\Patient_donnee_nonperso.csv'  -- changer le chemin d'accès ofc --
DELIMITER ';'
CSV HEADER;