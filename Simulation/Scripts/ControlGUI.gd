extends Control

var simulation : FishSimulation
@export var disabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	simulation = find_parent("Simulation")
	
	size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ror_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.range_of_repulsion = value
	pass # Replace with function body.


func _on_roo_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.range_of_orientation = value
	pass # Replace with function body.


func _on_roa_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.range_of_attraction = value
	pass # Replace with function body.


func _on_asf_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.attraction_scaling_factor = value
	pass # Replace with function body.


func _on_bsa_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.blind_spot_angle = value
	pass # Replace with function body.


func _on_mna_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.max_noise_angle = value
	pass # Replace with function body.


func _on_move_speed_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.move_speed = value
	pass # Replace with function body.


func _on_turn_speed_slider_value_changed(value):
	if not disabled:
		simulation.fish_stats.turn_speed = value
	pass # Replace with function body.


func _on_simulation_end_step( avg_dist_to_com, global_vec_divergence, local_vec_divergence, swirling_factor):
	$Metrics/PanelContainer/COMMetricChart.add_value(avg_dist_to_com)
	$Metrics/PanelContainer2/VecDivergeChart.add_value(global_vec_divergence)
	$Metrics/PanelContainer3/LocalVecDivergeChart.add_value(local_vec_divergence)
	$Metrics/PanelContainer4/SwirlingChart.add_value(swirling_factor)
#	$Metrics/PanelContainer5/LinearityChart.add_value(linearity)
	pass # Replace with function body.
