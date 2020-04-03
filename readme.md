# Ecriture d'un programme RPG : transcoP

## comme NOMCLI

Ce programme a pour fonction de recevoir en paramètre un code (long 20 alpha, exemple type client : 'code_entree'.

Il devra contrôler que le code en entrée est renseigné, si le code est renseigné alors il faudra chercher la correspondance de code dans une table (à créer).

 Si le code est trouvé dans la table, alors le programme renvoie la valeur de correspondance dans le paramètre en sortie.
 Le code de sortie (trouvé dans la table) sera de type numérique (packed(5:0)).
 
Exemple de correspondance :
>  'code_entree'  -> 12345 (code retourné par le programme provenant de la table)


la table transcoF a 2 colonnes code_entree char(20), code_sortie packed(5:0)

le programme retourne 2 paramètres le returncode et le code de sortie.

> // call transcop parm('christian')
> =>  DSPLY  sqlcode 0 code_sortie 12345 trouvé    
> =>  DSPLY  returnCode = 0                        

le comportement attendu :   	
si le code d'entrée est à blanc -> erreur : return code = 1
=> OK
> call transcop parm('')                           
> DSPLY  Veuillez renseigner le code entree 
> DSPLY  returnCode = 1                            
si le code d'entrée n'est pas trouvé dans la table -> erreur : return code = 1

Il s'agit dans cet exercice de se mettre en mode TDD (test driven development) d'écrire une fonctionnalité dans transco et d'écrire le cas de test (progamme de tu) correspondant (ex : contrôle paramètre entrant), d'écrire la fonctionnalité suivante (recherche code sortie dans la table) et de coder le cas de test correspondant.

Je pense à 3 cas de tests :
- cas 01 (non passant) : paramètre à blanc -> return code  = 1
- cas 02 (non passant) : paramètre valide ( code_entrée = 'TOTO' ) mais code non trouvé dans la table -> return code = 1
- cas 03 (cas passant) : paramètre valide ( code_entrée = 'JAMES' ) et code trouvé dans la table -> return code = 0, et code_sortie = 7000

Dans le setup il faudra créer la table transcoF dans la bibliothèque transcoTU (et la supprimer dans tear down).
Pour les cas 02 et 03 il faudra utiliser chargeDB2 pour insérer des lignes dans la table transcoF, donc créer créer un script sql transco02.sql et  transco03.sql


- Comment bien créer les script de test avec les data ? pour les cas 2 et 3

Les scripts de tests sont à ajouter dans l'IFS Application/Adhesion/TU/ChargeDB2/letest

