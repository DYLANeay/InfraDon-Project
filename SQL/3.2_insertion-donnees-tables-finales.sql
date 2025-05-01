-- Active: 1741351947031@@127.0.0.1@5432@hopital
-- Insertion pour les patients
INSERT INTO personne (id, nom, prenom, adresse, telephone)
SELECT 
    id, 
    nom, 
    prenom, 
    COALESCE(adresse, 'Adresse inconnue'),
    telephone
FROM temp_patient_nonperso
ON CONFLICT DO NOTHING;

-- Insertion pour les médecins
INSERT INTO personne (id, nom, prenom, adresse, telephone)
SELECT 
    tdm.id, 
    tdm.nom, 
    tdm.prenom, 
    COALESCE(tas.adresse_corrigee, 'Adresse inconnue'),
    tdm.telephone
FROM temp_donnes_medecins tdm
LEFT JOIN temp_assurance_sexes tas ON tdm.id = tas.id
ON CONFLICT DO NOTHING;

-- Insérer les assurances et distinguer "complémentaire"
INSERT INTO assurance (nom, complementaire)
SELECT DISTINCT
    CASE
        WHEN POSITION('+' IN assurance) > 0 THEN LEFT(assurance, POSITION('+' IN assurance) - 2)
        ELSE assurance
    END AS nom,
    CASE
        WHEN LOWER(assurance) LIKE '%complémentaire%' THEN TRUE ELSE FALSE END AS complementaire
FROM temp_assurance_sexes
ON CONFLICT DO NOTHING;

INSERT INTO patient (id, date_de_naissance, sexe, fk_personne, fk_assurance)
SELECT
    tpn.id,
    tpn.date_de_naissance,
    CASE LOWER(tas.sexe)
        WHEN 'homme' THEN 'h'
        WHEN 'femme' THEN 'f'
        WHEN 'non-binaire' THEN 'nb'
        ELSE NULL END AS sexe,
    tpn.id AS fk_personne,
    tas.id AS fk_assurance
FROM temp_patient_nonperso tpn
LEFT JOIN temp_assurance_sexes tas ON tpn.id = tas.id
ON CONFLICT DO NOTHING;

INSERT INTO hopital (nom)
SELECT DISTINCT hopital
FROM temp_donnes_medecins
ON CONFLICT DO NOTHING;

-- 3. Ensuite insérer dans medecin (fk_personne déjà garantie existante)
INSERT INTO medecin (id, specialite, sexe, fk_personne)
SELECT 
    tdm.id,
    tdm.specialite,
    CASE 
        WHEN LOWER(tas.sexe) = 'homme' THEN 'h'
        WHEN LOWER(tas.sexe) = 'femme' THEN 'f'
        WHEN LOWER(tas.sexe) = 'non-binaire' THEN 'nb'
        ELSE NULL
    END,
    tdm.id
FROM temp_donnes_medecins tdm
LEFT JOIN temp_assurance_sexes tas ON tdm.id = tas.id
ON CONFLICT DO NOTHING;

INSERT INTO medecin_hopital_travaille (fk_medecin, fk_hopital)
SELECT
    tdm.id,
    h.id
FROM temp_donnes_medecins tdm
JOIN hopital h ON tdm.hopital = h.nom
ON CONFLICT DO NOTHING;

-- 1. Crée une colonne temporaire pour savoir si c'est le premier rendez-vous (à ne faire qu'une fois!)
-- Si tu fais plusieurs imports, adapte en un CTE ou update ensuite

ALTER TABLE temp_rendez_vous ADD COLUMN is_first BOOLEAN DEFAULT FALSE;

UPDATE temp_rendez_vous
SET is_first = TRUE
WHERE (id_patient, date) IN (
  SELECT id_patient, MIN(date) FROM temp_rendez_vous GROUP BY id_patient
);

INSERT INTO rendez_vous (id, date, motif, isFirst, fk_medecin, fk_patient)
SELECT 
    trv.id, 
    trv.date, 
    trv.motif,
    FALSE as isFirst,
    trv.id_medecin, 
    trv.id_patient
FROM temp_rendez_vous trv
JOIN medecin m ON trv.id_medecin = m.id         -- On ne prend QUE les medecins existants !
WHERE trv.id_patient IS NOT NULL
  AND trv.id_medecin IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO medicament (id, nom, dosage, type)
SELECT id, nom, dosage, type
FROM temp_medicament
WHERE id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO prescription (id, date_debut, date_fin, fk_rendez_vous, fk_medecin, fk_medicament)
SELECT
    tp.id,
    rv.date as date_debut,
    rv.date + (tp.duree_jours || ' days')::interval as date_fin,
    tp.id_rendez_vous,
    rv.fk_medecin,
    tp.id_medicament         -- MANQUAIT !!
FROM temp_prescription tp
JOIN rendez_vous rv ON tp.id_rendez_vous = rv.id
WHERE tp.id IS NOT NULL
  AND tp.id_medicament IS NOT NULL
ON CONFLICT DO NOTHING;

ALTER TABLE medecin DROP COLUMN sexe -- modification car on ne veut pas du sexe du médecin dans sa table .. --


