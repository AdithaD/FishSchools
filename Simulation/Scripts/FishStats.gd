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

func _to_string():
	return JSON.stringify(to_json())

func _init(p_roa = 300, p_roo = 150, p_ror =20, p_bsa = PI/3, p_mna = PI/4, p_asf = 1, p_ms = 120, p_ts = 1 * PI):
	range_of_attraction = p_roa
	range_of_orientation = p_roo
	range_of_repulsion = p_ror
	
	blind_spot_angle = p_bsa
	max_noise_angle = p_mna
	
	attraction_scaling_factor = p_asf
	
	move_speed = p_ms
	turn_speed = p_ts

func init_from_list(values):
	range_of_attraction =values[0]
	range_of_orientation = values[1]
	range_of_repulsion = values[2]
	
	blind_spot_angle = values[3]
	max_noise_angle =values[4]
	
	attraction_scaling_factor = values[5]
	
	move_speed = values[6]
	turn_speed = values[7]

