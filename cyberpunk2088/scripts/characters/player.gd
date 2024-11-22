class_name Player
extends Character 

@export var health:int = 100
var cmd_list : Array[Command]
var _damaged:bool = false
var _dead:bool = false

@onready var animation_tree:AnimationTree = $AnimationTree

var attack_cooldown:float
var cooldown_elapsed:float
var jump_amount:int


func _ready():
	animation_tree.active = true
	unbind_player_input_commands()

func _physics_process(delta: float):
	# update player stats
	jump_velocity = DEFAULT_JUMP_VELOCITY - Stats.upgrades["Jump Power"]*25
	movement_speed = DEFAULT_MOVE_VELOCITY + Stats.upgrades["Movement Speed"]*20
	health = Stats.health
	attack_cooldown = 0.75 - 0.05 * Stats.upgrades["Attack Speed"]

	if Input.is_action_pressed("attack") and cooldown_elapsed >= attack_cooldown:
		fire1.execute(self)
		cooldown_elapsed = 0
	
	cooldown_elapsed += delta
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_amount < Stats.upgrades["Double Jump"]):
		if not is_on_floor():
			jump_amount += 1
		up_cmd.execute(self)
	
	if is_on_floor():
		jump_amount = 0
		
	var move_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if move_input > 0.1:
		right_cmd.execute(self)
	elif move_input < -0.1:
		left_cmd.execute(self)
	else:
		idle.execute(self)
		
	_manage_animation_tree_state()
	super(delta)
	
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

func bind_player_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	fire1 = AttackCommand.new()
	idle = IdleCommand.new()

func unbind_player_input_commands():
	right_cmd = Command.new()
	left_cmd = Command.new()
	up_cmd = Command.new()
	fire1 = Command.new()
	idle = Command.new()
