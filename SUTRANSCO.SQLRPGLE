**free
ctl-opt nomain;

/copy RPGUNIT/RPGUNIT1,TESTCASE

  dcl-s wCommande   char(512);
  dcl-s wrc          int(10);

// définition des prototypes
dcl-pr setUp;
end-pr;

dcl-pr execcmd    int(10) extproc('system');
  cmdstring     pointer value   options(*string);
end-pr;

//---------------------------------------------------------------//
//  Procédure de mise en place des tests, appelée en entrée
//  elle permet d'initialiser l'environnement (bdd) pour avoir
//  des jeux de test toujours identiques et propres

dcl-proc setUp  export;

  dcl-pi *n;

  end-pi;

//  exec sql
//  create collection transcotu;
//
//  create table transcotu.transcoF (
//    code_entree char(20),
//    code_sortie dec(5)
//  );



end-proc;

//-------------------------------------------------------------------- 
