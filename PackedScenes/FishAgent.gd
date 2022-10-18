extends Node2D
class_name FishAgent

@export var range_of_attraction = 300
@export var range_of_orientation = 150
@export var range_of_repulsion = 50


@export var attraction_scaling_factor = 1

@export var move_speed = 5
@export var turn_speed = 5

@onready var simulation = get_node("/root/Simulation") as FishSimulation

var direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2d.rotation = direction.angle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_direction = calculate_next_direction()
	
	turn_towards(new_direction, turn_speed * delta)
	
	position += direction * move_speed * delta
	pass
	
func turn_towards(new_direction: Vector2, max_angle_in_radians: float) -> void:
	# positive is clockwise , negative anti clockwise
	var angle_from_current = direction.angle_to(new_direction)
	
	var turn_direction = sign(angle_from_current)
	
	var clamped = min(abs(angle_from_current), max_angle_in_radians)
	
	direction = direction.rotated(clamped * turn_direction)
	
	$Sprite2d.rotation = direction.angle()

func calculate_next_direction() -> Vector2:
	var agents = simulation.get_agents()
	
	var repulsion = Vector2(0,0)
	var orientation = Vector2(0,0)
	var attraction = Vector2(0,0)

	for agent in agents:
		var displacement = get_displacement_to(agent)
		
		if displacement.length() < range_of_repulsion:
			repulsion += -displacement
			pass
		elif displacement.length() < range_of_orientation:
			orientation += agent.direction
			pass
		elif displacement.length() < range_of_attraction:
			attraction += displacement
			pass
			
	var new_direction = Vector2(0,0)
	
	if repulsion.length() > 0:
		new_direction = repulsion.normalized()
	else:
		new_direction = (orientation.normalized() + attraction_scaling_factor * attraction.normalized()).normalized()
	pass
	
	return new_direction
	


func get_displacement_to(agent: FishAgent):
	return agent.position - self.position
