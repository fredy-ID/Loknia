extends Button

signal base_placed

@onready var environment : Node = $"../../Environment"

enum action {CAN_BE_CLICKED=0, CAN_NOT_BE_CLICKED=1}
var state:int = action.CAN_BE_CLICKED

var base_scene = preload("res://scenes/base.tscn")
var base: StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_up() -> void:
	if state==action.CAN_BE_CLICKED:
		base = base_scene.instantiate()
		base.remove_from_group("base")
		base.scale.x = 0.5
		base.scale.y = 0.5
		environment.add_child(base)
		base.connect("add_new_base", _on_add_new_base)
		base.emit_signal("add_new_base")
		state=action.CAN_NOT_BE_CLICKED
	elif state==1:
		pass

func _on_add_new_base():
	print("adding new base")

func _on_base_placed(existing_base=null) -> void:
	if(existing_base):
		base=existing_base
	base.add_to_group("base")
	state = action.CAN_BE_CLICKED
