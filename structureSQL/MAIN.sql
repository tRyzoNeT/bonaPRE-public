SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for MAIN
-- ----------------------------
DROP TABLE IF EXISTS `MAIN`;
CREATE TABLE `MAIN` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `rlsname` varchar(256) NOT NULL COMMENT 'Nom de la release complète',
  `group` varchar(50) NOT NULL COMMENT 'Le group qui a sorti la release',
  `section` varchar(50) DEFAULT '' COMMENT 'Nom de la section',
  `datetime` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'date et heure de la release',
  `lastupdated` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'L''heure et date de la dernière modification',
  `status` set('ADDOLD','ADDPRE','SiTEPRE') DEFAULT '' COMMENT 'Status de la release, si elle est ADDPRE ou autre sinon ok',
  `files` tinyint(4) unsigned DEFAULT NULL COMMENT 'Nombre de fichier composant la release',
  `size` decimal(10,3) unsigned DEFAULT NULL COMMENT 'La taille de la release exprimée en MB',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rlsname_uniq` (`rlsname`) USING BTREE,
  KEY `rls_status` (`status`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=477901 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
