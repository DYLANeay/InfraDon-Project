-- Créez les tables temporaires
CREATE TEMPORARY TABLE temp_donnes_medecins (
    id INT,
    nom VARCHAR(20),
    prenom VARCHAR(20),
    specialite VARCHAR(30),
    hopital VARCHAR(30),
    telephone VARCHAR(30)
);

CREATE TEMPORARY TABLE temp_patient_nonperso (
    id INT,
    nom VARCHAR(20),
    prenom VARCHAR(20),
    date_de_naissance DATE,
    adresse VARCHAR(100),
    telephone VARCHAR(30)
);

CREATE TEMPORARY TABLE temp_rendez_vous (
    id INT,
    id_patient INT,
    id_medecin INT,
    date DATE,
    motif VARCHAR(20)
);

CREATE TEMPORARY TABLE temp_medicament (
    id INT,
    nom VARCHAR(30),
    dosage VARCHAR(30),
    type VARCHAR(30)
);

CREATE TEMPORARY TABLE temp_prescription (
    id INT,
    id_rendez_vous INT,
    id_medicament INT,
    duree_jours INT
);

-- Remplissez les tables temporaires à l'aide de COPY
COPY temp_donnes_medecins (id, nom, prenom, specialite, hopital, telephone)
FROM 'C:\Users\dylan\Desktop\shitty_csv\donnee_medecin.csv' -- changer le chemin d'accès ofc --
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

-- INSERT INTO tables définitives

