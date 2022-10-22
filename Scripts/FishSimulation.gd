extends Node2D
class_name FishSimulation

@export var amount_of_fish = 100
@export var fish_agent : PackedScene
@export var fish_stats : FishStats

@export var should_apply_bounds = true
@export var bounds_size : Vector2
@export var time_duration = 100.0
@export var time_scale = 1

@export_group("Discrete Time")
@export var is_discrete_time_simulation = true
@export var discrete_time_step = 0.1
@export var number_of_steps = 100


var bounds : Rect2i
var agents : Array[FishAgent] = []

var current_step = 0
var current_time = 0

signal end_step

# Called when the node enters the scene tree for the first time.
func _ready():
	var bounds_pos = get_viewport_rect().size / 2 - bounds_size / 2
	bounds = Rect2i(bounds_pos, bounds_size)
	
	print(bounds)
	
	for i in range(amount_of_fish):
		var new_x = randi_range(bounds.position.x, bounds.position.x + bounds.size.x)
		var new_y = randi_range(bounds.position.y, bounds.position.y + bounds.size.y)
	
		var new_direction = Vector2(1,0).rotated(randf() * 2.0 * PI)
	
		var new_fish = fish_agent.instantiate()
		agents.append(new_fish)
		
		new_fish.stats = fish_stats
		
		new_fish.position = Vector2(new_x, new_y)
		new_fish.direction = new_direction
		
		$Agents.add_child(new_fish)
		
	if is_discrete_time_simulation:
		$Timer.wait_time = discrete_time_step
		$Timer.start()
	pass # Replace with function body.

func apply_bounds_control(fish, desired_direction) -> Vector2:
	if not bounds.has_point(fish.position) and should_apply_bounds:
		var center = Vector2(bounds.size / 2 + bounds.position)
		
		var adjustment_direction = (center - fish.position).normalized()
		return adjustment_direction
	else :
		return desired_direction

func calculate_avg_dist_to_com_metric() -> float:
	var com : Vector2 = Vector2(0,0)
	
	for i in agents:
		com += i.position
		
	com /= len(agents)
	
	var sum = 0
	for i in agents:
		sum += com.distance_to(i .position)
	
	return sum / len(agents)
	pass
	
func calculate_vector_divergence_metric() -> float:
	var avg_vector = Vector2(0,0)
	
	for i in agents:
		avg_vector = (avg_vector + i.direction).normalized()
	
	var avg_dot = 0
	for i in agents:
		avg_dot += avg_vector.dot(i.direction)
		
	return abs(avg_dot) / len(agents)

func calculate_local_vector_divergence_metric() -> float:
	var sample_size = round(amount_of_fish * 0.1)
	var neighbour_sample_size = ceil(amount_of_fish * 0.1)
	
	var total_count = 0
	var avg_dot = 0
	
	for i in agents.slice(0, sample_size):
		var neighbours_directions : Array[Vector2] = []
		for j in agents:
			if i != j:
				if i.position.distance_to(j.position) < fish_stats.range_of_orientation:
					neighbours_directions.append(j.direction)
			
			if len(neighbours_directions) >= neighbour_sample_size:
				break
		
		for direction in neighbours_directions:
			avg_dot += abs(i.direction.dot(direction))
			
		total_count += len(neighbours_directions)
		
	return abs(avg_dot) / total_count

func calculate_swirling_metric() -> float:
	var com : Vector2 = Vector2(0,0)
	
	for i in agents:
		com += i.position
		
	com /= len(agents)
	
	var avg_dot = 0.0
	
	for i in agents:
		avg_dot += abs(i.direction.dot((i.position - com).normalized()))
	
	print( abs(avg_dot / len(agents)))
	return abs(avg_dot / len(agents))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if current_time < time_duration and not is_discrete_time_simulation:
		current_time += delta * time_scale
		for i in agents:
			i.step(delta * time_scale)
		
		emit_signal("end_step")	
		# print("AVG DIST TO COM: {0}, AVG DOT FROM AVG DIR: {1}".format([calculate_avg_dist_to_com_metric(),calculate_vector_divergence_metric()]))
		
		pass
	
func get_agents() -> Array[FishAgent]:
	return agents
	
func _draw():
	if should_apply_bounds:
		draw_rect(bounds, Color.DARK_BLUE, false)
	
	var com : Vector2 = Vector2(0,0)
	
	for i in agents:
		com += i.position
		
	com /= len(agents)
	
	draw_circle(com, 5, Color.DARK_ORANGE)
	


func _on_timer_timeout():
	if current_step < number_of_steps:
		for i in agents:
			i.step(discrete_time_step)
		
		emit_signal("end_step")	
		queue_redraw()
		current_step += 1
		
		# print("AVG DIST TO COM: {0}, AVG DOT FROM AVG DIR: {1}".format([calculate_avg_dist_to_com_metric(),calculate_vector_divergence_metric()]))
			
	pass # Replace with function body.
