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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_time += delta * time_scale
	
	if current_time < time_duration:
		for i in agents:
			i.step(delta * time_scale)
		pass
	
func get_agents() -> Array[FishAgent]:
	return agents
	
func _draw():
	if should_apply_bounds:
		draw_rect(bounds, Color.DARK_BLUE, false)


func _on_timer_timeout():
	if not current_step > number_of_steps:
		for i in agents:
			i.step(discrete_time_step * time_scale)
			current_step += 1
		
	pass # Replace with function body.
