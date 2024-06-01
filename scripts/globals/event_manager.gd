extends Node

# game states
signal game_over
signal game_won

signal player_health_changed(health: int)
signal enemy_died(enemy: Organism)

# stat changes
signal skill_level_changed(skill: String, level: int)
