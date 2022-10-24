extends Node2D
class_name FishSimulation

@export var amount_of_fish = 100
@export var fish_agent : PackedScene
@export var fish_stats : FishStats

@export var should_apply_bounds = true
@export var bounds_size : Vector2
@export var time_duration = 100.0
@export var time_scale : int = 1

@export_group("Discrete Time")
@export var is_discrete_time_simulation = true
@export var discrete_time_step = 0.1
@export var number_of_steps = 100
@export var auto_start = false

@export_group("Metrics")
@export var average_distance_to_centre_of_mass = false
@export var global_vec_convergence = false
@export var local_vec_convergence = false
@export var swirling_factor = false
# @export var linearity = false

var _fish_stats = null

var bounds : Rect2i
var agents : Array[FishAgent] = []

var metrics = {
	"avg_dist_to_com": [],
	"global_vec_convergence": [],
	"local_vec_convergence": [],
	"swirling_factor": [],
#	"linearity": []
}

var current_step = 0
var current_time = 0

var deltas = []

var has_simulation_ended = false

var current_com = Vector2(0,0)
var current_avg_vector = Vector2(0,0)



signal end_step(avg_dist_to_com, global_vec_convergence, local_vec_convergence, swirling_factor)
signal simulation_ended
# Called when the node enters the scene tree for the first time.
func _ready():
	var bounds_pos = get_viewport_rect().size / 2 - bounds_size / 2
	bounds = Rect2i(bounds_pos, bounds_size)
	
	print(bounds)

	
	if _fish_stats == null:
		_fish_stats = fish_stats
	
	print(_fish_stats.to_json())
	if auto_start:
		start_simulation()
		
func set_fish_stats(new_stats):
	_fish_stats = new_stats
	
func start_simulation():
	for i in range(amount_of_fish):
			var new_x = randi_range(bounds.position.x, bounds.position.x + bounds.size.x)
			var new_y = randi_range(bounds.position.y, bounds.position.y + bounds.size.y)
		
			var new_direction = Vector2(1,0).rotated(randf() * 2.0 * PI)
		
			var new_fish = fish_agent.instantiate()
			agents.append(new_fish)
			
			new_fish.stats = _fish_stats
			
			new_fish.position = Vector2(new_x, new_y)
			new_fish.direction = new_direction
			
			$Agents.add_child(new_fish)
			
	if is_discrete_time_simulation:
		$Timer.wait_time = discrete_time_step
		$Timer.start()
	pass
	
func apply_bounds_control(fish, desired_direction) -> Vector2:
	if not bounds.has_point(fish.position) and should_apply_bounds:
		var center = Vector2(bounds.size / 2 + bounds.position)
		
		var adjustment_direction = (center - fish.position).normalized()
		return adjustment_direction
	else :
		return desired_direction
func calculate_com():
	var com : Vector2 = Vector2(0,0)
	
	for i in agents:
		com += i.position
		
	com /= len(agents)
	return com
	pass

func calculate_avg_vector():
	var avg_vector = Vector2(0,0)
	
	for i in agents:
		avg_vector = (avg_vector + i.direction).normalized()
		
	return avg_vector
	
func calculate_avg_dist_to_com_metric(com) -> float:
	var sum = 0
	for i in agents:
		sum += com.distance_to(i .position)
	
	return float(sum) / len(agents)
	pass
	
func calculate_vector_convergence_metric(avg_vector) -> float:
	var avg_dot = 0
	for i in agents:
		avg_dot += avg_vector.dot(i.direction)
		
	return abs(avg_dot) / len(agents)

func calculate_local_vector_convergence_metric() -> float:
	var sample_size = round(amount_of_fish * 0.1)
	var neighbour_sample_size = ceil(amount_of_fish * 0.05)
	
	var total_count = 0
	var avg_dot = 0
	
	for i in agents.slice(0, sample_size):
		var neighbours_directions : Array[Vector2] = []
		for j in agents:
			if i != j:
				if i.position.distance_to(j.position) < _fish_stats.range_of_orientation:
					neighbours_directions.append(j.direction)
			
			if len(neighbours_directions) >= neighbour_sample_size:
				break
		
		for direction in neighbours_directions:
			avg_dot += (i.direction.dot(direction) + 1) / 2
		
	
		total_count += len(neighbours_directions)
	
	if total_count > 0:	
		return avg_dot / total_count
	else:
		return 0.0
func calculate_swirling_metric(com) -> float:
	var avg_dot = 0.0
	
	for i in agents:
		avg_dot += abs(i.direction.dot((i.position - com).normalized()))
	

	return 1 - avg_dot / len(agents)


#func calculate_linearity_metric(com, avg_vector):
#	var size = Vector2(float(fish_stats.move_speed) * 4, float(fish_stats.move_speed) * 4 / 4.0)
#	var rect = Rect2(-size/2 + com,  size)
#
#	var no_agents_inside = 0
#	var avg_dot = 0
#	for i in agents:
#		var rotated_pos = i.position.rotated(-avg_vector.angle())
#		if rect.has_point(rotated_pos):
#			no_agents_inside += 1
#			avg_dot += (i.direction.dot(avg_vector) + 1) / 2
#
#
#	return avg_dot * no_agents_inside / len(agents)
#	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if not has_simulation_ended and not is_discrete_time_simulation:
		if current_time < time_duration:
			current_time += delta * time_scale
			for i in agents:
				i.step(delta * time_scale)
			
			emit_signal("end_step")	
			deltas.append(delta)
		else:
			end_simulation()
		
		pass
	
func get_agents() -> Array[FishAgent]:
	return agents
	
func _draw():
	if should_apply_bounds:
		draw_rect(bounds, Color.DARK_BLUE, false)

	draw_circle(current_com, 5, Color.DARK_ORANGE)
	draw_line(current_com, current_avg_vector *50 + current_com, Color.PURPLE, 10)
	
#	var adtcom = calculate_avg_dist_to_com_metric(current_com)
#	var size = Vector2(float(fish_stats.move_speed) * 4, float(fish_stats.move_speed) * 4 / 4.0)
#	var rect = Rect2(-size/2,  size)
#	draw_set_transform(current_com, current_avg_vector.angle(), Vector2.ONE)
#	draw_rect(rect, Color.PURPLE )


func on_end_step():
	var avg_dist_to_com = -1
	var global_vec_convergence = -1
	var local_vec_convergence = -1
	var swirling_factor = -1
#	var linearity  = -1
	
	var com = calculate_com()
	current_com = com
	
	var avg_vector = calculate_avg_vector()
	current_avg_vector = avg_vector
	
	if average_distance_to_centre_of_mass:
		avg_dist_to_com = calculate_avg_dist_to_com_metric(com)
		metrics["avg_dist_to_com"].append(avg_dist_to_com)
	
	if global_vec_convergence:
		global_vec_convergence = calculate_vector_convergence_metric(avg_vector)
		metrics["global_vec_convergence"].append(global_vec_convergence)
	
	if local_vec_convergence:
		local_vec_convergence = calculate_local_vector_convergence_metric()
		metrics["local_vec_convergence"].append(local_vec_convergence)
	
	if swirling_factor:
		swirling_factor = calculate_swirling_metric(com)
		metrics["swirling_factor"].append(swirling_factor)

#	if linearity:
#		linearity = calculate_linearity_metric(com, avg_vector)
#		metrics["linearity"].append(linearity)
		
#	emit_signal("end_step", avg_dist_to_com, global_vec_convergence, local_vec_convergence, swirling_factor, linearity)	
		emit_signal("end_step", avg_dist_to_com, global_vec_convergence, local_vec_convergence, swirling_factor)	
	queue_redraw()
	current_step += 1
	pass

func _on_timer_timeout():
	if not has_simulation_ended:
		if current_step < number_of_steps:
			for t in range(time_scale):
				for i in agents:
					i.step(discrete_time_step)
				on_end_step()
		else:
			end_simulation()
		pass # Replace with function body.

func end_simulation():
	print("Ending simulation...")
	$Timer.stop()
	
	export_simulation_data()
	has_simulation_ended = true
	emit_signal("simulation_ended")

func export_simulation_data() -> void:
	var time_data ={}
	
	if is_discrete_time_simulation:
		time_data = { "time_step": discrete_time_step, "number_of_steps": number_of_steps }
		pass
	else:
		time_data = { "deltas": deltas, "time_scale" : time_scale }
		pass
	
	
	var simulation_data = {
		"time_control" : {
			"type": "discrete" if is_discrete_time_simulation else "continuous",
			"time_data": time_data
		},
		"amount_of_fish": amount_of_fish,
		"fish_stats": _fish_stats.to_json(),
		"metrics" : metrics
	}
	
	var experiment_name = "default"
	if get_parent().has_method("get_experiment_name"):
		experiment_name = get_parent().get_experiment_name()
	
	var document_name = "user://exp_%s_sim_%s.json" %[experiment_name, Time.get_time_string_from_system().replace(":","_")]
	print(document_name)
	var f = FileAccess.open(document_name, FileAccess.WRITE)
	
	f.store_string(JSON.stringify(simulation_data))
	print("Writing simulation data to %s" % f.get_path_absolute())
	f.flush()
	pass
	
