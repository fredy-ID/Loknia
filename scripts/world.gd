extends Node2D

var pause_menu = preload("res://scenes/Pause.tscn").instantiate()
var options_scene = preload("res://scenes/Options.tscn").instantiate()
var pause_scene = preload("res://scenes/Pause.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.add_child(pause_scene)
	get_tree().root.add_child(options_scene)
	GameManager.options_scene = options_scene
	GameManager.pause_scene = pause_scene
	GameManager.options_scene.hide()
	GameManager.pause_scene.hide()
	
	if get_tree().paused :
		get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = true
		get_tree().root.add_child(pause_menu)
