extends CharacterBody2D

var can_move = true
var interact = false
var last_dir: Vector2
var damagable: bool = false
var is_player_dead: bool = false

@export var walk_speed = 100
@export var run_speed = 200
@export var slime_size = 1
#animations
@export var run_anim_scale = 2
@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]
var blend_pos_paths = [
	"parameters/idle/BlendSpace2D/blend_position",
	"parameters/run/BlendSpace2D/blend_position",
	"parameters/eat/BlendSpace2D/blend_position"
]

#animations and hitbox
enum{IDLE, RUN, EAT, DEATH}
var state = IDLE
var blend_position : Vector2 =Vector2.ZERO
var animTree_state_keys = ["idle","run","eat","death"]

func size_changed(size: int):
	prints("New size", size)

func _ready():
	GlobalSignals.slime_size.connect(size_changed)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	animate()

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
		blend_position = input_direction

func animate() -> void:
	state_machine.travel(animTree_state_keys[state])
	animationTree.set(blend_pos_paths[state],blend_position)
