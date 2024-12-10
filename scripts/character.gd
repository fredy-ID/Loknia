extends CharacterBody2D

var speed = 300
var accel = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var base1: StaticBody2D = $"../base1"
@onready var base2: StaticBody2D = $"../base2"
@onready var base3: StaticBody2D = $"../base3"
@onready var playerPBar: ProgressBar = $pBar

enum state {IDLE=0, TARGET_SELECTED=1, HARVEST=2}
var action:int = 0

var base_direction: Vector2
var target: StaticBody2D

var harvest_progress = 0.0
var harvest_duration = 2.0  # Durée totale de la récolte en secondes

func _physics_process(delta: float):
	if action == state.IDLE:
		search_next_base_direction()
		action=state.TARGET_SELECTED
	elif action == state.TARGET_SELECTED:
		move_to_target(delta)
		pass
	elif action==state.HARVEST:
		playerPBar.set_z_index(1)
		playerPBar.set_visible(true)
		harvest(delta)

func harvest(delta: float):
	# Mettre à jour la progression de la récolte
	harvest_progress += delta
	playerPBar.value = (harvest_progress / harvest_duration) * 100
	
	# Vérifier si la récolte est terminée
	if harvest_progress >= harvest_duration:
		action = state.IDLE  # Réinitialiser l'état après la récolte
		harvest_progress = 0.0
		playerPBar.set_visible(false)
		playerPBar.value = 0
		# Appeler d'autres fonctions si nécessaire après la récolte

func move_to_target(delta: float):
	nav.target_position = target.global_position
	var direction = Vector2()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func search_next_base_direction():
	var base = select_base()
	target = base
	

func select_base():
	var points_dict = {1: base1, 2: base2, 3: base3}
	var base = randi_range(1, 3)
	print("points_dict : ", points_dict)
	print("points_dict : ", points_dict[1])
	return points_dict[base]


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.get_groups())
	if area.is_in_group("base"):
		action=state.HARVEST
		
