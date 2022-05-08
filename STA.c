/* ===================================================*/
/*    Programme de mise en oeuvre de MEF              */
/*             Maquette du STA                        */
/* ===================================================*/

/******************************************************/
/*  POUR COMPILER   (renommer le fichier)             */
/*  gcc -Wall xxx.c -o xxx -lcomedi -lsta             */
/******************************************************/

#include <stdio.h>    // pour printf/scanf uniquement
#include <unistd.h>   // pour usleep();
#include <sta.h>      // definition des identifiants ES et des tempos entre autres


int main(void)
{
// placer ici toutes vos déclarations et initialisations
  // les variables d'état et initialisations
  int EtatPresent = 1;
  int EtatSuivant = 1;

  // les entrées
  int LAPP, RAPP, CTRE, FBAR, USER, HLIM, VLIM, FINT/*, ATIMER*/;
  // les sorties
  int V, H, B, G, D, A;



// initialisation des ports d'entree/sortie
init_io();
  
printf (" * ***************************************** * \n");
printf (" *      CTRL-C pour arrêter la commande      * \n");
printf (" * ***************************************** * \n");
 
/*********************************************************/  
/*      Début de la boucle de fonctionnement             */
/*********************************************************/
 while(!stop()) // interrompre le programme par appui sur CTRL+C
{

	// lecture des entrées
	LAPP = entree(AG);
	RAPP = entree(AD);
    	CTRE = entree(C);
    	FBAR = entree(P);
    	USER = entree(OP);
    	HLIM = entree(LH);
    	VLIM = entree(LV);
	FINT = 1;

    	/************/
    	/* Bloc F  */
    	/************/
	
	switch(EtatPresent){
		case 1  : if(USER)  		EtatSuivant = 2 ; break;
		case 2  : 
			  if(LAPP && !FBAR)  	EtatSuivant = 3 ; 
			  if (LAPP && FBAR) 	EtatSuivant = 15; 
			  break;
		case 3  : if(CTRE)  		EtatSuivant = 4 ; break;
		case 4  : if(!VLIM)  		EtatSuivant = 5 ; break;
		case 5  : if(VLIM)  		EtatSuivant = 6 ; break;
		case 6  : if(RAPP)  		EtatSuivant = 7 ; break;
		case 7  : if(!RAPP)  		EtatSuivant = 8 ; break;
		case 8  : if(RAPP)  		EtatSuivant = 9 ; break;
		case 9  : if(!RAPP)  		EtatSuivant = 10; break;
		case 10 : if(RAPP)  		EtatSuivant = 11; break;
		case 11 : 
			  if(LAPP)  		EtatSuivant = 26;
			  if(FBAR)		EtatSuivant = 10; 
			  break;
		case 12 : if(!VLIM)  		EtatSuivant = 13; break;
		case 13 : if(VLIM)  		EtatSuivant = 14; break;
		case 14 : if(HLIM)  		EtatSuivant = 25; break;
		case 15 : if(!LAPP)  		EtatSuivant = 16; break;
		case 16 : 
			  if(LAPP && FBAR)	EtatSuivant = 17;
			  if(LAPP && !FBAR)	EtatSuivant = 20;
			  break;
		case 17 : if(CTRE)  		EtatSuivant = 18; break;
		case 18 : if(!VLIM)  		EtatSuivant = 19; break;
		case 19 : if(VLIM)  		EtatSuivant = 8 ; break;
		case 20 : if(!LAPP)  		EtatSuivant = 21; break;
		case 21 : 
			  if(LAPP && FBAR)	EtatSuivant = 22; 
			  if(LAPP && !FBAR)	EtatSuivant = 14; 
			  break;
		case 22 : if(CTRE)		EtatSuivant = 23; break;
		case 23 : if(!VLIM)		EtatSuivant = 24; break;
		case 24 : if(VLIM)		EtatSuivant = 10; break;
		case 25 : if(FINT)		EtatSuivant = 1 ; break;
		case 26 : if(CTRE)		EtatSuivant = 12 ; break;
	}
 
    	/************/
    	/* Bloc M  */
    	/************/       
	
	EtatPresent = EtatSuivant;
	printf("Etat Present : \t%d\n",EtatPresent); // Affichage pour débug

	/************/
    	/* Bloc G   */
    	/************/

	H = (EtatPresent == 4  || EtatPresent == 5  || EtatPresent == 18 || EtatPresent == 19 || EtatPresent == 23 || EtatPresent == 24);
	B = (EtatPresent == 12 || EtatPresent == 13);
	G = (EtatPresent == 2  || EtatPresent == 6  || EtatPresent == 7  || EtatPresent == 8  || EtatPresent == 9  || EtatPresent == 10 || 
	     EtatPresent == 11 || EtatPresent == 15 || EtatPresent == 16 || EtatPresent == 20 || EtatPresent == 21);
	D = (EtatPresent == 3  || EtatPresent == 14 || EtatPresent == 17 || EtatPresent == 22 || EtatPresent == 26);

	V = (EtatPresent == 14);
	A = 0;
	

// écriture sur les sorties
    sortie(VV,V);
    sortie(HH,H);
    sortie(BB,B);
    sortie(GG,G);
    sortie(DD,D);
    sortie(AA,A);
}
/*********************************************************/
/*    Fin de boucle de fonctionnement                    */
/*********************************************************/

  mzSorties(); // coupe toutes les sorties avant d'arrêter la commande
  printf ("\n\n*** Arrêt provoqué par l'utilisateur (CTRL-C) ***\n\n");  
  return 0;
}


