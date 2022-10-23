extends Control

@export var max_y_value = 500
@export var colour : Color
@export var data_point_radius = 2

var values : Array[float] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_value(value: float) -> void:
	values.append(value)
	queue_redraw()
	
func _draw():
	var counter = 0
	for i in values:
		var percent = i / max_y_value
		
		var y_pos = size.y - percent * size.y
		var x_pos = (float(counter) / float(len(values))) * size.x
		
		draw_circle(Vector2(x_pos, y_pos), data_point_radius, colour)
		
		counter+=1
	pass
