DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser (IN user_id INT)
BEGIN
    DECLARE total_weighted_score INT DEFAULT 0;
    DECLARE total_weight INT DEFAULT 0;

    -- Calculate total weighted score and total weight in a single query using subqueries
    SELECT 
        COALESCE(SUM(corrections.score * projects.weight), 0) INTO total_weighted_score,
        COALESCE(SUM(projects.weight), 0) INTO total_weight
    FROM corrections
    INNER JOIN projects ON corrections.project_id = projects.id
    WHERE corrections.user_id = user_id;

    -- Update user's average score based on total_weight
    IF total_weight = 0 THEN
        UPDATE users
        SET average_score = 0
        WHERE id = user_id;
    ELSE
        UPDATE users
        SET average_score = total_weighted_score / total_weight
        WHERE id = user_id;
    END IF;
END $$

DELIMITER ;

