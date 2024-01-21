# bonaPRE.v1P.FRENCH.EGGDROP.TCL-RaW

**Suggestion & Aide & Etc.... ses par ici les amis!!! XD**

# public REPO
TCL &amp; MySQL - PREbot en FRANCAiS

Ce qui est nécessaire au bon fonctionnement :: eggdrop - mysqld - mysqltcl

- Crée un 'BOTNET' de 2-3 eggdrop (pas sur le meme serveur.... u know)
- Chaque .TCL contient certaines 'CMD' pour éviter le lag.
  - Chargé vos .TCL sur des eggdrops différents et des serveurs différent.
    - **connexion gbit recommander**
- Assurez-vous d'avoir une base de données MYSQL rapide et performant.
  - **disque dur SSD recommander ou NVME pour de meilleures performances**
  -------------------------------------------------------------------------------------------------------

  **VERSiON 1P ?! :**

- Le CODE est complètement révisé pour être optimiser par TCL 1.6+ et eggdrop 1.9+
- Simplification & Re-Structuration du CODE, cela a permis :
  - Accélérer les commandes du eggdrop.
  - Éviter des bugs dans l`avenir, il suffira de **CHARGÉ** les *.tcl voulu.
- Lien avec MySQL :
  - Une connexion avec MySQL demeure ouverte pour y accéder et obtenir une meilleure réponse aux commandes.
  - Une actualisation avec MySQL a tout les **X** temps pour maintenir une connexion. 'KEEPALiVE' 
    - **PS**: le temps d'actualisation est modifiable via le fichier de .conf
  - 2 base de donnnée MySQL requis pour ce prebot **MAiN et NUKE**
- Les CMD disponible, simplement CHARGE le **.TCL** voulu
  - Option :: <0> [ 0 a la 'FiN' si vous ne voulez pas **ECHO** sur le channel. ]
  - DateTime :: 2023-04-29 23:56:21 **ANNÉE-MOiS-JOUR HEURE(24H):MiN:SECONDE**
    - addPRE :: !addpre [release.name] [section]
    - addOLD :: !addold [release.name] [section] [datetime]
    - chgFiLE :: !chgfile [release.name] [nombres.fichiers]
    - chgSEC :: !chgsec [release.name] [nouvelle.section]
    - chgSiZE :: !chgsize [release.name] [ taille.MB]
    - chgTiME :: !chgtime [release.name] [datetime] **ANNÉE-MOiS-JOUR HEURE(24H):MiN:SECONDE**
    - DB :: !db **iNFO DATABASE MySQL**
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

# FiN
XD
