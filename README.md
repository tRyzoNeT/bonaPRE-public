# bonaPRE.v1.1P.FRENCH.EGGDROP.TCL-RaW

**Suggestions & Aide & Etc.... C'est par ici les amis!!! XD**

# public REPO
TCL &amp; MySQL - PREbot en FRANÇAiS

Ce qui est nécessaire au bon fonctionnement :: eggdrop - mysqld - mysqltcl

- Créez un 'BOTNET' de 2-3 eggdrops (pas sur le même serveur.... u know)
- Chaque .TCL contient certaines 'CMD' pour éviter le lag.
  - Chargez vos .TCL sur des eggdrops différents et des serveurs différents.
    - **connexion gbit recommandée**
- Assurez-vous d'avoir une base de données MYSQL rapide et performante.
  - **disque dur SSD recommandé ou NVME pour de meilleures performances**
  -------------------------------------------------------------------------------------------------------

  **bonaPRE?! :**

- CODE complètement révisé pour être optimisé pour TCL 1.6+ et eggdrop 1.9+
- Simplification & Re-Structuration du CODE, cela a permis :
  - Accélérer les commandes de l'eggdrop.
  - Éviter des bugs dans l`avenir, il suffira de **CHARGER** les *.tcl voulus.
- Lien avec MySQL :
  - Une connexion **SSL** en options avec MySQL demeurre ouverte pour y accéder et obtenir une meilleure réponse aux commandes.
  - Une actualisation avec MySQL toutes les **X** secondes/minutes (temps) pour maintenir une connexion. 'KEEPALiVE' 
    - **PS**: le temps d'actualisation est modifiable via le fichier de .conf
  - 3 bases de donnnées MySQL requises pour ce prebot **MAiN et NUKE et XTRA_URL**
- Restriction, les .tcl sont gerer par des FLAGS.

**VERSiON 1.1P ?! :**
- Lien avec MySQL :
  - Ajout options connexion SSL avec MySQL pour de meilleur securite.
  - Ajout d'une bases de donnnées MySQL requis **XTRA_URL**
-  Supression de l'identification uauth.tcl car les .tcl sont deja gerer par des FLAGS.
  -------------------------------------------------------------------------------------------------------

  **CMD DiSPO :**
  
- Les CMD disponibles, simplement CHARGEZ le **.TCL** voulu
  - DateTime :: 2023-04-29 23:56:21 **ANNÉE-MOiS-JOUR HEURE(24H):MiN:SECONDE**
    - addURL :: !addurl [release.name] [https://lienurl/]
    - addIMDB :: !addimdb [release.name] [tt27813285] **info iMDB seulement**
    - addPRE :: !addpre [release.name] [section]
    - addTVMAZE :: !addtvmaze [release.name] [66715] **numero de TVMAZE seulement**
    - addOLD :: !addold [release.name] [section] [datetime]
    - DB :: !db 'main ou 'nuke' **iNFO DATABASE MySQL/XTRA**
    - delPRE :: !delpre [release.name] [raison.du.nuke] [nom.nukenet]
    - OLDdelPRE :: !olddelpre [release.name] [raison.du.nuke] [nom.nukenet]
    - iNFO :: !info [release.name] [nombre.fichier] [taille.MB]
    - NUKE :: !nuke [release.name] [raison.du.nuke] [nom.nukenet]
    - OLDnuke :: !oldnuke [release.name] [raison.du.nuke] [nom.nukenet] [datetime]
    - modDELpre :: !moddelpre [release.name] [raison.du.nuke] [nom.nukenet]
    - modNUKE :: !modnuke [release.name] [raison.du.nuke] [nom.nukenet]
    - modUNnuke :: !modunnuke [release.name] [raison.du.nuke] [nom.nukenet]
    - OLDmodnuke :: !oldmodnuke [release.name] [raison.du.nuke] [nom.nukenet] [datetime]
    - OLDmodunnuke :: !oldmodunnuke [release.name] [raison.du.nuke] [nom.nukenet] [datetime]
    - pre :: !pre [release.name]
    - unDELpre :: !undelpre [release.name] [raison.du.nuke] [nom.nukenet]
    - unNUKE :: !unnuke [release.name] [raison.du.nuke] [nom.nukenet]
    - OLDunnuke :: !oldunnuke [release.name] [raison.du.nuke] [nom.nukenet] [datetime]

  -------------------------------------------------------------------------------------------------------

  **iNDEX FLAGS :**
  
  Pour que vos commandes fonctionnent sur vos channels, il faut attribuer les flags nécéssaires
  
  - FLAGS disponibles :: bpadd - bpdb - bpecho - bpfiltre - bpnuke - bpsearch - bpstats - bpurl
  - ViA DCC CHAT ::  .chanset #chan +bpadd

# FiN
