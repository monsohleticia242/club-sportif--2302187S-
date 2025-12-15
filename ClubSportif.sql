
DROP SCHEMA if exists gym_proactif CASCADE;

create schema gym_proactif;


set search_path to gym_proactif;


-- TABLE CLIENT

create table clients
(
    id              integer generated always as identity primary key, -- Clé primaire auto-générée
    nom             varchar(50) not null,     -- Nom de famille obligatoire
    prenom          varchar(50) not null,     -- Prénom obligatoire  
    date_naissance  date not null,            -- Date de naissance pour calculer l'âge
    telephone       varchar(15),              -- Numéro de téléphone (optionnel)
    email           varchar(100) unique,      -- Email unique pour éviter les doublons
    adresse         varchar(200),             -- Adresse complète du client
    type_client     varchar(20) not null      -- Type: 'etudiant', 'regulier', 'famille'
);


-- TABLE FORFAITS


create table forfaits
(
    id               integer generated always as identity primary key, -- Identifiant unique du forfait
    nom_forfait      varchar(50) not null unique,  -- Nom du forfait (ex: "Forfait Découverte")
    prix_mensuel     decimal(6,2) not null,        -- Prix en dollars (ex: 40.97)
    description      text,                         -- Description détaillée des avantages
    duree_engagement integer not null              -- Durée d'engagement en mois
);


-- TABLE SERVICES


create table services
(
    id           integer generated always as identity primary key, -- Identifiant unique du service
    nom_service  varchar(50) not null unique,  -- Nom du service (ex: "Sauna", "Wi-Fi")
    description  text                          -- Description du service offert
);


-- TABLE EMPLOYES


create table employes
(
    id            integer generated always as identity primary key, -- Identifiant unique de l'employé
    nom           varchar(50) not null,         -- Nom de famille
    prenom        varchar(50) not null,         -- Prénom
    poste         varchar(50) not null,         -- Fonction (ex: "Entraîneur", "Réceptionniste")
    telephone     varchar(15),                  -- Téléphone de contact
    email         varchar(100) unique,          -- Email professionnel unique
    date_embauche date default current_date,    -- Date d'embauche (automatique si non spécifiée)
    salaire       decimal(8,2)                  -- Salaire annuel en dollars
);


-- TABLE FORFAIT_SERVICES
-- Relation plusieurs-à-plusieurs : un forfait peut inclure plusieurs services
-- et un service peut être dans plusieurs forfaits

create table forfait_services
(
    id_forfait  integer not null,                      -- Forfait concerné (clé étrangère)
    id_service  integer not null,                      -- Service inclus (clé étrangère)
    date_ajout  date default current_date,             -- Date d'ajout du service au forfait
    primary key (id_forfait, id_service),              -- Clé primaire composée
    foreign key (id_forfait) references forfaits(id),  -- Lien vers le forfait
    foreign key (id_service) references services(id)   -- Lien vers le service
);


-- TABLE ABONNEMENTS


create table abonnements
(
    id          integer generated always as identity primary key, -- Identifiant unique de l'abonnement
    id_client   integer not null,              -- Référence vers le client (clé étrangère)
    id_forfait  integer not null,              -- Référence vers le forfait choisi (clé étrangère)
    date_debut  date not null,                 -- Date de début de l'abonnement
    date_fin    date not null,                 -- Date de fin de l'abonnement
    statut      varchar(20) default 'actif',   -- État: 'actif', 'inactif', 'suspendu', 'expire'
    prix_paye   decimal(6,2) not null,         -- Montant réellement payé par le client
    foreign key (id_client) references clients(id),    -- Lien vers la table clients
    foreign key (id_forfait) references forfaits(id)   -- Lien vers la table forfaits
);


-- TABLE COURS


create table cours
(
    id             integer generated always as identity primary key, -- Identifiant unique du cours
    id_employe     integer not null,           -- Employé qui anime le cours (clé étrangère)
    nom_cours      varchar(50) not null,       -- Nom du cours (ex: "Yoga", "Musculation")
    description    text,                       -- Description du contenu du cours
    duree_minutes  integer not null,           -- Durée en minutes (ex: 60 pour 1 heure)
    capacite_max   integer not null,           -- Nombre maximum de participants
    foreign key (id_employe) references employes(id)   -- Lien vers l'employé instructeur
);


-- TABLE HORAIRES

create table horaires
(
    id                  integer generated always as identity primary key, -- Identifiant unique de la session
    id_cours            integer not null,        -- Type de cours programmé (clé étrangère)
    date_heure          timestamp not null,      -- Date et heure exacte du cours
    places_disponibles  integer not null,        -- Nombre de places encore libres
    foreign key (id_cours) references cours(id) -- Lien vers le type de cours
);


-- TABLE PARTICIPATIONS

create table participations
(
    id               integer generated always as identity primary key, -- Identifiant unique de la participation
    id_client        integer not null,                -- Client qui s'inscrit (clé étrangère)
    id_horaire       integer not null,                -- Session de cours choisie (clé étrangère)
    date_inscription date default current_date,        -- Date d'inscription (automatique)
    present          boolean default false,            -- Le client était-il présent? (vrai/faux)
    foreign key (id_client) references clients(id),    -- Lien vers le client
    foreign key (id_horaire) references horaires(id),  -- Lien vers la session
    unique (id_client, id_horaire)                     -- Un client ne peut s'inscrire qu'une fois par session
);


-- TABLE PAIEMENTS

create table paiements
(
    id                integer generated always as identity primary key, -- Identifiant unique du paiement
    id_abonnement     integer not null,                -- Abonnement payé (clé étrangère)
    montant           decimal(8,2) not null,           -- Montant payé en dollars
    date_paiement     date default current_date,       -- Date du paiement (automatique)
    methode_paiement  varchar(20) not null,            -- Mode: 'carte', 'comptant', 'virement', 'cheque'
    foreign key (id_abonnement) references abonnements(id) -- Lien vers l'abonnement concerné
);





insert into clients (nom, prenom, date_naissance, telephone, email, adresse, type_client)
values
    ('Tremblay', 'Marie', '2003-05-15', '819-555-1001', 'marie.tremblay@email.com', '123 Rue des Étudiants, Drummondville', 'etudiant'),
    ('Dubois', 'Jean', '1985-03-22', '819-555-1002', 'jean.dubois@email.com', '456 Ave Principale, Drummondville', 'regulier'),
    ('Martin', 'Sophie', '1992-11-08', '819-555-1003', 'sophie.martin@email.com', '789 Boul Saint-Joseph, Drummondville', 'regulier'),
    ('Gagnon', 'Pierre', '1978-07-12', '819-555-1004', 'pierre.gagnon@email.com', '321 Rue des Pins, Drummondville', 'famille'),
    ('Lavoie', 'Amélie', '2001-09-30', '819-555-1005', 'amelie.lavoie@email.com', '654 Ave des Érables, Drummondville', 'etudiant');


insert into forfaits (nom_forfait, prix_mensuel, description, duree_engagement)
values
    ('Forfait Découverte', 40.97, 'Accès équipement, vestiaires, sauna, Wi-Fi, 24/7', 12),
    ('Forfait Évolution', 49.58, 'Découverte + cours illimités + programme entraînement', 12),
    ('Forfait Jeune Énergie', 30.97, 'Forfait étudiant avec tous les avantages de base', 6),
    ('Forfait Famille', 34.97, 'Tarif avantageux pour les familles', 12),
    ('Forfait Corporatif', 38.00, 'Forfait spécial entreprises', 24);

insert into services (nom_service, description)
values
    ('Accès équipement', 'Accès à tous les appareils de musculation et cardio'),
    ('Vestiaires et sauna', 'Vestiaires avec casiers et sauna finlandais'),
    ('Wi-Fi gratuit', 'Internet haute vitesse dans tout le gym'),
    ('Rabais partenaires', 'Réductions chez les commerces partenaires'),
    ('Accès 24/7', 'Gym ouvert 24 heures sur 24, 7 jours sur 7');

insert into employes (nom, prenom, poste, telephone, email, salaire)
values
    ('Roy', 'Isabelle', 'Instructrice yoga', '819-555-2002', 'isabelle.roy@gymproactif.com', 38000.00),
    ('Simard', 'Marc', 'Responsable maintenance', '819-555-2003', 'marc.simard@gymproactif.com', 42000.00),
    ('Pelletier', 'Julie', 'Réceptionniste', '819-555-2004', 'julie.pelletier@gymproactif.com', 35000.00),
    ('Bergeron', 'David', 'Entraîneur HIIT', '819-555-2005', 'david.bergeron@gymproactif.com', 40000.00);



insert into forfait_services (id_forfait, id_service)
values
    -- Forfait Découverte (services de base)
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
    -- Forfait Évolution (services de base uniquement )
    (2, 1), (2, 2), (2, 3), (2, 4), (2, 5),
    -- Forfait Jeune Énergie (services de base)
    (3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
    -- Forfait Famille (services de base)
    (4, 1), (4, 2), (4, 3), (4, 4), (4, 5),
    -- Forfait Corporatif (services de base)
    (5, 1), (5, 2), (5, 3), (5, 4), (5, 5);


-- ABONNEMENTS


insert into abonnements (id_client, id_forfait, date_debut, date_fin, statut, prix_paye)
values
    (1, 3, '2024-09-01', '2025-03-01', 'actif', 30.97),    -- Marie - Forfait Jeune Énergie
    (2, 2, '2024-01-15', '2025-01-15', 'actif', 49.58),    -- Jean - Forfait Évolution
    (3, 1, '2024-06-01', '2025-06-01', 'actif', 40.97),    -- Sophie - Forfait Découverte
    (4, 4, '2024-03-01', '2025-03-01', 'actif', 34.97),    -- Pierre - Forfait Famille
    (5, 3, '2024-10-01', '2025-04-01', 'actif', 30.97);    -- Amélie - Forfait Jeune Énergie

insert into cours (id_employe, nom_cours, description, duree_minutes, capacite_max)
values
    (1, 'Musculation débutant', 'Initiation aux techniques de base', 60, 8),
    (2, 'Yoga matinal', 'Séance relaxante pour bien commencer', 75, 15),
    (2, 'Pilates', 'Renforcement du core et souplesse', 60, 12),
    (1, 'Musculation avancé', 'Pour les membres expérimentés', 90, 6);

insert into horaires (id_cours, date_heure, places_disponibles)
values
    (1, '2024-12-02 18:00:00', 5),   -- Musculation lundi 18h
    (2, '2024-12-03 07:00:00', 12),  -- Yoga mardi 7h
    (3, '2024-12-03 19:00:00', 8),   -- Pilates mardi 19h
    (4, '2024-12-04 17:30:00', 6),   -- HIIT mercredi 17h30
    (2, '2024-12-06 07:00:00', 10);  -- Yoga vendredi 7h

insert into participations (id_client, id_horaire, present)
values
    (2, 1, true),   -- Jean au cours de musculation (présent)
    (3, 2, true),   -- Sophie au yoga (présente)
    (1, 2, true),   -- Marie au yoga (présente)
    (2, 3, false),  -- Jean au pilates (absent)
    (4, 4, true),   -- Pierre au HIIT (présent)
    (5, 2, false);  -- Amélie au yoga (absente)

insert into paiements (id_abonnement, montant, date_paiement, methode_paiement)
values
    (1, 30.97, '2024-09-01', 'carte'),      -- Paiement Marie
    (2, 49.58, '2024-01-15', 'virement'),   -- Paiement Jean
    (3, 40.97, '2024-06-01', 'carte'),      -- Paiement Sophie
    (4, 34.97, '2024-03-01', 'comptant'),   -- Paiement Pierre
    (5, 30.97, '2024-10-01', 'carte');     -- Paiement Amélie


