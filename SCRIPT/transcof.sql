-- table transcof fake data test dans ma BIB perso

-- creer la table
create table transcof (
  code_entree char(20),
  code_sortie packed(5:0)
  );
  
  commit;
  
-- supprimer la table
drop table transcof;

-- ajouter data
insert into transcof
  (code_entree, code_sortie)
  values ('CHRISTIAN', 12345),
         ('JAMES', 7000) with NC;
         
-- voir la table transcof
select * from transcof;

-- recupere le code sortie correspondant à 1 param
select code_sortie 
from transcof
where code_entree='CHRISTIAN';
