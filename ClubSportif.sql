
create schema gym_proactif;


set search_path to gym_proactif;



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


-- TABLE FORFAIT_SERVICES
-- Relation plusieurs-à-plusieurs : un forfait peut inclure plusieurs services
-- et un service peut être dans plusieurs forfaits

create table forfait_services
(
    id_forfait  integer not null,                      -- Forfait concerné (clé étrangère)
    id_service  integer not null,                      -- Service inclus (clé étrangère)
    date_ajout  date default current_date,             -- Date d'ajout du service au forfait
    primary key (id_forfait, id_service),              -- Clé primaire composée (combinaison unique)
    foreign key (id_forfait) references forfaits(id),  -- Lien vers le forfait
    foreign key (id_service) references services(id)   -- Lien vers le service
);

