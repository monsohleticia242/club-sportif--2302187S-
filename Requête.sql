set search_path to gym_proactif;


-- Affiche les étudiants avec leurs informations de base
select nom, prenom, email, type_client
from clients
where type_client = 'etudiant'
order by nom, prenom;

-- Montre qui a quel forfait actuellement
select c.nom, c.prenom, f.nom_forfait, a.prix_paye, a.date_fin
from clients c
         inner join abonnements a on c.id = a.id_client
         inner join forfaits f on a.id_forfait = f.id
where a.statut = 'actif'
order by c.nom;

-- Calcule combien chaque forfait rapporte null
select f.nom_forfait,
       count(a.id) as nombre_abonnements,
       sum(a.prix_paye) as revenus_total,
       avg(a.prix_paye) as prix_moyen
from forfaits f
         left join abonnements a on f.id = a.id_forfait
group by f.id, f.nom_forfait
order by revenus_total desc;



-- Montre quels services sont les plus demandés
select s.nom_service,
       count(fs.id_forfait) as nombre_forfaits_inclus
from services s
         left join forfait_services fs on s.id = fs.id_service
group by s.id, s.nom_service
order by nombre_forfaits_inclus desc, s.nom_service;



-- Trouve les membres qui ne participent pas aux activités (tout le monde participe a une activité)
select c.nom, c.prenom, c.email
from clients c
where c.id not in (
    select distinct p.id_client
    from participations p
    where p.id_client is not null
)
order by c.nom;


-- Liste simple des participants
select distinct c.nom, c.prenom, c.email
from clients c
         inner join participations p on c.id = p.id_client
order by c.nom;


-- Services jamais utilisés dans aucun forfait ( tous les services sont utilisées)
select s.nom_service, s.description
from services s
         left join forfait_services fs on s.id = fs.id_service
where fs.id_service is null;