-- FreshFirst Team
-- Database Migration: Action Lifecycle and Audit Trail
-- Applied: 18 November 2026
-- Database: freshfirst_team

USE freshfirst_team;

-- 1. Enforce action status integrity
ALTER TABLE actions
MODIFY action_status
ENUM('PENDING','IN_PROGRESS','DONE')
NOT NULL DEFAULT 'PENDING';

ALTER TABLE actions
ADD CONSTRAINT chk_actions_completion_timestamp
CHECK (
    (action_status = 'DONE' AND completed_at IS NOT NULL)
    OR
    (action_status IN ('PENDING','IN_PROGRESS') AND completed_at IS NULL)
);

-- 2. Create action audit table
CREATE TABLE action_history (
    action_history_id INT AUTO_INCREMENT PRIMARY KEY,
    action_id INT NOT NULL,
    actor_user_id INT NULL,
    event_type VARCHAR(50) NOT NULL,
    old_status ENUM('PENDING','IN_PROGRESS','DONE') NULL,
    new_status ENUM('PENDING','IN_PROGRESS','DONE') NULL,
    event_details TEXT,
    event_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_action_history_action
        FOREIGN KEY (action_id) REFERENCES actions(action_id),

    CONSTRAINT fk_action_history_user
        FOREIGN KEY (actor_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- 3. Automatic completion timestamps
DELIMITER //

CREATE TRIGGER trg_actions_before_insert
BEFORE INSERT ON actions
FOR EACH ROW
BEGIN
    IF NEW.action_status = 'DONE' AND NEW.completed_at IS NULL THEN
        SET NEW.completed_at = CURRENT_TIMESTAMP;
    END IF;

    IF NEW.action_status <> 'DONE' THEN
        SET NEW.completed_at = NULL;
    END IF;
END//

CREATE TRIGGER trg_actions_before_update
BEFORE UPDATE ON actions
FOR EACH ROW
BEGIN
    IF NEW.action_status = 'DONE' AND OLD.action_status <> 'DONE' THEN
        SET NEW.completed_at = CURRENT_TIMESTAMP;
    END IF;

    IF NEW.action_status <> 'DONE' THEN
        SET NEW.completed_at = NULL;
    END IF;
END//

-- 4. Automatic action audit logging
CREATE TRIGGER trg_action_history_after_insert
AFTER INSERT ON actions
FOR EACH ROW
BEGIN
    INSERT INTO action_history (
        action_id, actor_user_id, event_type,
        old_status, new_status, event_details
    )
    VALUES (
        NEW.action_id, NULL, 'ACTION_CREATED',
        NULL, NEW.action_status, NEW.description
    );
END//

CREATE TRIGGER trg_action_history_after_update
AFTER UPDATE ON actions
FOR EACH ROW
BEGIN
    IF NOT (OLD.action_status <=> NEW.action_status) THEN
        INSERT INTO action_history (
            action_id, actor_user_id, event_type,
            old_status, new_status, event_details
        )
        VALUES (
            NEW.action_id, NULL, 'STATUS_CHANGED',
            OLD.action_status, NEW.action_status, NEW.description
        );
    END IF;
END//

-- 5. Protect audit records against modification
CREATE TRIGGER trg_action_history_prevent_update
BEFORE UPDATE ON action_history
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Action audit records cannot be updated';
END//

CREATE TRIGGER trg_action_history_prevent_delete
BEFORE DELETE ON action_history
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Action audit records cannot be deleted';
END//

DELIMITER ;

-- End of migration
