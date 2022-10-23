extends Control

@export var max_y_value = 500
@export var colour : Color
@export var data_point_radius = 2
@export var max_readings = 200

var values : Array[float] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_value(value: float) -> void:
	values.append(value)
	queue_redraw()
	
func _draw():
	var index_increment = 1
	
	index_increment *=  float(len(values)) / float(max_readings) if len(values) > max_readings else 1
	
	for i in min(len(values), max_readings):
		var index = round(i * index_increment)
		
		var percent = values[index] / max_y_value
		
		var y_pos = size.y - percent * size.y
		var x_pos = (float(index) / float(len(values))) * size.x
		
		draw_circle(Vector2(x_pos, y_pos), data_point_radius, colour)
	
	pass
