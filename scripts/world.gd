extends Node2D

var pause_menu = preload("res://scenes/Pause.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = true
		get_tree().root.add_child(pause_menu)
	
