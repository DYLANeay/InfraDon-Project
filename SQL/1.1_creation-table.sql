-- Active: 1741351947031@@127.0.0.1@5432@hopital_final
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
    fk_personne INT UNIQUE NOT NULL REFERENCES personne (id),
    fk_assurance INT NOT NULL REFERENCES assurance (id)
);

CREATE TABLE hopital (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE medecin (
    id SERIAL PRIMARY KEY,
    specialite VARCHAR(50) NOT NULL,
    fk_personne INT UNIQUE NOT NULL REFERENCES personne (id)
);

CREATE TABLE medecin_hopital_travaille (
    fk_medecin INT NOT NULL REFERENCES medecin (id),
    fk_hopital INT NOT NULL REFERENCES hopital (id),
    PRIMARY KEY (fk_medecin, fk_hopital)
);

CREATE TABLE rendez_vous (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    motif VARCHAR(255),
    isFirst BOOLEAN NOT NULL,
    fk_medecin INT NOT NULL REFERENCES medecin (id),
    fk_patient INT NOT NULL REFERENCES patient (id),
    UNIQUE (fk_medecin, date, fk_patient)
);

CREATE TABLE medicament (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    dosage VARCHAR(50),
    type VARCHAR(50) NOT NULL
);

CREATE TABLE prescription (
    id SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL CHECK (
        date_fin <= date_debut + INTERVAL '12 months'
    ),
    fk_rendez_vous INT NOT NULL REFERENCES rendez_vous (id),
    fk_medecin INT NOT NULL REFERENCES medecin (id),
    fk_medicament INT NOT NULL REFERENCES medicament (id)
);

-- Fonction qui vérifie que seuls les patients majeurs peuvent avoir un rendez-vous pour une chirurgie
CREATE OR REPLACE FUNCTION check_motif_chirurgie()
RETURNS TRIGGER AS $$
BEGIN
    -- Si le motif du rendez-vous est 'chirurgie' ET que le patient a moins de 18 ans
    IF NEW.motif = 'chirurgie' AND (SELECT date_de_naissance FROM patient WHERE id = NEW.fk_patient) > CURRENT_DATE - INTERVAL '18 years' THEN
        -- On lève une erreur et on empêche l'insertion ou la modification
        RAISE EXCEPTION 'Un patient de moins de 18 ans ne peut pas avoir un rendez-vous pour une chirurgie';
    END IF;
    RETURN NEW; -- Sinon, on autorise
END;

$$
LANGUAGE plpgsql;

-- Fonction qui vérifie que la date de début de la prescription correspond à la date du rendez-vous associé
CREATE OR REPLACE FUNCTION check_prescription_date()
RETURNS TRIGGER AS 
$$

BEGIN
    -- Si la date de début de la prescription est différente de la date du rendez-vous lié
    IF NEW.date_debut <> (SELECT date FROM rendez_vous WHERE id = NEW.fk_rendez_vous) THEN
        -- On lève une erreur et on empêche l'insertion ou la modification
        RAISE EXCEPTION 'La date de début de la prescription doit correspondre à la date du rendez-vous';
    END IF;
    RETURN NEW; -- Sinon, on autorise
END;
$$ LANGUAGE plpgsql;

-- Déclencheur : appelle la fonction check_motif_chirurgie avant chaque insertion ou modification sur la table rendez_vous
CREATE TRIGGER check_motif_chirurgie_trigger
BEFORE INSERT OR UPDATE ON rendez_vous
FOR EACH ROW EXECUTE FUNCTION check_motif_chirurgie();

-- Déclencheur : appelle la fonction check_prescription_date avant chaque insertion ou modification sur la table prescription
CREATE TRIGGER check_prescription_date_trigger
BEFORE INSERT OR UPDATE ON prescription
FOR EACH ROW EXECUTE FUNCTION check_prescription_date();