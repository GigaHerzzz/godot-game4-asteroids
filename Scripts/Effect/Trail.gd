extends Line2D
class_name Trail

var queue: Array
@export var Max_length: int

func _process(delta: float) -> void:
	var pos = get_parent().global_position
	queue.push_front(pos)
	
	if(queue.size() > Max_length):
		queue.pop_back()
		
	clear_points()
	for point in queue:
		add_point(point)
	
