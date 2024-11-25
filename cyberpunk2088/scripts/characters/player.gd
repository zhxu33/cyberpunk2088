class_name Player
extends Character 

@export var health:int = 100

var cmd_list : Array[Command]
var _damaged:bool = false
var _dead:bool = false
var attack_cooldown:float
var cooldown_elapsed:float
var jump_amount:int

@onready var animation_tree:AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true
	unbind_player_input_commands()

func _physics_process(delta: float):
	# update player stats
	jump_velocity = DEFAULT_JUMP_VELOCITY - Stats.upgrades["Jump Power"]*25
	movement_speed = DEFAULT_MOVE_VELOCITY + Stats.upgrades["Movement Speed"]*20
	health = Stats.health
	attack_cooldown = 0.75 - 0.05 * Stats.upgrades["Attack Speed"]

	# Process ranged attack
	if Input.is_action_pressed("ranged_attack") and cooldown_elapsed >= attack_cooldown:
		fire1.execute(self)
		cooldown_elapsed = 0
	cooldown_elapsed += delta
	
	# melee melee attack
	if Input.is_action_just_pressed("melee_attack"):
		fire2.execute(self)
		
	# Process multi_jump
	if is_on_floor():
		jump_amount = 0
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			up_cmd.execute(self)
		elif jump_amount < Stats.upgrades["Double Jump"]:
			jump_amount += 1
			up_cmd.execute(self)
	# Process horizontal move
	var move_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if move_input > 0.1:
		right_cmd.execute(self)
	elif move_input < -0.1:
		left_cmd.execute(self)
	else:
		idle.execute(self)
	
	# Process attack
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
		animation_tree["parameters/conditions/multi_jumping"] = false
		animation_tree["parameters/conditions/on_floor"] = true
	else:
		if jump_amount > 0:
			animation_tree["parameters/conditions/multi_jumping"] = true
		else:
			animation_tree["parameters/conditions/jumping"] = true
		animation_tree["parameters/conditions/on_floor"] = false
	
	if attacking:
		animation_tree["parameters/conditions/attacking"] = true
		attacking = false
	else:
		animation_tree["parameters/conditions/attacking"] = false

	#if _damaged:
		#animation_tree["parameters/conditions/damaged"] = true
		#_damaged = false
	#else:
		#animation_tree["parameters/conditions/damaged"] = false

func bind_player_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	fire1 = RangedAttackCommand.new()
	fire2 = MeleeAttackCommand.new()
	idle = IdleCommand.new()

func unbind_player_input_commands():
	right_cmd = Command.new()
	left_cmd = Command.new()
	up_cmd = Command.new()
	fire1 = Command.new()
	idle = Command.new()
