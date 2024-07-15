-- Désactivation des vérifications de clés étrangères pour permettre des modifications de structure de table
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Structure de la table DEL
-- ----------------------------
CREATE TABLE IF NOT EXISTS `DEL` (
  `id` int(11) NOT NULL AUTO_INCREMENT,  -- Identifiant unique de chaque enregistrement, auto-incrémenté
  `releaseName` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,  -- Nom de la release, ne peut pas être nul
  `groupName` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'NoGroup',  -- Nom du groupe, par défaut 'NoGroup'
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),  -- Date et heure de l'enregistrement, par défaut l'heure actuelle
  `typeName` set('DELPRE','MODDELPRE','UNDELPRE') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,  -- Type de suppression (DELPRE, MODDELPRE, UNDELPRE), ne peut pas être nul
  `reasonMessage` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,  -- Message expliquant la raison de la suppression, ne peut pas être nul
  `delNetName` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,  -- Nom du réseau de suppression, ne peut pas être nul
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),  -- Timestamp de création, par défaut l'heure actuelle
  PRIMARY KEY (`releaseName`, `typeName`, `delNetName`),  -- Clé primaire composée de releaseName, typeName et delNetName
  INDEX (`id`)  -- Index sur le champ id pour optimiser les recherches
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  -- Type de moteur de stockage, encodage de caractère par défaut et collation

-- Réactivation des vérifications de clés étrangères
SET FOREIGN_KEY_CHECKS=1;
