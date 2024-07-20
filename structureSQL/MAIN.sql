-- ----------------------------
-- Table structure for MAIN
-- ----------------------------
DROP TABLE IF EXISTS `MAIN`;
CREATE TABLE `MAIN` (
  `releaseName` varchar(256) NOT NULL COMMENT 'Nom de la release complete',
  `groupName` varchar(50) NOT NULL COMMENT 'Le group qui a sortis la release',
  `section` varchar(50) DEFAULT '' COMMENT 'Nom de la sections',
  `datetime` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'date et heure de la release',
  `lastupdated` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'L''heure et date de la derniere modifications',
  `status` set('ADDOLD','ADDPRE','SiTEPRE') DEFAULT '' COMMENT 'Status de la release, si elle est ADDPRE ou autre sinon ok',
  `files` tinyint(4) unsigned DEFAULT NULL COMMENT 'Nombre de fichier composant la release',
  `size` decimal(10,3) unsigned DEFAULT NULL COMMENT 'La taille de la release exprimé en MB',
  PRIMARY KEY (`id`),
  UNIQUE KEY `releaseName_uniq` (`releaseName`) USING BTREE,
  KEY `rls_status` (`status`) USING BTREE
);
