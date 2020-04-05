# RPG : TRANSCOP

**_Exercice de transcodage_** : 

## Les DS en paramètres 
#### TRANSCODS en entrée

Ce programme a pour fonction de recevoir en **[PARAMETRE](https://github.com/Chrisdeparis/TRANSCOP/blob/master/QCOPSRC/TRANSCODS.RPGLE)** un code (long 20 alpha, exemple type client : '_code_entree_'.

## La table DB2/SQL
#### TRANSCOF
Il devra contrôler que le code en entrée est renseigné, si le code est renseigné alors il faudra chercher la correspondance de code dans une table (à créer).

Si le code est trouvé dans la table, alors le programme renvoie la valeur de correspondance dans le paramètre en sortie.
Le _code de sortie_ (trouvé dans la table) sera de type numérique (packed(5:0)).
 
Exemple de correspondance : dans la table **[TRANSCOF](https://github.com/Chrisdeparis/TRANSCOP/blob/master/SCRIPT/transcof.sql)**

```sql
    // chercher la correspondance entre la table et le paramètre
    exec sql
    select  code_sortie
    into :w_codesortie
    from transcof
    where code_entree = upper(:w_codeentree);
```

La table **TRANSCOF** a 2 colonnes _code_entree char(20), code_sortie packed(5:0)._ ⚠

|   code_entree  |  code_sortie  |
|:--------------:|:-------------:|
|   CHRISTIAN    |  12345        |
|   JAMES        |  7000         |

## Le programme TRANSCOP
#### TRANSCODS en sortie
Le programme **[TRANSCOP](https://github.com/Chrisdeparis/TRANSCOP/blob/master/QRPGLESRC/TRANSCOP.SQLRPGLE)** retourne 2 paramètres le _code_sortie_ et le _returncode_.      ✅
```diff
+ > // call transcop parm('christian')                ✅          
+ > =>  DSPLY  sqlcode 0 code_sortie 12345 trouvé     ✅  
+ > =>  DSPLY  returnCode = 0                         ✅   
```

le comportement attendu : ⚠ 	
si le code d'entrée est à blanc -> erreur : return code = 1
=> OK
```diff
+ > call transcop parm('')                           
+ > DSPLY  Veuillez renseigner le code entree 
+ > DSPLY  returnCode = 1      
```
si le code d'entrée n'est pas trouvé dans la table -> erreur : return code = 1

## Le TDD avec RPGUnit 
#### [SUTRANSCO](https://github.com/Chrisdeparis/TRANSCOP/blob/master/ADHTU/SUTRANSCO.SQLRPGLE), [TRANSCOTU](https://github.com/Chrisdeparis/TRANSCOP/blob/master/ADHTU/TRANSCOTU.SQLRPGLE) et [TDTRANSCO](https://github.com/Chrisdeparis/TRANSCOP/blob/master/ADHTU/TDTRANSCO.SQLRPGLE)
Il s'agit dans cet exercice de se mettre en mode **TDD (test driven development)** ⚠⚠⚠ d'écrire une fonctionnalité dans **_transcop_** et d'écrire le cas de test (progamme de tu) correspondant (ex : contrôle paramètre entrant), d'écrire la fonctionnalité suivante (recherche code sortie dans la table) et de coder le cas de test correspondant. 

Je pense à 3 cas de tests :
> - cas 01 (non passant) : paramètre à blanc -> return code  = 1     ✅
> - cas 02 (non passant) : paramètre valide ( code_entrée = 'TOTO' ) mais code non trouvé dans la table -> return code = 1    ✅
> - cas 03 (cas passant) : paramètre valide ( code_entrée = 'JAMES' ) et code trouvé dans la table -> return code = 0, et code_sortie = 7000    ✅

Dans le **[SETUP](https://github.com/Chrisdeparis/TRANSCOP/blob/master/ADHTU/SUTRANSCO.SQLRPGLE)** il faudra créer la table _transcoF_ dans la bibliothèque _transcoTU_ (et la supprimer dans **[TEAR DOWN](https://github.com/Chrisdeparis/TRANSCOP/blob/master/ADHTU/TDTRANSCO.SQLRPGLE)**).    ✅

## ChargeDB2 en test unitaire

Pour les cas 02 et 03 il faudra utiliser **[chargeDB2](https://github.com/Chrisdeparis/TRANSCOP/blob/master/ADHTU/TRANSCOTU.SQLRPGLE)** pour insérer des lignes dans la table _transcoF_, donc créer créer un script sql transco02.sql et  transco03.sql   ✅

- Comment bien créer les script de test avec les data ? pour les cas 2 et 3

Les scripts de tests sont à ajouter en intégration dans l'IFS : ⚠
> [Application/Adhesion/TU/ChargeDB2/t_transco/transco02.sql](https://github.com/Chrisdeparis/TRANSCOP/blob/master/CHARGEDB2/transco02.sql)    ✅
> [Application/Adhesion/TU/ChargeDB2/t_transco/transco03.sql](https://github.com/Chrisdeparis/TRANSCOP/blob/master/CHARGEDB2/transco03.sql)    ✅

## Les modules et programme de service
#### T_TRANSCO pour tout regrouper ensemble
- Le CLLE de Test Unitaire **[T_TRANSCO](https://github.com/Chrisdeparis/TRANSCOP/blob/master/QCLSRC/T_TRANSCO.CLLE)** : gère la création des modules de TU et du programme de service de test avec l'envoi en intégration.
```diff
+ > CALL T_TRANSCO    ✅
```

## Nota Bene

Ne pas oublier de compiler le programme **[TRANSCOP](https://github.com/Chrisdeparis/TRANSCOP/blob/master/QRPGLESRC/TRANSCOP.SQLRPGLE)** après toute modification sur ASDEV : ⚠
```diff
+ > CRTSQLRPGI OBJ(MILFORT/TRANSCOP)    ✅
```
Et d'envoyer les modifications en intégration : ⚠⚠⚠ 
```diff
+ > SAVRSTOBJ OBJ(TRANSCOP) LIB(MILFORT) RMTLOCNAME(SRV0803)  ✅
```
- En Dev : 
```diff
+ > CALL TRANSCOP PARM('CHRISTIAN')
> =>  DSPLY  sqlcode 0 code_sortie 12345 trouvé     ✅  
> =>  DSPLY  returnCode = 0                         ✅  
```

- En intégration : SRV0803 lancer les tests...
```diff
+ > RUCALLTST T_TRANSCO  ✅
+ Success. 3 test cases, 30 assertions, 0 failure, 0 error.        ✅
 ```


