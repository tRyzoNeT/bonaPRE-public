-- ----------------------------
-- Table structure for XTRA_URL
-- ----------------------------
DROP TABLE IF EXISTS `XTRA_URL`;
CREATE TABLE `XTRA_URL`  (
  `releaseName` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Nom de la release complete',
  `groupName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Le group qui a sortis la release',
  `lastupdated` datetime(0) NOT NULL DEFAULT current_timestamp() COMMENT 'L heure et date de la derniere modifications',
  `urltype` enum('URL','TVMAZE','IMDB') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Type de lien',
  `valeur` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Numéro iMDB pour la release',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),  -- Timestamp de création, par défaut l'heure actuelle
  UNIQUE INDEX `releaseName_uniq`(`releaseName`, `urltype`) USING BTREE
);

