extends Control

@export var property_name = ""

@onready var simulation : FishSimulation = get_node("/root/Simulation")

# Called when the node enters the scene tree for the first time.
func _ready():
	$HSplitContainer/Slider.value = simulation.fish_stats.get(property_name)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_slider_value_changed(value):
	simulation.fish_stats.set(property_name, value)
	$HSplitContainer/ValueText.text = str(value)
	pass # Replace with function body.
