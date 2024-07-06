SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for XTRA_URL
-- ----------------------------
DROP TABLE IF EXISTS `XTRA_URL`;
CREATE TABLE `XTRA_URL`  (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `rlsname` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Nom de la release complete',
  `group` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Le group qui a sortis la release',
  `lastupdated` datetime(0) NOT NULL DEFAULT current_timestamp(0) COMMENT 'L\'heure et date de la derniere modifications',
  `addurl` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Lien url de la release',
  `tvmaze` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Numéro TVmaze pour la release',
  `imdb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Numéro iMDB pour la release',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `rlsname_uniq`(`rlsname`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 705 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
