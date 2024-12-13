extends StaticBody2D

signal add_new_base

@onready var base_button: Button = $"../../GridContainer/Button"
@onready var buttons_container: Control = $Buttons
@onready var navigation_region_2d : NavigationRegion2D = $"../../NavigationRegion2D"

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
		
	#var mouse_tile = GameManager.world_floor_tilemap.local_to_map(get_global_mouse_position())
	#
	#var local_pos = GameManager.world_floor_tilemap.map_to_local(mouse_tile)
	#print(local_pos)
	#var world_pos = GameManager.world_floor_tilemap.to_global(local_pos)
	#global_position = world_pos
	
	var mouse_tile = GameManager.world_floor_tilemap.local_to_map(get_global_mouse_position())
	#var local_pos = GameManager.world_floor_tilemap.map_to_local(mouse_tile)
	#var world_pos = GameManager.world_floor_tilemap.to_global(local_pos)
	
	
	var coords: Vector2i = Vector2i(16,1)
	var tilemap_atlas_coord = GameManager.world_floor_tilemap.get_cell_atlas_coords(mouse_tile)
	
	print(tilemap_atlas_coord)
	GameManager.world_floor_tilemap.set_cell(mouse_tile, 0, coords)


func _physics_process(delta):
	if state == action.DRAGGED:
		var mouse_pos = get_global_mouse_position()
		self.position = global_position.lerp(mouse_pos, delta * FOLLOW_SPEED)
		
		#var mouse_tile = GameManager.world_floor_tilemap.local_to_map(get_global_mouse_position())
		#var tilemap_atlas_coord = GameManager.world_floor_tilemap.get_cell_atlas_coords(6,1)
		#print(tilemap_atlas_coord)
		
		if Input.is_action_just_pressed("click"):
			state = action.PLACED
			base_button.connect("base_placed", _on_base_placed)
			base_button.emit_signal("base_placed", self)
			
			navigation_region_2d.connect("bake_terrain", _on_bake_terrain)
			navigation_region_2d.emit_signal("bake_terrain")

func _on_add_new_base() -> void:
	state = action.DRAGGED

func _on_bake_terrain() -> void:
	pass

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
