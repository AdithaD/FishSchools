extends Resource
class_name FishStats

@export var range_of_attraction = 300
@export var range_of_orientation = 150
@export var range_of_repulsion = 50

@export var blind_spot_angle = PI / 2
@export var max_noise_angle = PI / 4

@export var attraction_scaling_factor = 1.0

@export var move_speed = 15.0
@export var turn_speed = 5.0

func to_json() -> Dictionary:
	var json_dict = {
		"roa" : range_of_attraction,
		"roo" : range_of_orientation,
		"ror" : range_of_repulsion,
		"blind_spot_angle" : blind_spot_angle,
		"max_noise_angle" : max_noise_angle,
		"attraction_scaling_factor" : attraction_scaling_factor,
		"move_speed" : move_speed,
		"turn_speed" : turn_speed
	}
	
	return json_dict
