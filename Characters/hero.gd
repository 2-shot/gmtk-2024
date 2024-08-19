extends CharacterBody2D

var can_move = true
var interact = false
var last_dir: Vector2
var damagable: bool = false
var is_player_dead: bool = false

var finished_func

@export var walk_speed := 100
@export var eat_speed := 50
#@export var run_speed := 200
@export var hero_size : int = 100 : set = size_changed
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
enum{IDLE, RUN, EAT, IS_EATEN, EXPLODE}
var state = IDLE
var blend_position : Vector2 =Vector2.ZERO
var animTree_state_keys = ["idle","run","eat","is_eaten","explode"]
var eating : bool = false
var hero_speed := walk_speed

func size_changed(size: int):
	hero_size = size
	GlobalSignals.hero_size.emit(hero_size)
	var scale_size = pow(float(hero_size) / 100.0, 1.0/3.0)
	
	GlobalSignals.debug.emit("hero size", "%d" % hero_size)
	scale = Vector2(scale_size, scale_size)
	
	GlobalSignals.debug.emit("hero scale", "%f, %f" % [scale.x, scale.x])

func _ready():
	GlobalSignals.hero_size.emit(hero_size)
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
	animate()

func get_input():
	#var run := Input.is_action_pressed("run")
	#var attack := Input.is_action_pressed("attack")
	var input_direction := Input.get_vector("left", "right", "up", "down")
	var rest = input_direction == Vector2.ZERO
	var interact := Input.is_action_pressed("interact")
	var interact2 := Input.is_action_pressed("interact2")
	
	if state != EXPLODE and state !=IS_EATEN and eating==false:
		if input_direction:
			last_dir = input_direction
		if rest:
			state=IDLE
			velocity = Vector2.ZERO	
		else:
			state=RUN
			velocity = input_direction * hero_speed
			blend_position = input_direction
		if interact:
			state=EXPLODE
			velocity = Vector2.ZERO
		#if interact2:
			#state=EAT
			#eating=true
			#$EatTimer.start()

	if eating:
		velocity = input_direction * hero_speed

	GlobalSignals.debug.emit("Hero Speed", "Player velocity: %f, %f" % [velocity.x, velocity.y])

func animate() -> void:
	state_machine.travel(animTree_state_keys[state])
	if state==IDLE or state==RUN or state==EAT or state==IS_EATEN:
		animationTree.set(blend_pos_paths[state],blend_position)


func _on_eat_timer_timeout() -> void:
	eating=false
	print("eating")

func _on_grow_timeout():
	hero_size += 10
	if hero_size > 200:
		hero_size = 50

func start_eating(enemy : Node2D):
	state=EAT
	eating=true
	enemy.eaten_by(self)
	hero_speed = eat_speed
	
	finished_func = finished_eating(enemy)
	$EatTimer.connect("timeout", finished_func)
	$EatTimer.start()

func finished_eating(body : Node2D):
	return func():
		if body:
			print("finished")
			hero_size += body.slime_size
			body.queue_free()
			hero_speed = walk_speed
			$EatTimer.disconnect("timeout", finished_func)


func _on_area_2d_body_entered(body : Node2D):
	print(body)
	if body.is_in_group("Enemy"):
		var slime_size = body.slime_size
		prints(hero_size, slime_size)
		if hero_size >= slime_size:
			prints("Eat me!")
			start_eating(body)
		else:
			print("Prepare to die!")
