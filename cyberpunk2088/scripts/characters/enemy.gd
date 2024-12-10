class_name Enemy
extends Character 

@export var health:int = 100 + Stats.level * 50
@export var max_health:int = 100 + Stats.level * 50
@export var coin_reward:int = 100 + Stats.level * 50
@export var damage: int = 10

@export var player: CharacterBody2D



var cmd_list : Array[Command]
var _damaged:bool = false
var _dead:bool = false
var damage_text = preload("res://scenes/attacks/damage_text.tscn")

var player_function: Node

@onready var animation_tree:AnimationTree = $AnimationTree
@onready var health_node:Control = $Health
@onready var health_bar:ProgressBar = $Health/ProgressBar



enum States{
	WANDER,
	CHASE
}

var last_hit:float = 0.0

func _ready():
	animation_tree.active = true
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	bind_commands()
	

func _physics_process(delta: float):
	#handle_gravity(delta)
	#handle_movement(delta)
	#change_direction()
	#look_for_player()
	#
	last_hit += delta
	if last_hit > 3:
		health_node.visible = false
	super(delta)
	pass

func take_damage(damage:float) -> void:
	if _dead:
		return
	var dmg_text = damage_text.instantiate()
	dmg_text.damage = damage
	dmg_text.global_position = global_position
	get_tree().current_scene.add_child(dmg_text)
	last_hit = 0
	health_node.visible = true
	health -= damage
	health_node.visible = true
	health_bar.value = health
	if health <= 0 and not _dead:
		_dead = true
		Stats.coins += coin_reward
		queue_free()
	


func bind_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	# fire1 = RangedAttackCommand.new()
	idle = IdleCommand.new()
	
