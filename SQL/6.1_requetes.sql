-- Active: 1741351947031@@127.0.0.1@5432@hopital
-- 1 nombre de prescription par patient
SELECT
    COUNT(prescription) AS "Nombre de prescription",
    patient.id,
    personne.nom,
    personne.prenom
FROM
    prescription
    JOIN rendez_vous ON prescription.fk_rendez_vous = rendez_vous.id
    JOIN patient ON rendez_vous.fk_patient = patient.id
    JOIN personne ON personne.id = patient.fk_personne
GROUP BY
    patient.id,
    personne.nom,
    personne.prenom

-- 2. afficher la liste des consultations avec les patients et les rendez vous associé
SELECT COUNT(rendez_vous) AS "Consultation", rendez_vous.motif, personne.nom, personne.prenom
FROM
    rendez_vous
    JOIN patient ON rendez_vous.fk_patient = patient.id
    JOIN personne ON personne.id = patient.fk_personne
WHERE
    rendez_vous.motif = 'Consultation'
GROUP BY
    rendez_vous.motif,
    personne.nom,
    personne.prenom

-- 3.afficher la spécialité avec le plus de RDV
SELECT medecin.specialite, COUNT(rendez_vous) AS "Total spécialité"
FROM rendez_vous
    JOIN medecin ON medecin.id = rendez_vous.fk_medecin
GROUP BY
    medecin.specialite
ORDER BY COUNT(rendez_vous) DESC
LIMIT 1;