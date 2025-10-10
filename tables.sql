create TABLE Trainer (
    trainer_id int PRIMARY KEY,
    town_id int,
    name varchar(50),
    gender varchar(50),
    age int,
    FOREIGN KEY (town_id) REFERENCES Town(town_id)
    );
    
CREATE TABLE Pokemon (
    pokemon_id int PRIMARY KEY,
    name varchar(50),
    base_hp int,
    base_attack int,
    base_defense int 
    );
    
CREATE TABLE TrainerPokemon (
    trainer_pokemon_id int PRIMARY KEY,
    trainer_id int,
    pokemon_id int,
    nick_name varchar(50),
    pokemon_level int,
    hit_points_iv int,
    attack_iv int,
    defense_iv int,
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id),
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon(pokemon_id)
    );