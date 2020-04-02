**free
ctl-opt nomain;

/copy RPGUNIT/RPGUNIT1,TESTCASE
/copy h1frptechs/QCOPSRC,s_errorDS

dcl-s wCommande    char(512);
dcl-s wrc          int(10);

dcl-pr execcmd    int(10) extproc('system');
  cmdstring     pointer value   options(*string);
end-pr;

dcl-pr tearDown
end-pr;

Dcl-Pr RmvLibLe;
End-Pr;

//---------------------------------------------------------------//
//Procédure de nettoyage en fin de test (appelée en sortie)
dcl-proc tearDown export;

  dcl-pi *n;
  end-pi;

  RmvLibLe();

  // Suppression de la journalisation
  SuppJourn();

  // Suppression de la table
  exec sql
  drop table transcotu/transcof;

  // Suppression de la collection transcotu qui contient la table
  exec sql
  drop collection transcotu;

  Assert(SqlCode = 0
        :'Erreur lors de la suppression de la collection transcotu, '
        + 'SqlCode = ' + %Char(SqlCode));

end-proc;

//------------------------------------------------------------------
// Suppression de la journalisation
//------------------------------------------------------------------
Dcl-Proc SuppJourn;

  // Arrêter la journalisation de fichier physique
  wCommande = 'EndJrnPf File(*All) Jrn(transcotu/QSQJRN)';
  wRc = ExecCmd(%trim(wCommande));

  Assert (wRc = 0
         :'Une erreur est survenue lors du EndJrnPf, rc = ' + %Char(wRc)
         );

  // Supprimer le journal
  wCommande = 'DltJrn Jrn(transcotu/QSQJRN)';
  wRc = ExecCmd(%trim(wCommande));

  Assert(wRc = 0
        :'Une erreur est survenue lors du DltJrn, rc = ' + %Char(wRc)
        );

  // Supprimer le récepteur du journal
  wCommande = 'DltJrnRcv JrnRcv(transcotu/QSQJR*) DltOpt(*IgnInqMsg)';
  wRc = ExecCmd(%trim(wCommande));

  Assert(wRc = 0
        :'Une erreur est survenue lors du DltJrnRcv, rc = ' + %Char(wRc)
        );
End-Proc;

//------------------------------------------------------------------
// Procédure debut: rmvlible_Moc
//------------------------------------------------------------------
Dcl-Proc RmvLibLe;

  wCommande = 'RmvLibLe Lib(transcotu)';

  // Execution commande
  wRc = execCmd(%Trim(wCommande));

  Assert(wRc = 0
        :'Une erreur est survenue lors du RmvLibLe');

End-Proc; 
