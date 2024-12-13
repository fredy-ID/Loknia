extends CharacterBody2D

var speed = 300
var accel = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var base1: StaticBody2D = $"../Environment/base1"
@onready var base2: StaticBody2D = $"../Environment/base2"
@onready var base3: StaticBody2D = $"../Environment/base3"
@onready var playerPBar: ProgressBar = $pBar

enum action {IDLE=0, TARGET_SELECTED=1, HARVEST=2}
var state:int = 0

var base_direction: Vector2
var target: StaticBody2D

var harvest_progress = 0.0
var harvest_duration = 2.0  # Durée totale de la récolte en secondes

var stop_distance = 10.0

func _physics_process(delta: float):
	if state == action.IDLE:
		search_next_base_direction()
		state=action.TARGET_SELECTED
	elif state == action.TARGET_SELECTED:
		move_to_target(delta)
	elif state==action.HARVEST:
		#playerPBar.set_z_index(1)
		playerPBar.set_visible(true)
		harvest(delta)

func harvest(delta: float):
	# Mettre à jour la progression de la récolte
	harvest_progress += delta
	playerPBar.value = (harvest_progress / harvest_duration) * 100
	
	# Vérifier si la récolte est terminée
	if harvest_progress >= harvest_duration:
		state = action.IDLE  # Réinitialiser l'état après la récolte
		harvest_progress = 0.0
		playerPBar.set_visible(false)
		playerPBar.value = 0
		# Appeler d'autres fonctions si nécessaire après la récolte

func move_to_target(delta: float):
	if not is_instance_valid(target):
		search_next_base_direction()
		return
	nav.target_position = calculate_target_position(target.global_position, self.position, stop_distance)
	var direction = Vector2()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func search_next_base_direction():
	var base = select_base()
	target = base
	

func select_base():
	var bases = get_tree().get_nodes_in_group("base")
	var base = randi_range(0, bases.size()-1)
	print("bases _____ : ", bases, "SIZE : ____ ", bases.size()-1, "SELECTED BASE : ____ ", base)
	#print("points_dict : ", points_dict)
	#print("points_dict : ", points_dict[1])
	return bases[base]

func calculate_target_position(base_pos: Vector2, char_pos: Vector2, stop_dist: float) -> Vector2:
	var direction = (base_pos - char_pos).normalized()
	return base_pos - direction * stop_dist

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.get_groups())
	if area.is_in_group("Collision_Interactible_BASE"):
		state=action.HARVEST
		
