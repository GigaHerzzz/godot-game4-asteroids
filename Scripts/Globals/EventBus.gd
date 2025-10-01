extends Node

signal game_over
signal player_hit
signal add_points(points: int)
signal spawn_explosion(pos: Vector2, scale: float)
signal spawn_player_explode(pos: Vector2, rotation: float)
signal show_upgrade_pickup(text_to_show: String)
#signal spawn_explosion(pos: Vector2, scale: float)