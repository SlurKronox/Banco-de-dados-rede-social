DROP PROCEDURE IF EXISTS run_smoke;

DELIMITER //
CREATE PROCEDURE run_smoke()
BEGIN
  DECLARE cnt INT DEFAULT 0;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.tables
  WHERE table_schema = DATABASE() AND table_name = 'USUARIO';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabela USUARIO ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.tables
  WHERE table_schema = DATABASE() AND table_name = 'POSTAGEM';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabela POSTAGEM ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.tables
  WHERE table_schema = DATABASE() AND table_name = 'NOTIFICACAO';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabela NOTIFICACAO ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.triggers
  WHERE trigger_schema = DATABASE() AND trigger_name = 'after_curtida_insert';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger after_curtida_insert ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.triggers
  WHERE trigger_schema = DATABASE() AND trigger_name = 'after_curtida_notificacao';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger after_curtida_notificacao ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.views
  WHERE table_schema = DATABASE() AND table_name = 'v_feed_usuario';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'View v_feed_usuario ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.views
  WHERE table_schema = DATABASE() AND table_name = 'v_trending_posts';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'View v_trending_posts ausente';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM information_schema.events
  WHERE event_schema = DATABASE() AND event_name = 'expirar_stories';
  IF cnt = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Evento expirar_stories ausente';
  END IF;
END//
DELIMITER ;

CALL run_smoke();
DROP PROCEDURE IF EXISTS run_smoke;
