extends Node2D

signal area_selected

var pause_menu = preload("res://scenes/Pause.tscn").instantiate()
var options_scene = preload("res://scenes/Options.tscn").instantiate()
var pause_scene = preload("res://scenes/Pause.tscn").instantiate()

var units: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	units = get_tree().get_nodes_in_group("units")
	print("All UNIT : ", units)
	get_tree().root.add_child.call_deferred(pause_scene)
	get_tree().root.add_child.call_deferred(options_scene)
	GameManager.options_scene = options_scene
	GameManager.pause_scene = pause_scene
	GameManager.options_scene.hide()
	GameManager.pause_scene.hide()
	
	if get_tree().paused :
		get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = true
		get_tree().root.add_child(pause_menu)
	
func _on_area_selected(object):
	print("AREA SELECTED")
	var start = object.start
	var end = object.end
	var area: Array = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	var units_selected: Array = get_units_in_area(area)
	
	deselect_all_units()
		
	for unit in units_selected:
		unit.set_selected(!unit.selected)


func deselect_all_units():
	for unit in units:
		unit.set_selected(false)


func get_units_in_area(area: Array):
	print("UNITS : ")
	var _units: Array = []
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				_units.append(unit)
	
	return _units
