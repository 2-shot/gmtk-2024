extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var los = $LineOfSight
@onready var detection_timeout_timer: Timer = $DetectionTimeoutTimer

#slime properties
@export var movement_speed=40
@export var runaway_speed=20
@export var runs_away: bool= true
@export var slime_size: int = 100

@export var target: Node2D = null
#interaction with hero
var can_eat_hero: bool=false
var hero_can_eat_me: bool=false

#line of sight
var player_detected:bool=false
var player_visible:bool=false

#animations
@export var run_anim_scale = 1
@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]
enum{IDLE, RUN}
var state = IDLE
var animTree_state_keys = ["idle","run"]
var being_eaten := false


func _ready():
	GlobalSignals.hero_size.connect(size_changed)
	#await get_tree().create_timer(randi()*3).timeout
	get_node("Timer").start()
	
# pathfinding timer, update pathfinding target
func _on_timer_timeout() -> void:
	if target:
		#print("updating pathfinding")
		navigation_agent_2d.target_position = target.global_position

#detection timer
func _on_detection_timeout_timer_timeout() -> void:
	player_detected=false


func eaten_by(_player : Node2D):
	being_eaten = true
	#if player.position.x > position.x:
		#state = EATEN_RIGHT
	#else:
		#state = EATEN_LEFT


func _physics_process(_delta):
	if navigation_agent_2d.is_navigation_finished():
		return
		
	if being_eaten:
		$Collision.disabled = true
		animate()
		return
		
	#Move Line of Sight Raycast to look toward player
	los.look_at(target.global_position + Vector2(0,2))	# fix todo. Currently adjusting to hit players colision shape	
#	queue_redraw()
		
	check_player_in_direction()
	GlobalSignals.debug.emit("RayCast", "Player Detected: %s Player Visible: %s" % [player_detected, player_visible])
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	
	if player_visible:
		#reset timer if visible
		if not detection_timeout_timer.is_stopped():
			detection_timeout_timer.stop()
	else:
		#start detection timer if not started yet 
		if detection_timeout_timer.is_stopped():
			detection_timeout_timer.start()
		
	if player_detected:
		if can_eat_hero or not runs_away:
			velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		else:
			velocity = current_agent_position.direction_to(next_path_position) * -runaway_speed
		state=RUN
	else:
		velocity = Vector2.ZERO
		state=IDLE

	# flip depending on velocity
	$Sprite2D.flip_h = velocity > Vector2.ZERO

	move_and_slide()
	animate()
	
func check_player_in_direction():
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_detected=true
		player_visible=true
	else:
		player_visible=false

	
func size_changed(hero_size:int):
	#assert(not (hero_size == slime_size),"HERO SIZE SAME AS ENEMY")
	if hero_size >= slime_size:
		can_eat_hero=false
	else:
		can_eat_hero=true

func animate():
	state_machine.travel(animTree_state_keys[state])
