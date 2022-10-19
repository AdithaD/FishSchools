extends Node2D
class_name FishSimulation

@export var amount_of_fish = 100
@export var fish_agent : PackedScene

@export var should_apply_bounds = true
@export var bounds_size : Vector2

var bounds : Rect2i
var agents : Array[FishAgent] = []

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
		
		new_fish.position = Vector2(new_x, new_y)
		new_fish.direction = new_direction
		
		$Agents.add_child(new_fish)
	pass # Replace with function body.

func apply_bounds_control(fish, desired_direction) -> Vector2:
	if not bounds.has_point(fish.position) and should_apply_bounds:
		var center = Vector2(bounds.size / 2 + bounds.position)
		
		var adjustment_direction = (center - fish.position).normalized()
		return adjustment_direction
	else :
		return desired_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_agents() -> Array[FishAgent]:
	return agents
	
func _draw():
	if should_apply_bounds:
		draw_rect(bounds, Color.DARK_BLUE, false)
