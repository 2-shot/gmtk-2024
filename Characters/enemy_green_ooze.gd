extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var los = $LineOfSight

#slime properties
var movement_speed=40
@export var slime_size: int = 100

@export var target: Node2D = null
#interaction with hero
var detected_hero: bool = true
var can_eat_hero: bool=false
var hero_can_eat_me: bool=false

#line of sight
var player_spotted:bool=false


func _ready():
	GlobalSignals.hero_size.connect(size_changed)
	get_node("Timer").start()
	

func _on_timer_timeout() -> void:
	update_pathfinding()
	navigation_agent_2d.target_position = target.global_position

func update_pathfinding():
	print("trying to update pathfinding")
	if target and detected_hero:
		print("updating pathfinding")
		navigation_agent_2d.target_position = target.global_position
		
	
func _physics_process(_delta):
	if navigation_agent_2d.is_navigation_finished():
		return
	
	los.look_at(target.global_position)
	#if player_spotted:
		
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
	
func check_player_in_direction():
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted=true
		print("Player Spotted")
		

	
func size_changed(hero_size:int):
	assert(not (hero_size == slime_size),"HERO SIZE SAME AS ENEMY")
	if hero_size >= slime_size:
		can_eat_hero=false
	else:
		can_eat_hero=true
