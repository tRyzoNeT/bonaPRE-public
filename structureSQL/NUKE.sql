-- ----------------------------
-- Table structure for NUKE
-- ----------------------------
DROP TABLE IF EXISTS `NUKE`;
CREATE TABLE `NUKE` (
  `releaseName` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `groupName` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '',
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `nuke` set('NUKE','MODNUKE','MODUNNUKE','UNNUKE') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `raison` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `nukenet` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
);
