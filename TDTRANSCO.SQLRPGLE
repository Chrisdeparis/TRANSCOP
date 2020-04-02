**free
ctl-opt nomain;

/copy RPGUNIT/RPGUNIT1,TESTCASE
/copy h1frptechs/QCOPSRC,s_errorDS

dcl-s wCommande    char(512);
dcl-s wrc          int(10);

dcl-pr execcmd    int(10) extproc('system');
  cmdstring     pointer value   options(*string);
end-pr;

dcl-pr tearDown end-pr;

//---------------------------------------------------------------//
//Procédure de nettoyage en fin de test (appelée en sortie)
dcl-proc tearDown export;

  dcl-pi *n;

  end-pi;

end-proc;
// Procédure fin: ENDJRNPF
//------------------------------------------------------------------
dcl-proc endjrnpf;

  wCommande = 'ENDJRNPF FILE(*ALL) JRN(t_fahrtoce/QSQJRN)';

  // execution commande
  wrc = execCmd(%trim(wcommande));

  assert (wrc=0
         :'Une erreur est survenue lors du endjrnpf, rc = '
          + %char(wrc)
         );
end-proc;

// Procédure fin: DLTJRNRCV
//------------------------------------------------------------------
dcl-proc dltjrnrcv;

  wCommande = 'DLTJRNRCV JRNRCV(t_cel2fahr/QSQJR*) DLTOPT(*IGNINQMSG)';

  // execution commande
  wrc = execCmd(%trim(wcommande));

  assert(wrc=0
      :'Une erreur est survenue lors du dltjrnrcv');

end-proc;

// Procédure fin: DLTJRN
//------------------------------------------------------------------
dcl-proc dltjrn;

  wCommande = 'DLTJRN JRN(t_cel2fahr/QSQJRN)';

  // execution commande
  wrc = execCmd(%trim(wcommande));

  assert(wrc=0
      :'Une erreur est survenue lors du dltjrn');

end-proc;

//------------------------------------------------
dcl-proc rmvlible export;

  dcl-pi *n;
    library    char(10) const;
  end-pi;

  wcommande = 'RMVLIBLE LIB('
              + %trim(library)
              + ')';

  // execution commande
  wrc = execCmd(%trim(wcommande));

  assert (wrc=0
         :'Erreur lors du rmvlible de ' + library
         );

end-proc; 
