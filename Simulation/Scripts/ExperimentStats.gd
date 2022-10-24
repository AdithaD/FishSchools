extends Resource
class_name ExperimentStats

@export var range_of_attraction : VariableRange
@export var range_of_orientation : VariableRange
@export var range_of_repulsion : VariableRange

@export var blind_spot_angle : VariableRange
@export var max_noise_angle : VariableRange

@export var attraction_scaling_factor : VariableRange

@export var move_speed : VariableRange
@export var turn_speed : VariableRange

func get_variables() -> Array[VariableRange]:
	return [range_of_attraction, range_of_orientation, range_of_repulsion, blind_spot_angle, max_noise_angle, attraction_scaling_factor, move_speed, turn_speed]

func _init(p_roa = null, p_roo= null, p_ror= null, p_bsa= null, p_mna= null, p_asf= null, p_ms= null, p_ts= null):
	range_of_attraction = p_roa
	range_of_orientation = p_roo
	range_of_repulsion = p_ror
	
	blind_spot_angle = p_bsa
	max_noise_angle = p_mna
	
	attraction_scaling_factor = p_asf
	
	move_speed = p_ms
	turn_speed = p_ts


func generate_experiment_schedule():
	var variables = get_variables()
	
	var independents = variables.filter(func (x): return not x.is_control)
	var amount_of_independents = len(independents)
	var amount_of_combinations = 2 ** amount_of_independents
	
	var combinations = []
	for i in range(amount_of_combinations):
		var combination = []
		combination.resize(len(variables))
		combination.fill(false)
		
		var binary_arr = to_binary(i, amount_of_independents)
		var counter = 0
		for j in range(len(variables)):
			if not variables[j].is_control:
				combination[j] = binary_arr[counter]
				counter += 1
		
		combinations.append(combination)
	
	var schedule = []
	for c in combinations:
		var values_to_test = []
		for i in range(len(c)):
			if c[i]:
				values_to_test.append(variables[i].get_values())
			else:
				values_to_test.append([variables[i].get_default()])
		
		var value_schedule = [[]]
		for i in range(len(values_to_test)):
			value_schedule = cartesian_product(value_schedule, values_to_test[i])
		
		schedule = value_schedule
		
	return schedule
	
func to_binary(num: int, digits: int) -> Array[bool]:
	
	var arr = []
	arr.resize(digits)
	arr.fill(false)
	
	var quot = num
	var counter = 0
	while quot > 0:
		arr[digits - counter - 1] = quot % 2
		quot = quot / 2
		counter+=1
		
	
	return arr
func cartesian_product(a1, a2:):
	var product = []
	for i in a1:
		for j in a2:
			var new_list = []
			new_list.append_array(i)
			new_list.append(j)
			product.append(new_list)
			
	return product
