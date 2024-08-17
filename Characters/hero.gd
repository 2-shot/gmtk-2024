extends CharacterBody2D

var can_move = true
var interact = false
var last_dir: Vector2
var damagable: bool = false
var is_player_dead: bool = false

@export var walk_speed = 100
@export var run_speed = 200
@export var run_anim_scale = 2
@onready var animationTree = $AnimationTree

#animations and hitbox
enum{IDLE, RUN, SWORD, DEATH}
var state = IDLE

var blend_position : Vector2 =Vector2.ZERO


#var blend_pos_paths = [
#	"parameters/idle/idle_blendspace2d/blend_position",
#	"parameters/run/run_blendspace2d/blend_position",
#	"parameters/sword/sword_attack_blendspace2d/blend_position"
#	]
var animTree_state_keys = ["idle","run","death"]


func _ready():
	#if $DamageCooldown:
	#	$DamageCooldown.start()
	pass

func _physics_process(_delta):		
	get_input()
	move_and_slide()

func get_input():
	#var run := Input.is_action_pressed("run")
	#var attack := Input.is_action_pressed("attack")
	var input_direction := Input.get_vector("left", "right", "up", "down")
	var rest = input_direction == Vector2.ZERO

	if input_direction:
		last_dir = input_direction

	if rest:
		state=IDLE
		velocity = Vector2.ZERO
	else:
		state=RUN
		velocity = input_direction * walk_speed
		#blend_position = input_direction
