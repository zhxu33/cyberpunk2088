class_name Enemy
extends Character 

@export var health:int = 100 + Stats.level * 50
@export var max_health:int = 100 + Stats.level * 50
@export var coin_reward:int = 100 + Stats.level * 50
var cmd_list : Array[Command]
var _damaged:bool = false
var _dead:bool = false

@onready var animation_tree:AnimationTree = $AnimationTree
@onready var health_node:Control = $Health
@onready var health_bar:ProgressBar = $Health/ProgressBar

var last_hit:float = 0.0

func _ready():
	animation_tree.active = true
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	bind_commands()
	

func _physics_process(delta: float):
	last_hit += delta
	if last_hit > 3:
		health_node.visible = false
	_manage_animation_tree_state()
	super(delta)
	

func take_damage(damage:float) -> void:
	last_hit = 0
	health_node.visible = true
	health -= damage
	health_node.visible = true
	health_bar.value = health
	if health <= 0 and not _dead:
		_dead = true
		Stats.coins += coin_reward
		queue_free()
	
func _manage_animation_tree_state() -> void:
	if !is_zero_approx(velocity.x):
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false
	
	if is_on_floor():
		animation_tree["parameters/conditions/jumping"] = false
		animation_tree["parameters/conditions/on_floor"] = true
	else:
		animation_tree["parameters/conditions/jumping"] = true
		animation_tree["parameters/conditions/on_floor"] = false
	
	##toggles
	#if attacking:
		#animation_tree["parameters/conditions/attacking"] = true
		#attacking = false
	#else:
		#animation_tree["parameters/conditions/attacking"] = false
		#
	#if _damaged:
		#animation_tree["parameters/conditions/damaged"] = true
		#_damaged = false
	#else:
		#animation_tree["parameters/conditions/damaged"] = false

func bind_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	# fire1 = RangedAttackCommand.new()
	idle = IdleCommand.new()
