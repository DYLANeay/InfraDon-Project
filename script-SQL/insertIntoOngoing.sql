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

CREATE TEMPORARY TABLE temp_assurance_sexes (
    id INT,
    assurance VARCHAR(50),
    sexe VARCHAR(50),
    adresse_corrigee VARCHAR(90)
);

CREATE TEMPORARY TABLE temp_prescription (
    id INT,
    id_rendez_vous INT,
    id_medicament INT,
    duree_jours INT
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


-- INSERT INTO tables définitives

-- Insérer les données dans la table personne
INSERT INTO personne (nom, prenom, adresse, telephone)
SELECT nom, prenom, adresse, telephone
FROM temp_patient_nonperso
ON CONFLICT (id) DO NOTHING;

SELECT * FROM personne;

-- Insérer les données dans la table medecin
INSERT INTO patient (date_de_naissance, sexe, fk_personne, fk_assurance)
SELECT date_de_naissance, 'h', p.id, 1
FROM temp_patient_nonperso
JOIN personne p ON p.nom = temp_patient_nonperso.nom AND p.prenom = temp_patient_nonperso.prenom
ON CONFLICT (fk_personne) DO NOTHING;

SELECT * FROM patient

--insérer les données dans assurance
INSERT INTO assurance (nom, complementaire)
SELECT DISTINCT assurance, false
FROM temp_assurance_sexes
ON CONFLICT (id) DO NOTHING;

-- Insérer les données dans la table hopital
INSERT INTO hopital (nom, specialite)
SELECT DISTINCT hopital, specialite
FROM temp_donnes_medecins
ON CONFLICT (id) DO NOTHING;

-- Insérer les données dans la table medecin_hopital_travaille
INSERT INTO medecin_hopital_travaille (fk_medecin, fk_hopital)
SELECT m.id, h.id
FROM temp_donnes_medecins
JOIN medecin m ON m.specialite = temp_donnes_medecins.specialite AND m.sexe = 'h'
JOIN hopital h ON h.nom = temp_donnes_medecins.hopital AND m.specialite = temp_donnes_medecins.specialite
ON CONFLICT (fk_medecin, fk_hopital) DO NOTHING;

-- Insérer les données dans la table rendez_vous
INSERT INTO rendez_vous (date, motif, isFirst, fk_medecin, fk_patient)
SELECT temp_rendez_vous.date, temp_rendez_vous.motif, TRUE, m.id, p.id
FROM temp_rendez_vous
JOIN medecin m ON m.specialite = temp_rendez_vous.specialite AND m.sexe = 'h'
JOIN patient p ON p.date_de_naissance = temp_rendez_vous.date_de_naissance
ON CONFLICT (id) DO NOTHING;

-- Insérer les données dans la table medicament
INSERT INTO medicament (nom, dosage, type)
SELECT nom, dosage, type
FROM temp_medicament
ON CONFLICT (id) DO NOTHING;

-- Insérer les données dans la table prescription
INSERT INTO prescription (date_debut, date_fin, fk_rendez_vous, fk_medecin)
SELECT temp_prescription.date, temp_prescription.date + INTERVAL '1 day', r.id, m.id
FROM temp_prescription
JOIN rendez_vous r ON r.date = temp_prescription.date
JOIN medecin m ON m.id = temp_prescription.id_medecin
ON CONFLICT (id) DO NOTHING;


