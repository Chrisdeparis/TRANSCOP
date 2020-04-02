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


  exsr checkParm;

  exsr rechercheCodeSortie;

//---------------------------------------------------------------------
  exsr checkParm;
    if not errCheckParm;

      w_message =   'client particulier : '
                  + %trim(transcoDs.inDs.client_particulier)
                  + '.';
      dsply (%trim(w_message));

      w_clientParticulier = %char(transcoDs.inDs.client_particulier);
      w_codeSortie =  %dec(transcoDs.ouDs.code_sortie);
      w_returnCode = %dec(transcoDs.ouDs.returnCode);


      if transcoDs.ouDs.returnCode = 0; // tout va bien
        clear w_message;
        w_message =   ' in.client '
                    + %trim(transcoDs.inDs.client_particulier)
                    + ' ou.code '
                    + %char(transcoDs.ouDs.code_sortie)
                    + ' ou.rc '
                    + %char(transcoDs.ouDs.returnCode)
                   + '.';

        dsply (%trim(w_message));

      else;  // erreur rencontree pendant execution transco
        clear w_message;
        w_message =   ' erreur transco '
                    + ' pour client : '
                    + %char(transcoDS.inDS.client_particulier);
        dsply (%trim(w_message));
      endif;

    else;
    // erreur parametres
    endif;

on-error *all;

endmon;

*inlr = *on;

//---------------------------------------------------------------------
begsr checkParm;

  errCheckParm = *off;
  clear w_codeSortie;

  // controle valeur de client particulier
  if transcoDs.inDs.client_particulier <> *blanks;

    monitor;

      w_clientParticulier = %char(transcoDs.inDs.client_particulier);

    on-error *all; // client est vide
      dsply ('parametre client vide');
      errCheckParm = *on;
    endmon;

  else; // client = blanc
    dsply ('parametre client blanc');
    errCheckParm = *on;
  endif;


endsr;



//-----------------------------------------------------------------------------
begsr rechercheCodeSortie;

  clear w_codeSortie;

  // si le paramètre en entrée est renseigné
  if w_clientParticulier <> *blanks;
    // chercher la correspondance dans la table à créer
    exec sql
    select code_sortie
    into :w_codesortie
    from milfort.transcof
    where code_entree=UPPER(:w_clientparticulier);

    if sqlcode = 0; //OK

      transcoDs.ouDs.code_sortie = w_codeSortie;
      transcoDs.ouDs.returnCode = 0;    // OK
      dsply ('sqlcode '
         + %char(sqlcode)
         + ' code_sortie '
         + %char(w_codeSortie)
         + ' trouvé '
         );
      dsply ('returnCode = '
          + %char(transcoDs.ouDs.returnCode));

      else;

        transcoDs.ouDs.returnCode = 1;  //Erreur pas de code trouvé
        dsply ('erreur sql '
           + %char(sqlcode)
           + ' codesorti '
           + %char(w_codeSortie)
           + ' non trouvé '
           );
         dsply ('erreur returnCode = '
          + %char(transcoDs.ouDs.returnCode));
    endif;

  else;

    transcoDs.ouDs.returnCode = 1; //Erreur param blanc
    // renseigner le client particulier
    dsply ('Veuillez renseigner le client particulier');
    dsply ('erreur returnCode = '
          + %char(transcoDS.ouDs.returnCode));
  endif;

endsr; 
