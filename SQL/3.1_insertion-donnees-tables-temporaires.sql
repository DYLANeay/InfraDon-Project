-- Active: 1741351947031@@127.0.0.1@5432@hopital_final
-- Remplissez les tables temporaires à l'aide de COPY
COPY temp_donnes_medecins (
    id,
    nom,
    prenom,
    specialite,
    hopital,
    telephone
)
FROM '/tmp/donnee_medecin.csv' DELIMITER ';' CSV HEADER;

COPY temp_assurance_sexes (
    id,
    assurance,
    sexe,
    adresse_corrigee
)
FROM '/tmp/hopital_dataset_assurances_sexe_adresse.csv' -- changer le chemin d'accès ofc --
    DELIMITER ';' CSV HEADER;

COPY temp_medicament (id, nom, dosage, type)
FROM '/tmp/medicament.csv' -- changer le chemin d'accès ofc --
    DELIMITER ';' CSV HEADER;

COPY temp_prescription (
    id,
    id_rendez_vous,
    id_medicament,
    duree_jours
)
FROM '/tmp/prescription.csv' -- changer le chemin d'accès ofc --
    DELIMITER ';' CSV HEADER;

COPY temp_rendez_vous (
    id,
    id_patient,
    id_medecin,
    date,
    motif
)
FROM '/tmp/Rendez_vous.csv' -- changer le chemin d'accès ofc --
    DELIMITER ';' CSV HEADER;

COPY temp_patient_nonperso (
    id,
    nom,
    prenom,
    date_de_naissance,
    adresse,
    telephone
)
FROM '/tmp/Patient_donnee_nonperso.csv' -- changer le chemin d'accès ofc --
    DELIMITER ';' CSV HEADER;