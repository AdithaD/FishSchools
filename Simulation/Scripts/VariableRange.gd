extends Resource
class_name VariableRange

@export var default = 0.5
@export var is_control = true
@export_group("Independent Variable")
@export var min_value = 0.0
@export var max_value = 1.0
@export var step = 0.1
func get_default():
	return default

func get_values() -> Array[float]:
	if not is_control:
		var values = [min_value]
		var latest = min_value
		while latest <= max_value:
			latest += step
			values.append(latest)
		
		if get_default() != min_value:
			values.append(get_default())
		return values
	else :
		return [get_default()]

func _init(p_default = 0.5, p_is_control = true, p_min = 0.0, p_max = 1.0, p_step= 0.1):
	default = p_default
	is_control = p_is_control
	min_value = p_min
	max_value = p_max
	step = p_step
