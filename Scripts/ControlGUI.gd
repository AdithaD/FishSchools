extends Control

var simulation : FishSimulation

# Called when the node enters the scene tree for the first time.
func _ready():
	simulation = get_node("/root/Simulation")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ror_slider_value_changed(value):
	simulation.fish_stats.range_of_repulsion = value
	pass # Replace with function body.


func _on_roo_slider_value_changed(value):
	simulation.fish_stats.range_of_orientation = value
	pass # Replace with function body.


func _on_roa_slider_value_changed(value):
	simulation.fish_stats.range_of_attraction = value
	pass # Replace with function body.


func _on_asf_slider_value_changed(value):
	simulation.fish_stats.attraction_scaling_factor = value
	pass # Replace with function body.


func _on_bsa_slider_value_changed(value):
	simulation.fish_stats.blind_spot_angle = value
	pass # Replace with function body.


func _on_mna_slider_value_changed(value):
	simulation.fish_stats.max_noise_angle = value
	pass # Replace with function body.


func _on_move_speed_slider_value_changed(value):
	simulation.fish_stats.move_speed = value
	pass # Replace with function body.


func _on_turn_speed_slider_value_changed(value):
	simulation.fish_stats.turn_speed = value
	pass # Replace with function body.
