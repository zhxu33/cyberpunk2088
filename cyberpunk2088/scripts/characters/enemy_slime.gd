class_name EnemySlime
extends Enemy

@export var SPEED: int = 100
@export var CHASE_SPEED: int = 200
@export var ACCELERATION: int = 300


var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var start_moving: bool = false
var _death: bool = false

func _ready():
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	bind_commands()


func _physics_process(delta: float):
	if sprite == null:
		return
	
	change_direction()
	
	if start_moving == true:
		chase_player()
	
	if not self.is_on_floor():
		_apply_gravity(delta)
	
	last_hit += delta
	if last_hit > 3:
		health_node.visible = false
	_manage_animation()
	super(delta)


func take_damage(dmg:int) -> void:
	super(dmg)
	if 0 >= health:
		_death = true
		velocity = Vector2.ZERO
		animation_player.play("death")


func bind_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	# fire1 = RangedAttackCommand.new()
	idle = IdleCommand.new()


func change_direction():
	direction = (player.global_position - self.global_position).normalized()
	direction = sign(direction)
	if direction.x == 1:
		sprite.flip_h = true
		change_facing(Facing.LEFT)
	else:
		sprite.flip_h = false
		change_facing(Facing.RIGHT)


func _manage_animation() -> void:
	if _death:
		animation_player.play("death")
		velocity = Vector2.ZERO
	else:
		if attacking:
			animation_player.play("attack")	
		else:
			animation_player.play("idle")


func chase_player() -> void:
	direction = (player.global_position - self.global_position).normalized()
	direction = sign(direction)
	if direction.x == 1:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
