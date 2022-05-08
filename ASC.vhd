library ieee;
use ieee.std_logic_1164.all;

ENTITY cabine IS
	PORT(
	    ET1, ET2, ET3, ET4, 
		 AP1, AP2, AP3, AP4,
		 P4d, P3d, P2d, P3m, P2m, P1m,
		 PO,
		Init, Clk : IN STD_LOGIC;
	    Montee, Descente			 : OUT STD_LOGIC;
	    unites, dizaines        : OUT STD_LOGIC_VECTOR (6 downto 0));
        
END cabine;

ARCHITECTURE ArchCabine OF cabine IS

constant zero   : STD_LOGIC_vector (6 downto 0) := "0000001";
constant un     : STD_LOGIC_vector (6 downto 0) := "1001111";
constant deux   : STD_LOGIC_vector (6 downto 0) := "0010010";
constant trois  : STD_LOGIC_vector (6 downto 0) := "0000110";
constant quatre : STD_LOGIC_vector (6 downto 0) := "1001100";
constant cinq   : STD_LOGIC_vector (6 downto 0) := "0100100";
constant six    : STD_LOGIC_vector (6 downto 0) := "0100000";
constant sept   : STD_LOGIC_vector (6 downto 0) := "0001111";
constant huit   : STD_LOGIC_vector (6 downto 0) := "0000000";
constant neuf   : STD_LOGIC_vector (6 downto 0) := "0000100";
constant erreur : STD_LOGIC_vector (6 downto 0) := "0000000";
constant eteint : STD_LOGIC_vector (6 downto 0) := "1111111";


	TYPE Etat IS (etat1Arriv, etat1Ouv, etat1Dispo, 
	etat2Arriv, etat2Ouv, etat2Dispo,
	etat3Arriv, etat3Ouv, etat3Dispo,
	etat4Arriv, etat4Ouv, etat4Dispo,
	etatMonte2, etatMonte3, etatMonte4,
	etatDesc3, etatDesc2, etatDesc1);
	SIGNAL EtatPresent, EtatSuivant : Etat;
BEGIN
--  Description du Bloc  F
	PROCESS (ET1, ET2, ET3, ET4, 
		 AP1, AP2, AP3, AP4,
		 P4d, P3d, P2d, P3m, P2m, P1m,
		 PO, EtatPresent)
	  Begin
		-- traitement des etats 0,1,2,3,...
		Case EtatPresent IS
		  When etat1Arriv =>
				IF (PO='1') THEN EtatSuivant <= etat1Ouv;
			   elsE EtatSuivant <= EtatPresent;
				End IF;
		  When etat1Ouv =>
				 IF (PO='0') THEN EtatSuivant <= etat1Dispo;
				elsE EtatSuivant <= EtatPresent;
				End IF;
		  When etat1Dispo =>
				IF (AP2='1' or P2d='1' or P2m='1') THEN EtatSuivant <= etatMonte2;
				ELSIF (AP3='1' or P3d='1' or P3m='1') THEN EtatSuivant <= etatMonte3;
				ELSIF (AP4='1' or P4d='1') THEN EtatSuivant <= etatMonte4;
				ELSIF (PO='1') THEN EtatSuivant <= etat1Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
									
		  When etat2Arriv =>
				IF (PO='1') THEN EtatSuivant <= etat2Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  When etat2Ouv =>
				 IF ('0'= PO) THEN EtatSuivant <= etat2Dispo; 
				 elsE EtatSuivant <= EtatPresent;
				 End IF;
		  When etat2Dispo =>
				IF (AP1='1' or P1m='1') THEN EtatSuivant <= etatDesc1;
				ELSIF (AP3='1' or P3d='1' or P3m='1') THEN EtatSuivant <= etatMonte3;
				ELSIF (AP4='1' or P4d='1') THEN EtatSuivant <= etatMonte4;
				ELSIF (PO='1') THEN EtatSuivant <= etat2Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  
		  When etat3Arriv =>
				IF (PO='1') THEN EtatSuivant <= etat3Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  When etat3Ouv =>
				 IF ('0'= PO) THEN EtatSuivant <= etat3Dispo;
				elsE EtatSuivant <= EtatPresent;
				End IF;
		  When etat3Dispo =>
				IF (AP1='1' or P1m='1') THEN EtatSuivant <= etatDesc1;
				ELSIF (AP2='1' or P2d='1' or P2m='1') THEN EtatSuivant <= etatDesc2;
				ELSIF (AP4='1' or P4d='1') THEN EtatSuivant <= etatMonte4;
				ELSIF (PO='1') THEN EtatSuivant <= etat3Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  
		  When etat4Arriv =>
				IF (PO='1') THEN EtatSuivant <= etat3Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  When etat4Ouv =>
				 IF ('0'= PO) THEN EtatSuivant <= etat3Dispo;
				elsE EtatSuivant <= EtatPresent;
				End IF;
		  When etat4Dispo =>
				IF (AP1='1' or P1m='1') THEN EtatSuivant <= etatDesc1;
				ELSIF (AP2='1' or P2d='1' or P2m='1') THEN EtatSuivant <= etatDesc2;
				ELSIF (AP3='1' or P3d='1' or P3m='1') THEN EtatSuivant <= etatDesc3;
				ELSIF (PO='1') THEN EtatSuivant <= etat4Ouv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  
		  When etatMonte2 =>
				IF (ET2='1') THEN EtatSuivant <= etat2Arriv;
			elsE EtatSuivant <= EtatPresent;
			End IF;
		  When etatMonte3 =>
				IF (ET3='1') THEN EtatSuivant <= etat3Arriv; elsE EtatSuivant <= EtatPresent; End IF;
		  When etatMonte4 =>
				IF (ET4='1') THEN EtatSuivant <= etat4Arriv; elsE EtatSuivant <= EtatPresent;End IF;
		  
		  When etatDesc3 =>
				IF (ET3='1') THEN EtatSuivant <= etat3Arriv; elsE EtatSuivant <= EtatPresent;End IF;
		  When etatDesc2 =>
				IF (ET2='1') THEN EtatSuivant <= etat2Arriv;elsE EtatSuivant <= EtatPresent; End IF;
		  When etatDesc1 =>
				IF (ET1='1') THEN EtatSuivant <= etat1Arriv;elsE EtatSuivant <= EtatPresent; End IF;
 
 		End Case; 
   End Process;

-- Description du Bloc M
	PROCESS (Clk, Init)
	BEGIN
		IF (Init='1') THEN	EtatPresent <= etat1Dispo ;
		ELSE
			IF (Clk='1' and Clk'Event) THEN	EtatPresent <= EtatSuivant ;
			END IF ;
		END IF ;
	END PROCESS;

-- Description du Bloc G
Montee <= '1' When ((EtatPresent = etatMonte2) or (EtatPresent = etatMonte3) or (EtatPresent = etatMonte4))
					Else '0';

Descente <= '1' When (EtatPresent = etatDesc3 or EtatPresent = etatDesc2 or EtatPresent = etatDesc1)
					 Else '0';


   -- sorties pour pilotage des afficheurs de la carte
 unites <= un     when (EtatPresent=etat1Arriv or EtatPresent=etat1Ouv or EtatPresent=etat1Dispo or EtatPresent=etatDesc1) else
			  deux   when (EtatPresent=etat2Arriv or EtatPresent=etat2Ouv or EtatPresent=etat2Dispo or EtatPresent=etatDesc2 or EtatPresent=etatMonte2) else
			  trois   when (EtatPresent=etat3Arriv or EtatPresent=etat3Ouv or EtatPresent=etat3Dispo or EtatPresent=etatDesc3 or EtatPresent=etatMonte3) else
			  quatre   when (EtatPresent=etat4Arriv or EtatPresent=etat4Ouv or EtatPresent=etat4Dispo or EtatPresent=etatMonte4) else
	        erreur;
			  
dizaines <= un     when (EtatPresent=etat1Arriv or EtatPresent=etat2Arriv or EtatPresent=etat3Arriv or EtatPresent=etat4Arriv) else
				deux   when (EtatPresent=etat1Ouv or EtatPresent=etat2Ouv or EtatPresent=etat3Ouv or EtatPresent=etat4Ouv) else
				trois  when (EtatPresent=etat1Dispo or EtatPresent=etat2Dispo or EtatPresent=etat3Dispo or EtatPresent=etat4Dispo) else
				quatre when (EtatPresent=etatMonte2 or EtatPresent=etatMonte3 or EtatPresent=etatMonte4) else
				cinq   when (EtatPresent=etatDesc3 or EtatPresent=etatDesc2 or EtatPresent=etatDesc1) else
            erreur;	       
			

END ArchCabine ;

