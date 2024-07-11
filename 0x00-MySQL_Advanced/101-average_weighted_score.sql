DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    -- Create a temporary table to store the calculations
    CREATE TEMPORARY TABLE temp_scores (
        user_id INT NOT NULL,
        total_weighted_score INT DEFAULT 0,
        total_weight INT DEFAULT 0
    );

    -- Insert total weighted score and total weight for each user into the temporary table
    INSERT INTO temp_scores (user_id, total_weighted_score, total_weight)
    SELECT corrections.user_id,
           COALESCE(SUM(corrections.score * projects.weight), 0) AS total_weighted_score,
           COALESCE(SUM(projects.weight), 0) AS total_weight
    FROM corrections
    INNER JOIN projects ON corrections.project_id = projects.id
    GROUP BY corrections.user_id;

    -- Update users table with the calculated average score
    UPDATE users
    INNER JOIN temp_scores ON users.id = temp_scores.user_id
    SET users.average_score = IF(temp_scores.total_weight = 0, 0, temp_scores.total_weighted_score / temp_scores.total_weight);

    -- Drop the temporary table
    DROP TEMPORARY TABLE temp_scores;
END $$

DELIMITER ;

