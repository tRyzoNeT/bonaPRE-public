# BonaPRE.v1.1P.FRENCH.EGGDROP.TCL-RaW

**Suggestions & Aide & Etc.... C'est par ici les amis!!! XD**

## Public REPO
TCL & MySQL - PREbot en FRANÇAiS

Pour un bon fonctionnement, vous aurez besoin de :
- Eggdrop
- MySQL et MySQLTCL

- Créez un 'BOTNET' de 2-3 eggdrops (sur différents serveurs)
- Chaque fichier .TCL contient des 'CMD' pour éviter les ralentissements.
  - Chargez vos .TCL sur des eggdrops et des serveurs distincts.
    - **Une connexion gbit est recommandée.**
- Assurez-vous d'avoir une base de données MYSQL rapide et performante.
  - **Un disque dur SSD ou NVME est recommandé pour de meilleures performances.**

---

**BonaPRE?! :**

- Code complètement révisé pour optimiser TCL 1.6+ et eggdrop 1.9+
- Simplification & Restructuration du CODE pour :
  - Accélérer les commandes de l'eggdrop.
  - Prévenir les bugs futurs, il suffit de **CHARGER** les *.tcl nécessaires.
- Lien avec MySQL :
  - Option de connexion **SSL** pour une meilleure sécurité avec MySQL.
  - Actualisation régulière avec MySQL toutes les **X** secondes/minutes (temps) pour maintenir la connexion 'KEEPALiVE'.
    - **PS**: Le temps d'actualisation est modifiable via le fichier de .conf
  - 3 bases de données MySQL requises pour ce prebot : **MAiN, NUKE et XTRA_URL**
- Les .tcl sont gérés par des FLAGS pour les restrictions.

---

**VERSiON 1P : OBSOLÈTE, À SUPPRIMER...**

**VERSiON 1.1P ?! :**
- Lien avec MySQL :
  - Ajout de l'option de connexion SSL avec MySQL pour une meilleure sécurité.
  - Ajout de la base de données MySQL requise **XTRA_URL**
- Suppression de l'identification uauth.tcl car les .tcl sont déjà gérés par des FLAGS.

---

**CMD DiSPO :**
  
- Les CMD disponibles, chargez simplement le **.TCL** souhaité.
  - DateTime :: 2023-04-29 23:56:21 **ANNÉE-MOiS-JOUR HEURE(24H):MiN:SECONDE**
    - addURL :: !addurl [nom.release] [https://lienurl/]
    - addIMDB :: !addimdb [nom.release] [tt27813285] **info iMDB seulement**
    - addPRE :: !addpre [nom.release] [section]
    - addTVMAZE :: !addtvmaze [nom.release] [66715] **numéro de TVMAZE seulement**
    - addOLD :: !addold [nom.release] [section] [datetime]
    - DB :: !db 'main ou 'nuke' **INFO DATABASE MySQL/XTRA**
    - delPRE :: !delpre [nom.release] [raison.nuke] [nom.nukenet]
    - OLDdelPRE :: !olddelpre [nom.release] [raison.nuke] [nom.nukenet]
    - iNFO :: !info [nom.release] [nombre.fichier] [taille.MB]
    - NUKE :: !nuke [nom.release] [raison.nuke] [nom.nukenet]
    - OLDnuke :: !oldnuke [nom.release] [raison.nuke] [nom.nukenet] [datetime]
    - modDELpre :: !moddelpre [nom.release] [raison.nuke] [nom.nukenet]
    - modNUKE :: !modnuke [nom.release] [raison.nuke] [nom.nukenet]
    - modUNnuke :: !modunnuke [nom.release] [raison.nuke] [nom.nukenet]
    - OLDmodnuke :: !oldmodnuke [nom.release] [raison.nuke] [nom.nukenet] [datetime]
    - OLDmodunnuke :: !oldmodunnuke [nom.release] [raison.nuke] [nom.nukenet] [datetime]
    - pre :: !pre [nom.release]
    - unDELpre :: !undelpre [nom.release] [raison.nuke] [nom.nukenet]
    - unNUKE :: !unnuke [nom.release] [raison.nuke] [nom.nukenet]
    - OLDunnuke :: !oldunnuke [nom.release] [raison.nuke] [nom.nukenet] [datetime]

---

**iNDEX FLAGS :**
  
Pour que vos commandes fonctionnent sur vos channels, attribuez les flags nécessaires.
  
- FLAGS disponibles :: bpadd - bpdb - bpecho - bpfiltre - bpnuke - bpsearch - bpstats - bpurl
- Via DCC CHAT ::  .chanset #chan +bpadd

# FiN
