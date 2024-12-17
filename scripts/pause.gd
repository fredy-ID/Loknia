extends Control

var options = preload("res://scenes/Options.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_resume_button_up() -> void:
	get_tree().paused = false
	get_tree().root.remove_child(self)


func _on_main_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	self.hide()


func _on_quit_button_up() -> void:
	get_tree().quit()


func _on_options_button_up() -> void:
	GameManager.prevscene = get_tree().current_scene.scene_file_path
	GameManager.pause_scene = self
	get_tree().root.add_child(options)
	self.queue_free()
