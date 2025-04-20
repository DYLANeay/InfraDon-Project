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

npx webpack --env API_KEY=KCTHAJZQZNWSG2EP9Y3X7XBBB

-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQDCFENGw33yGihy92pDjZQhl0C36rPJj+CvfSC8+q28hxA161QF
NUd13wuCTUcq0Qd2qsBe/2hFyc2DCJJg0h1L78+6Z4UMR7EOcpfdUE9Hf3m/hs+F
UR45uBJeDK1HSFHD8bHKD6kv8FPGfJTotc+2xjJwoYi+1hqp1fIekaxsyQIDAQAB
AoGBAJR8ZkCUvx5kzv+utdl7T5MnordT1TvoXXJGXK7ZZ+UuvMNUCdN2QPc4sBiA
QWvLw1cSKt5DsKZ8UETpYPy8pPYnnDEz2dDYiaew9+xEpubyeW2oH4Zx71wqBtOK
kqwrXa/pzdpiucRRjk6vE6YY7EBBs/g7uanVpGibOVAEsqH1AkEA7DkjVH28WDUg
f1nqvfn2Kj6CT7nIcE3jGJsZZ7zlZmBmHFDONMLUrXR/Zm3pR5m0tCmBqa5RK95u
412jt1dPIwJBANJT3v8pnkth48bQo/fKel6uEYyboRtA5/uHuHkZ6FQF7OUkGogc
mSJluOdc5t6hI1VsLn0QZEjQZMEOWr+wKSMCQQCC4kXJEsHAve77oP6HtG/IiEn7
kpyUXRNvFsDE0czpJJBvL/aRFUJxuRK91jhjC68sA7NsKMGg5OXb5I5Jj36xAkEA
gIT7aFOYBFwGgQAQkWNKLvySgKbAZRTeLBacpHMuQdl1DfdntvAyqpAZ0lY0RKmW
G6aFKaqQfOXKCyWoUiVknQJAXrlgySFci/2ueKlIE1QqIiLSZ8V8OlpFLRnb1pzI
7U1yQXnTAEFYM560yJlzUpOb1V4cScGd365tiSMvxLOvTA==
-----END RSA PRIVATE KEY-----


