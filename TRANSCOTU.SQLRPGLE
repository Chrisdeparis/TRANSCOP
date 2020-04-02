**free
ctl-opt nomain;

/copy RPGUNIT/RPGUNIT1,TESTCASE
/copy h1frptechs/qcopsrc,s_spvDS
/copy MILFORT/qcopsrc,transcoDs

dcl-pr transcop extpgm('TRANSCOP');
  toto likeDs(transcoDs_template);
end-pr;

dcl-ds transcoDs likeDs(transcoDs_template);

// définition des constantes
dcl-c APPLICATION     const('ADHTU');

// définition des variables
dcl-s wcurrentdate   date;
dcl-s wvanpalier     packed(18:11);
dcl-s rc             int(10);
dcl-s wCommande      char(512);

dcl-s w_clientParticulier  char(20);
dcl-s w_codeSortie         packed(5);
dcl-s w_returnCode         int(10);


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

dcl-proc test_01_parametreVide export;

  clear transcoDs;
  transcoDs.inDs.client_Particulier = '';


  // appel
  TRANSCOP(transcoDs);

  // resultat attendu :  paramètre à blanc -> return code  = 1
  assert (transcoDs.ouDs.returnCode = 1
         :'Erreur : parametre invalide non détecté par TRANSCOP'
         );



end-proc;

////==============================================================
//// CAS de TEST 2 : (non passant) : paramètre valide ( code_entrée = 'client_particulier' )
//  mais code non trouvé dans la table -> return code = 1
//dcl-proc test_02_jetepasse0jerecois32etfreezing export;
//
//  wtempFahr    = 0;
//  wtempCelsius = 0;
//  wstatus      = *blanks;
//
//  // appel
//  TRANSCOP(transcoDs);
//
//  assert (transcoDs.ouDs.returnCode = 1
//         : ' Erreur Transco code non trouvé '
//         );
//
//
//end-proc;

//----------------------------------------------------------------
dcl-proc chargeDB2;

  dcl-pi *n;
    APPLICATION    char(10) const;
    testCase       char(10) const;
  end-pi;

  dcl-s wCommand    char(512);

  wrc=0;

  wCommand = 'RUNSQLSTM '
           + 'SRCSTMF'
           + '('''
           + '/Application/Adhesion/TU/chargeDB2/t_spvrcapp/'
           + %trim(testCase)
           + '.sql'
           + ''') '
           + 'COMMIT(*NC) '
           + 'MARGINS(112)';

   wrc = execCmd(wCommand);

   assert(wrc=0
      :'Une erreur est survenue lors de la creation des BDD');

end-proc; 
