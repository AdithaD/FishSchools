extends Node2D
class_name FishAgent

@export var stats : FishStats

@onready var simulation = find_parent("Simulation") as FishSimulation

var direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2d.rotation = direction.angle()
	pass # Replace with function body.

	
func step(delta):
	var new_direction = calculate_next_direction()
	
	turn_towards(simulation.apply_bounds_control(self, new_direction), stats.turn_speed * delta)
	
	position += direction * stats.move_speed * delta
	pass
	
func turn_towards(new_direction: Vector2, max_angle_in_radians: float) -> void:
	# positive is clockwise , negative anti clockwise
	var angle_from_current = direction.angle_to(new_direction) + randf_range(-1, 1) * stats.max_noise_angle
	
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
		
		## vision angle
		if abs(displacement.angle_to(-direction)) > stats.blind_spot_angle :
			if displacement.length() < stats.range_of_repulsion:
				repulsion += -displacement
				pass
			elif displacement.length() < stats.range_of_orientation:
				orientation += agent.direction
				pass
			elif displacement.length() < stats.range_of_attraction:
				attraction += displacement
				pass
		
			
	var new_direction = Vector2(0,0)
	
	if repulsion.length() > 0:
		new_direction = repulsion.normalized()
	else:
		new_direction = (orientation.normalized() + stats.attraction_scaling_factor * attraction.normalized()).normalized()
	pass
	
	return new_direction
	


func get_displacement_to(agent: FishAgent):
	return agent.position - self.position
