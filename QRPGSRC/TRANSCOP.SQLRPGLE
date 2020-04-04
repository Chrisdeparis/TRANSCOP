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
dcl-s w_codeEntree         char(20);
dcl-s w_codeSortie         packed(5);
dcl-s w_returnCode         int(10);
dcl-s errCheckParm         ind;

monitor;

  clear w_codeEntree;
  clear transcoDs.ouDs;

  exsr checkParm;

  exsr rechercheCodeSortie;

//---------------------------------------------------------------------
  exsr checkParm;
    if not errCheckParm;

      w_message =   'code entree : '
                  + %trim(transcoDs.inDs.code_entree)
                  + '.';
      dsply (%trim(w_message));

      w_codeEntree = %char(transcoDs.inDs.code_entree);
      w_codeSortie = %dec(transcoDs.ouDs.code_sortie);
      w_returnCode = %dec(transcoDs.ouDs.returnCode);

      if transcoDs.ouDs.returnCode = 0; // tout va bien
        clear w_message;
        w_message =   ' in.code entree '
                    + %trim(transcoDs.inDs.code_entree)
                    + ' ou.code sortie '
                    + %char(transcoDs.ouDs.code_sortie)
                    + ' ou.rc '
                    + %char(transcoDs.ouDs.returnCode)
                   + '.';

        dsply (%trim(w_message));

      else;  // erreur rencontree pendant execution transco
        clear w_message;
        w_message =   ' erreur transco '
                    + ' pour code entree : '
                    + %char(transcoDs.inDs.code_entree);
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

  // controle valeur de code entree
  if transcoDs.inDs.code_entree <> *blanks;

    monitor;

      w_codeEntree = %char(transcoDs.inDs.code_entree);

    on-error *all; // client est vide
      dsply ('parametre code entree vide');
      errCheckParm = *on;
    endmon;

  else; // client = blanc
    dsply ('parametre code entree blanc');
    errCheckParm = *on;
  endif;

endsr;

//-----------------------------------------------------------------------------
begsr rechercheCodeSortie;

  clear w_codeSortie;

  // si le paramètre en entrée est renseigné
  if w_codeEntree <> *blanks;
    // chercher la correspondance dans la table à créer
    exec sql
    select  code_sortie
    into :w_codesortie
    from transcof
    where code_entree = upper(:w_codeentree);

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

        transcoDs.ouDs.returnCode = 1;  //Erreur pas de code
        dsply ('erreur sql '
           + %char(sqlcode)
           + ' codesorti '
           + %char(w_codeSortie)
           + ' non trouvé '
           );
         dsply ('param ok code entrée non trouvé rc = '
          + %char(transcoDs.ouDs.returnCode));
    endif;

  else;

    transcoDs.ouDs.returnCode = 1; //Erreur param blanc
    // renseigner le code entree
    dsply ('Veuillez renseigner le code entree');
    dsply ('erreur returnCode = '
          + %char(transcoDS.ouDs.returnCode));
  endif;

endsr; 
