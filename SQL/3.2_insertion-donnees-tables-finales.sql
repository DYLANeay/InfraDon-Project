-- Active: 1741351947031@@127.0.0.1@5432@hopital_final
INSERT INTO
    personne (
        id,
        nom,
        prenom,
        adresse,
        telephone
    )
SELECT id, nom, prenom, COALESCE(adresse, 'Adresse inconnue'), telephone
FROM temp_patient_nonperso
ON CONFLICT DO NOTHING;

-- Insertion pour les médecins dans la table personne
INSERT INTO
    personne (
        id,
        nom,
        prenom,
        adresse,
        telephone
    )
SELECT tdm.id, tdm.nom, tdm.prenom, COALESCE(
        tas.adresse_corrigee, 'Adresse inconnue'
    ), tdm.telephone
FROM
    temp_donnes_medecins tdm
    LEFT JOIN temp_assurance_sexes tas ON tdm.id = tas.id
ON CONFLICT DO NOTHING;

-- Insérer les assurances avec des noms distincts (chaque combinaison nom/complémentaire = un ID unique)
INSERT INTO
    assurance (nom, complementaire)
SELECT DISTINCT
    -- Garder le nom complet de l'assurance tel qu'il apparaît
    assurance AS nom,
    -- Déterminer si c'est complémentaire
    CASE
        WHEN LOWER(assurance) LIKE '%complémentaire%' THEN TRUE
        ELSE FALSE
    END AS complementaire
FROM temp_assurance_sexes
WHERE
    assurance IS NOT NULL
ON CONFLICT DO NOTHING;

-- Insérer les patients avec leurs propres IDs auto-générés
INSERT INTO
    patient (
        date_de_naissance,
        sexe,
        fk_personne,
        fk_assurance
    )
SELECT
    tpn.date_de_naissance,
    CASE LOWER(COALESCE(tas.sexe, ''))
        WHEN 'homme' THEN 'h'
        WHEN 'femme' THEN 'f'
        WHEN 'non-binaire' THEN 'nb'
        ELSE NULL
    END AS sexe,
    tpn.id AS fk_personne,
    a.id AS fk_assurance
FROM
    temp_patient_nonperso tpn
    LEFT JOIN temp_assurance_sexes tas ON tpn.id = tas.id
    LEFT JOIN assurance a ON a.nom = tas.assurance
    AND a.complementaire = CASE
        WHEN LOWER(COALESCE(tas.assurance, '')) LIKE '%complémentaire%' THEN TRUE
        ELSE FALSE
    END
WHERE
    EXISTS (
        SELECT 1
        FROM personne p
        WHERE
            p.id = tpn.id
    )
    AND a.id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Insérer les hôpitaux
INSERT INTO
    hopital (nom)
SELECT DISTINCT
    hopital
FROM temp_donnes_medecins
ON CONFLICT DO NOTHING;

-- Insérer les médecins avec leurs propres IDs auto-générés
INSERT INTO
    medecin (specialite, fk_personne)
SELECT tdm.specialite, tdm.id AS fk_personne
FROM temp_donnes_medecins tdm
WHERE
    EXISTS (
        SELECT 1
        FROM personne p
        WHERE
            p.id = tdm.id
    )
ON CONFLICT DO NOTHING;

-- Insérer les relations médecin-hôpital
INSERT INTO
    medecin_hopital_travaille (fk_medecin, fk_hopital)
SELECT m.id, h.id -- Utiliser l'ID auto-généré du médecin
FROM
    temp_donnes_medecins tdm
    JOIN medecin m ON m.fk_personne = tdm.id -- Jointure sur la FK personne
    JOIN hopital h ON tdm.hopital = h.nom
ON CONFLICT DO NOTHING;

-- Ajouter colonne temporaire pour déterminer les premiers rendez-vous
ALTER TABLE temp_rendez_vous
ADD COLUMN IF NOT EXISTS is_first BOOLEAN DEFAULT FALSE;

UPDATE temp_rendez_vous
SET
    is_first = TRUE
WHERE (id_patient, date) IN (
        SELECT id_patient, MIN(date)
        FROM temp_rendez_vous
        GROUP BY
            id_patient
    );

-- Insérer les rendez-vous
INSERT INTO
    rendez_vous (
        date,
        motif,
        isFirst,
        fk_medecin,
        fk_patient
    )
SELECT
    trv.date,
    trv.motif,
    trv.is_first,
    m.id AS fk_medecin, -- ID auto-généré du médecin
    p.id AS fk_patient -- ID auto-généré du patient
FROM
    temp_rendez_vous trv
    JOIN medecin m ON m.fk_personne = trv.id_medecin -- Jointure sur FK personne
    JOIN patient p ON p.fk_personne = trv.id_patient -- Jointure sur FK personne
WHERE
    trv.id_patient IS NOT NULL
    AND trv.id_medecin IS NOT NULL
ON CONFLICT DO NOTHING;

-- Insérer les médicaments
INSERT INTO
    medicament (id, nom, dosage, type)
SELECT id, nom, dosage, type
FROM temp_medicament
WHERE
    id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Insérer les prescriptions
INSERT INTO
    prescription (
        date_debut,
        date_fin,
        fk_rendez_vous,
        fk_medecin,
        fk_medicament
    )
SELECT
    rv.date AS date_debut,
    rv.date + (tp.duree_jours || ' days')::interval AS date_fin,
    rv.id AS fk_rendez_vous,
    rv.fk_medecin, -- Utilise l'ID correct du médecin depuis rendez_vous
    tp.id_medicament AS fk_medicament
FROM
    temp_prescription tp
    JOIN temp_rendez_vous trv ON trv.id = tp.id_rendez_vous
    JOIN rendez_vous rv ON rv.date = trv.date
    AND rv.fk_patient = (
        SELECT p.id
        FROM patient p
        WHERE
            p.fk_personne = trv.id_patient
    )
    AND rv.fk_medecin = (
        SELECT m.id
        FROM medecin m
        WHERE
            m.fk_personne = trv.id_medecin
    )
WHERE
    tp.id IS NOT NULL
    AND tp.id_medicament IS NOT NULL
    AND EXISTS (
        SELECT 1
        FROM medicament
        WHERE
            id = tp.id_medicament
    )
ON CONFLICT DO NOTHING;