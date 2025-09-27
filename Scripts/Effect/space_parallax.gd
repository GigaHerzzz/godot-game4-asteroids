extends ParallaxBackground
class_name SpaceParallax

@export var menu_speed: bool = true

@export var far_offset_speed: int = 20
@export var mid_offset_speed: int = 30
@export var close_offset_speed: int = 40

@export var acceleration_factor: float = 1.0
@export var move_angle: float = 0

@onready var space_layer: ParallaxLayer = %SpaceLayer
@onready var far_star_layer: ParallaxLayer = %FarStarLayer
@onready var close_star_layer: ParallaxLayer = %CloseStarLayer

func _process(delta: float) -> void:
	if(menu_speed):
		space_layer.motion_offset += Vector2.from_angle(90)* far_offset_speed * delta
		far_star_layer.motion_offset += Vector2.from_angle(90) * mid_offset_speed * delta
		close_star_layer.motion_offset += Vector2.from_angle(90) * close_offset_speed * delta
	else:
		space_layer.motion_offset += (-Vector2.from_angle(move_angle)* far_offset_speed * delta) * acceleration_factor
		far_star_layer.motion_offset += (-Vector2.from_angle(move_angle) * mid_offset_speed * delta) * acceleration_factor
		close_star_layer.motion_offset += (-Vector2.from_angle(move_angle) * close_offset_speed * delta) * acceleration_factor
		
func set_move_angle(new_angle: float):
	move_angle = new_angle

func set_acc_factor(new_factor: float):
	acceleration_factor = new_factor
