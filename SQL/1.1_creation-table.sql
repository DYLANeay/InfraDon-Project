-- Tables de base
CREATE TABLE personne (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    adresse VARCHAR(100) NOT NULL,
    telephone VARCHAR(30) NOT NULL
);

CREATE TABLE assurance (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    complementaire BOOLEAN NOT NULL
);

CREATE TABLE patient (
    id SERIAL PRIMARY KEY,
    date_de_naissance DATE NOT NULL,
    sexe VARCHAR(30) CHECK (sexe IN ('h', 'f', 'nb')),
    fk_personne INT UNIQUE NOT NULL REFERENCES personne(id),
    fk_assurance INT NOT NULL REFERENCES assurance(id)
);

CREATE TABLE hopital (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE medecin (
    id SERIAL PRIMARY KEY,
    specialite VARCHAR(50) NOT NULL,
    sexe VARCHAR(30) CHECK (sexe IN ('h', 'f', 'nb')),
    fk_personne INT UNIQUE NOT NULL REFERENCES personne(id)
);

CREATE TABLE medecin_hopital_travaille (
    fk_medecin INT NOT NULL REFERENCES medecin(id),
    fk_hopital INT NOT NULL REFERENCES hopital(id),
    PRIMARY KEY (fk_medecin, fk_hopital)
);

CREATE TABLE rendez_vous (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    motif VARCHAR(255),
    isFirst BOOLEAN NOT NULL,
    fk_medecin INT NOT NULL REFERENCES medecin(id),
    fk_patient INT NOT NULL REFERENCES patient(id),
    UNIQUE (fk_medecin, date, fk_patient)
);

CREATE TABLE medicament (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    dosage VARCHAR(50),
    type VARCHAR(50) NOT NULL
);

-- Nouvelle table prescription AVEC fk_medicament en direct
CREATE TABLE prescription (
    id SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL CHECK (date_fin <= date_debut + INTERVAL '12 months'),
    fk_rendez_vous INT NOT NULL REFERENCES rendez_vous(id),
    fk_medecin INT NOT NULL REFERENCES medecin(id),
    fk_medicament INT NOT NULL REFERENCES medicament(id)
);

-- Fonction et trigger pour le motif chirurgie
CREATE OR REPLACE FUNCTION check_motif_chirurgie()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.motif = 'chirurgie' AND (SELECT date_de_naissance FROM patient WHERE id = NEW.fk_patient) > CURRENT_DATE - INTERVAL '18 years' THEN
        RAISE EXCEPTION 'Un patient de moins de 18 ans ne peut pas avoir un rendez-vous pour une chirurgie';
    END IF;
    RETURN NEW;
END;

$$
 LANGUAGE plpgsql;

-- Fonction et trigger pour la date de prescription
CREATE OR REPLACE FUNCTION check_prescription_date()
RETURNS TRIGGER AS 
$$

BEGIN
    IF NEW.date_debut <> (SELECT date FROM rendez_vous WHERE id = NEW.fk_rendez_vous) THEN
        RAISE EXCEPTION 'La date de début de la prescription doit correspondre à la date du rendez-vous';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_motif_chirurgie_trigger
BEFORE INSERT OR UPDATE ON rendez_vous
FOR EACH ROW EXECUTE FUNCTION check_motif_chirurgie();

CREATE TRIGGER check_prescription_date_trigger
BEFORE INSERT OR UPDATE ON prescription
FOR EACH ROW EXECUTE FUNCTION check_prescription_date();
