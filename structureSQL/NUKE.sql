SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for NUKE
-- ----------------------------
DROP TABLE IF EXISTS `NUKE`;
CREATE TABLE `NUKE` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `rlsname` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `group` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '',
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `nuke` set('NUKE','MODNUKE','MODUNNUKE','UNNUKE') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `raison` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `nukenet` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1020 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
