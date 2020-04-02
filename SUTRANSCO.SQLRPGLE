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

  exec sql
  create collection transcotu;

  // message erreur collection
  Assert(SqlCode = 0
        :'Erreur création collection transcotu : SqlCode = ' + %Char(SqlCode));


  // creation table TRANSCOTU/transcof
  exec sql
  create table transcotu/transcof (
    code_entree char(20),
    code_sortie dec(5)
  );

  // message erreur table
  Assert(SqlCode = 0
        :'Erreur creation table transcotu/transcof ' + %Char(SqlCode));


  AddLibLe();

end-proc;

//--------------------------------------------------------------------
// Procédure début: AddLibLe
//------------------------------------------------------------------
Dcl-Proc AddLibLe;
  Dcl-S rc              Int(10);

  wCommande = 'AddLibLe Lib(transcotu)';

  // Execution commande
  rc = ExecCmd(%Trim(wCommande));

  Assert(rc = 0
        :'Une erreur est survenue lors du AddLibLe de transcotu');
End-Proc; 
