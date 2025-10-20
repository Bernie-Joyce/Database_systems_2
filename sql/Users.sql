CREATE USER 'pokemon_app'@'localhost' IDENTIFIED BY 'Strong_Pass123!';
CREATE USER 'pokemon_app'@'%' IDENTIFIED BY 'Strong_Pass123!';
CREATE USER 'pokemon_readonly'@'localhost' IDENTIFIED BY 'ReadOnly_Pass123!';
CREATE USER 'pokemon_admin'@'localhost' IDENTIFIED BY 'Admin_Pass123!';
CREATE USER 'trainer_user'@'localhost' IDENTIFIED BY 'Trainer_Pass123!';

GRANT ALL PRIVILEGES ON Pokemon.* TO 'pokemon_admin'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Pokemon.* TO 'pokemon_app'@'localhost';
GRANT SELECT, INSERT ON Pokemon.TrainerPokemon TO 'trainer_user'@'localhost';
GRANT SELECT ON Pokemon.Pokemon TO 'trainer_user'@'localhost';
GRANT SELECT ON Pokemon.Types TO 'trainer_user'@'localhost';
GRANT SELECT ON Pokemon.* TO 'pokemon_readonly'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'pokemon_app'@'localhost';
SHOW GRANTS FOR 'pokemon_readonly'@'localhost';
SHOW GRANTS FOR 'trainer_user'@'localhost';

GRANT UPDATE ON Pokemon.TrainerPokemon TO 'trainer_user'@'localhost';
FLUSH PRIVILEGES;

REVOKE INSERT ON Pokemon.TrainerPokemon FROM 'trainer_user'@'localhost';

FLUSH PRIVILEGES;

ALTER USER 'pokemon_app'@'localhost' IDENTIFIED BY 'NewPassword123!';

DROP USER 'pokemon_app'@'localhost', 'pokemon_readonly'@'localhost';

CREATE USER 'pokemon_app'@'localhost' IDENTIFIED BY 'App_Pass123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON Pokemon.* TO 'pokemon_app'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'pokemon_readonly'@'localhost' IDENTIFIED BY 'Read_Pass123!';
GRANT SELECT ON Pokemon.* TO 'pokemon_readonly'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'pokemon_trainer'@'localhost' IDENTIFIED BY 'Trainer_Pass123!';
GRANT SELECT ON Pokemon.Pokemon TO 'pokemon_trainer'@'localhost';
GRANT SELECT ON Pokemon.Gym TO 'pokemon_trainer'@'localhost';
GRANT SELECT ON Pokemon.Types TO 'pokemon_trainer'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Pokemon.TrainerPokemon TO 'pokemon_trainer'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Pokemon.Trainer TO 'pokemon_trainer'@'localhost';
FLUSH PRIVILEGES;

SELECT user, host,
       Select_priv, Insert_priv, Update_priv, Delete_priv
FROM mysql.user
WHERE user IN ('pokemon_app', 'pokemon_readonly', 'pokemon_trainer');

SELECT * FROM mysql.tables_priv
WHERE Db = 'Pokemon';


DROP USER IF EXISTS 'pokemon_app'@'localhost';
DROP USER IF EXISTS 'pokemon_app'@'%';
DROP USER IF EXISTS 'pokemon_readonly'@'localhost';
DROP USER IF EXISTS 'pokemon_admin'@'localhost';
DROP USER IF EXISTS 'pokemon_trainer'@'localhost';
DROP USER IF EXISTS 'trainer_user'@'localhost';

SELECT user, host FROM mysql.user;
