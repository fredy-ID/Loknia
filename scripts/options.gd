extends Control

var pause = preload("res://scenes/Pause.tscn").instantiate()

func _on_back_button_up() -> void:
	get_tree().root.add_child(pause)
	self.queue_free()
