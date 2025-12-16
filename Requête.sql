set search_path to gym_proactif;

-- 1.  liste des clients étudiants

select nom, prenom, email
from clients
where type_client = 'etudiant'
order by nom;


-- 2. jointure  - clients avec leurs forfaits

select c.nom, c.prenom, f.nom_forfait, a.prix_paye
from clients c
         inner join abonnements a on c.id = a.id_client
         inner join forfaits f on a.id_forfait = f.id
order by c.nom;

-- 3. agrégation  - nombre d'abonnements par forfait

select f.nom_forfait, count(a.id) as nombre_abonnements
from forfaits f
         left join abonnements a on f.id = a.id_forfait
group by f.nom_forfait
order by nombre_abonnements desc;



-- 4. jointure avec employés - qui donne quels cours
select e.prenom, e.nom, c.nom_cours, c.duree_minutes
from employes e
         inner join cours c on e.id = c.id_employe
order by e.nom;

-- 5. sous-requête  - forfaits plus chers que 35$
select nom_forfait, prix_mensuel
from forfaits
where prix_mensuel > (select avg(prix_mensuel) from forfaits)
order by prix_mensuel desc;


-- 6. cours les plus populaires
select c.nom_cours, count(p.id) as nombre_participations
from cours c
         left join horaires h on c.id = h.id_cours
         left join participations p on h.id = p.id_horaire
group by c.nom_cours
order by nombre_participations desc;


-- 7. agrégation - total des paiements par méthode
select methode_paiement,
       count(*) as nombre_paiements,
       sum(montant) as total_montant
from paiements
group by methode_paiement
order by total_montant desc;

-- 8. jointure left - tous les services et leur utilisation
select s.nom_service, count(fs.id_forfait) as nombre_forfaits
from services s
         left join forfait_services fs on s.id = fs.id_service
group by s.nom_service
order by nombre_forfaits desc;

-- 9. requête avec calculs - âge des clients

select nom, prenom, date_naissance,
       extract(year from age(date_naissance)) as age,
       type_client
from clients
where extract(year from age(date_naissance)) between 18 and 30
order by age desc;

-- 10.qui n'a pas encore payé ( tout le monde est a jour )
select c.nom, c.prenom, a.prix_paye
from clients c
         inner join abonnements a on c.id = a.id_client
         left join paiements p on a.id = p.id_abonnement
where p.id is null;