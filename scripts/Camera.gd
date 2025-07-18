extends Camera2D

@onready var box: Panel = get_node("../Panel")
@onready var world: Node2D = $"../../"

var mousePos: Vector2 = Vector2()

var mousePosGlobal: Vector2 = Vector2()
var start: Vector2 = Vector2()
var startV: Vector2 = Vector2()
var end: Vector2 = Vector2()
var endV: Vector2 = Vector2()
var isDragging: bool = false



#signal area_selected
signal atart_move_selection


func _ready():
	#connect("area_selected", Callable(get_parent(), "_on_area_selected"))
	pass


func _process(_delta):
	if Input.is_action_just_pressed("click"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
		
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
		
	if Input.is_action_just_released("click"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			world.connect("area_selected", _on_area_selected)
			world.emit_signal("area_selected", self)
			#world.emit_signal("area_selected", self)
		else:
			end = start
			isDragging = false
			draw_area(false)

func _on_area_selected(camera):
	print("selectig an area")

func _input(event):
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()


func draw_area(s: bool = true):
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	box.position = pos
	box.size *= int(s)
