extends StaticBody2D

signal add_new_base

@onready var base_button: Button = $"../../GridContainer/Button"

const FOLLOW_SPEED = 10.0

enum action {PLACED=0, DRAGGED=1}
var state:int = action.PLACED

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	if state == action.DRAGGED:
		var mouse_pos = get_global_mouse_position()
		self.position = global_position.lerp(mouse_pos, delta * FOLLOW_SPEED)
		
		if Input.is_action_just_pressed("click"):
			state = action.PLACED
			base_button.connect("base_placed", _on_base_placed)
			base_button.emit_signal("base_placed")

func _on_add_new_base() -> void:
	state = action.DRAGGED
	print("base added : ", state)

func _on_base_placed() -> void:
	state = action.PLACED
