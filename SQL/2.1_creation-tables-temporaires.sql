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
