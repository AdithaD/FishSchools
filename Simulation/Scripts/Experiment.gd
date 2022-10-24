extends Node2D

var simulation = preload("res://PackedScenes/Simulator.tscn")

@export var experiment_stats : ExperimentStats
@export var experiment_name : String
@export var reverse =true
var current_experiment = 0

var experiment_schedule : Array = []

@onready var experiment_name_full = "%s_%s" % [Time.get_time_string_from_system().replace(":","_"), experiment_name]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	experiment_schedule = experiment_stats.generate_experiment_schedule()
	
	print('Experiment starting...')
	
	start_next_simulation()
	
	pass # Replace with function body.

func start_next_simulation() -> void:
	print('Starting simulation %d our of %d' % [current_experiment + 1, len(experiment_schedule)])
	var new_simulation = simulation.instantiate() as FishSimulation
	new_simulation.connect("simulation_ended", on_simulation_ended)
	
	var new_stats = FishStats.new()
	
	var next_index  = current_experiment
	
	if reverse:
		next_index = len(experiment_schedule) - 1 - current_experiment
	
	new_stats.init_from_list(experiment_schedule[next_index])
	
	print(new_stats)
	
	new_simulation.set_fish_stats(new_stats)
	
	add_child(new_simulation, true)
	new_simulation.start_simulation()
	pass
	
func on_simulation_ended() -> void:
	current_experiment+=1
	get_child(0).queue_free()
	await get_tree().process_frame
	start_next_simulation()

	pass

func get_experiment_name() -> String:
	return experiment_name_full
