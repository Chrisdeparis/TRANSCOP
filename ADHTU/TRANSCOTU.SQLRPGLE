**free
ctl-opt nomain;

/copy RPGUNIT/RPGUNIT1,TESTCASE
/copy h1frptechs/qcopsrc,s_spvDS
/copy MILFORT/qcopsrc,transcoDs

// pgm a tester
dcl-pr transcop extpgm('TRANSCOP');
  toto likeDs(transcoDs_template);
end-pr;

dcl-ds transcoDs likeDs(transcoDs_template);

// définition des constantes
dcl-c APPLICATION    const('ADHTU');

// définition des variables
dcl-s wcurrentdate   date;
dcl-s wvanpalier     packed(18:11);
dcl-s rc             int(10);
dcl-s wCommande      char(512);

dcl-s w_codeEntree   char(20);
dcl-s w_codeSortie   packed(5);
dcl-s w_returnCode   int(10);


// définition des prototypes
dcl-pr execcmd    int(10) extproc('system');
  cmdstring     pointer value   options(*string);
end-pr;

dcl-pr chargeDB2  ;
  nomTest  char(10) const;
  testCase char(10) const;
end-pr;

//==============================================================
// CAS de TEST 1 : (non passant) : paramètre à blanc -> return code  = 1

dcl-proc test_01_codeEntreeVide export;

  clear transcoDs;
  transcoDs.inDs.code_entree = '';

  // appel
  TRANSCOP(transcoDs);

  // resultat attendu :  paramètre à blanc -> return code  = 1
  // assert(condition pour que le test soit OK : contexte de l'erreur)
  assert (transcoDs.ouDs.returnCode = 1
         :'Erreur : non détectée par TRANSCOP'
         );

end-proc;

//==============================================================
// CAS de TEST 2 : (non passant) : paramètre valide ( code_entrée = 'code_entree' )
// mais code non trouvé dans la table -> return code = 1

dcl-proc test_02_codeEntreeOkcodeSortieNonTrouve export;

  clear transcoDs;
  transcoDs.inDs.code_entree = 'TOTO';

  chargeDB2(APPLICATION: 'transco02');
  // appel
  TRANSCOP(transcoDs);

// résultat attendu : erreur = erreur code sortie non trouvé
// test ok : erreur détectée par transcop     -> return code = 1
// test ko : erreur non détectée par transcop -> return code = 0
// assert(condition pour que le test soit OK : contexte de l'erreur)
  assert (transcoDs.ouDs.returnCode = 1
         : ' Erreur non détectée par TRANSCOP '
         );

end-proc;

//==============================================================
// CAS de TEST 3 : (passant) :paramètre valide ( code_entrée = 'JAMES' )
// et code trouvé dans la table -> return code = 0

dcl-proc test_03_codeEntreeOKcodeSortieOk export;

  clear transcoDs;
  transcoDs.inDs.code_entree = 'JAMES';

  chargeDB2(APPLICATION: 'transco03');

  // appel
  TRANSCOP(transcoDs);

// resultat attendu = pas d'erreur
// test ok : pas erreur detectee par transcop => returnCode = 0
// test ok : pas erreur detectee par transcop = > code sortie = 7000
// assert(condition pour que le test soit OK : contexte de l'erreur)
  assert (transcoDs.ouDs.returnCode = 0
         : ' Erreur détectée par TRANSCOP '
         );

       assert (transcoDs.ouDs.code_sortie = 7000
         : ' Erreur détectée par TRANSCOP code sortie vide '
         );

end-proc;

//----------------------------------------------------------------
dcl-proc chargeDB2;

  dcl-pi *n;
    APPLICATION    char(10) const;
    testCase       char(10) const;
  end-pi;

  dcl-s wCommand   char(512);

  wrc=0;

  wCommand = 'RUNSQLSTM '
           + 'SRCSTMF'
           + '('''
           + '/Application/Adhesion/TU/chargeDB2/t_transco/'
           + %trim(testCase)
           + '.sql'
           + ''') '
           + 'COMMIT(*NC) '
           + 'MARGINS(112)';

   wrc = execCmd(wCommand);

   assert(wrc=0
      :'Une erreur est survenue lors de la creation des BDD');

end-proc; 
