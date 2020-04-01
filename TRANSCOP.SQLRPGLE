**free
ctl-opt option(*srcstmt) dftactgrp(*No);


// DS des paramètres
/copy MILFORT/qcopsrc,transcoDs

dcl-pi *n;
  //paremeter list
  transcoDs likeDs(transcoDs_template);
end-pi;

// variables de travail
dcl-s w_message            char(50);
dcl-s w_clientParticulier  char(20);
dcl-s w_codeSortie         packed(5);
dcl-s w_returnCode         int(10);
dcl-s errCheckParm         ind;




monitor;

  clear w_clientParticulier;
  clear transcoDs.ouDs;


  // reception client_particulier
  w_message =   'transcoDs :  ( client particulier : '
              + %trim(transcoDs.inDs.client_particulier)
              + ')';

  //dsply (%trim(w_message));

  w_clientParticulier = %char(transcoDs.inDs.client_particulier);

  exsr transcoTableClient;



on-error *all;

endmon;

*inlr = *on;

//-----------------------------------------------------------------------------
begsr transcoTableClient;

  clear w_codeSortie;

  // si le paramètre en entrée est renseigné
  if w_clientParticulier <> *blanks;
    // chercher la correspondance dans la table à créer
    exec sql
    select code_sortie
    into :w_codesortie
    from milfort.transcof
    where code_entree=UPPER(:w_clientparticulier);

    if sqlcode = 0; // OK

      transcoDs.ouDs.code_sortie = w_codeSortie;
      transcoDs.ouDs.returnCode = 0;
      dsply ('sqlcode '
         + %char(sqlcode)
         + ' code_sortie '
         + %char(w_codeSortie)
         + ' trouvé '
         );
      dsply ('returnCode = '
          + %char(transcoDs.ouDs.returnCode));

    else; // others SQL errors

        transcoDs.ouDs.returnCode = 1;
        dsply (' erreur sql '
           + %char(sqlcode)
           + ' codesorti '
           + %char(w_codeSortie)
           + ' non trouvé '
           );
         dsply ('erreur returnCode = '
          + %char(transcoDs.ouDs.returnCode));
    endif;


  else;
    transcoDs.ouDs.returnCode = 1;
    // renseigner le client particulier
    dsply ('Veuillez renseigner le client particulier');
    dsply ('erreur returnCode = '
          + %char(transcoDS.ouDs.returnCode));
  endif;

endsr; 
