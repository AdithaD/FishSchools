extends Node2D
class_name FishSimulation

@export var amount_of_fish = 100
@export var fish_agent : PackedScene

@export var bounds : Rect2i

var agents : Array[FishAgent] = []

# Called when the node enters the scene tree for the first time.
func _ready():
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_agents() -> Array[FishAgent]:
	return agents
