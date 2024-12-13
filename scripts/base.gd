extends StaticBody2D

signal add_new_base

@onready var base_button: Button = $"../../GridContainer/Button"
@onready var buttons_container: Control = $Buttons

const FOLLOW_SPEED = 10.0

enum action {PLACED=0, DRAGGED=1}
var state:int = action.PLACED
var toggle_action_buttons: bool = false
var mouse_in_state: bool = false

func _ready() -> void:
	buttons_container.visible = toggle_action_buttons

func _process(delta: float) -> void:
	if Input.is_action_just_released("click") and mouse_in_state==false:
		buttons_container.visible = false

func _physics_process(delta):
	if state == action.DRAGGED:
		var mouse_pos = get_global_mouse_position()
		self.position = global_position.lerp(mouse_pos, delta * FOLLOW_SPEED)
		
		if Input.is_action_just_pressed("click"):
			state = action.PLACED
			base_button.connect("base_placed", _on_base_placed)
			base_button.emit_signal("base_placed", self)

func _on_add_new_base() -> void:
	state = action.DRAGGED
	print("base added : ", state)

func _on_base_placed() -> void:
	state = action.PLACED

func _on_move_button_up() -> void:
	self.remove_from_group("base")
	state = action.DRAGGED

func _on_delete_button_up() -> void:
	self.remove_from_group("base")
	self.queue_free()

func _on_area_2d_mouse_entered() -> void:
	mouse_in_state=true

func _on_area_2d_mouse_exited() -> void:
	mouse_in_state=false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		toggle_action_buttons = !toggle_action_buttons
		buttons_container.visible = toggle_action_buttons
