extends Control

@export var max_y_value = 500
@export var colour : Color
@export var data_point_radius = 2
@export var max_readings = 200

var values : Array[float] = []


var incr_sum = 0
var incr_sum_squares = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_value(value: float) -> void:
	incr_sum += value
	incr_sum_squares += value ** 2
	values.append(value)
	$StdErrorLabel.text = "%f" % (get_std_dev() / get_mean())

	queue_redraw()

		
func get_mean() -> float:
	return float(incr_sum) / len(values)

func get_std_dev() -> float:
	return sqrt(float(incr_sum_squares) / len(values) - (float(incr_sum)/len(values))**2)

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
