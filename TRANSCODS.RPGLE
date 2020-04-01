      // exemple de DS contenant :
       //   - une ds avec parametres entrée
       //   - une ds avec parametres sortie

       // parametres en entrée (input)
       dcl-ds inDs_template qualified;
         client_particulier char(20);
       end-ds;

       // parametres en sortie (output)
       dcl-ds ouDs_template qualified;
         code_sortie packed(5:0);
         returnCode int(10);
       end-ds;

       // la ds passée en parametre
       dcl-ds transcoDs_template qualified;
         //entrée
         inDs likeDs(inDs_template);
         //sortie
         ouDs likeDs(ouDs_template);
       end-ds; 
