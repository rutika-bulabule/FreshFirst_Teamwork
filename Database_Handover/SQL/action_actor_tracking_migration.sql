-- FreshFirst Team
-- Follow-up Migration: Action Audit Actor Identification
-- Applied: 18 November 2026
-- Database: freshfirst_team
--
-- The database session must set @freshfirst_actor_user_id
-- to the authenticated user's ID before inserting or updating actions.
-- The triggers validate that the supplied user ID exists.

USE freshfirst_team;

DELIMITER //

DROP TRIGGER IF EXISTS trg_action_history_after_insert//

CREATE TRIGGER trg_action_history_after_insert
AFTER INSERT ON actions
FOR EACH ROW
BEGIN
    DECLARE v_actor_user_id INT DEFAULT NULL;

    SELECT MAX(user_id)
    INTO v_actor_user_id
    FROM users
    WHERE user_id = @freshfirst_actor_user_id;

    INSERT INTO action_history (
        action_id, actor_user_id, event_type,
        old_status, new_status, event_details
    )
    VALUES (
        NEW.action_id, v_actor_user_id, 'ACTION_CREATED',
        NULL, NEW.action_status, NEW.description
    );
END//

DROP TRIGGER IF EXISTS trg_action_history_after_update//

CREATE TRIGGER trg_action_history_after_update
AFTER UPDATE ON actions
FOR EACH ROW
BEGIN
    DECLARE v_actor_user_id INT DEFAULT NULL;

    SELECT MAX(user_id)
    INTO v_actor_user_id
    FROM users
    WHERE user_id = @freshfirst_actor_user_id;

    IF NOT (OLD.action_status <=> NEW.action_status) THEN
        INSERT INTO action_history (
            action_id, actor_user_id, event_type,
            old_status, new_status, event_details
        )
        VALUES (
            NEW.action_id, v_actor_user_id, 'STATUS_CHANGED',
            OLD.action_status, NEW.action_status, NEW.description
        );
    END IF;
END//

DELIMITER ;
