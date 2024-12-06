class_name Enemy
extends Character 

@export var health:int = 100 + Stats.level * 50
@export var max_health:int = 100 + Stats.level * 50
@export var coin_reward:int = 100 + Stats.level * 50
@export var damage: int = 10

@export var player: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 200
@export var ACCELERATION: int = 300



var cmd_list : Array[Command]
var _damaged:bool = false
var _dead:bool = false

var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

var player_function: Node
var projectile:PackedScene = preload("res://scenes/attacks/emeny_dog_bullet.tscn")


@onready var animation_tree:AnimationTree = $AnimationTree
@onready var health_node:Control = $Health
@onready var health_bar:ProgressBar = $Health/ProgressBar
@onready var ray_cast:RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var timer:Timer = $ChaseTimer
@onready var sprite1: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_timer: Timer = $BulletTimer


enum States{
	WANDER,
	CHASE
}

var current_state = States.WANDER

var last_hit:float = 0.0

func _ready():
	animation_tree.active = true
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	
	left_bounds = self.global_position + Vector2(-125, 0)
	right_bounds = self.global_position + Vector2(125, 0)
	attacking = false
	
	
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	bind_commands()
	

func _physics_process(delta: float):
	if ray_cast == null:
		return
	
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_player()
	
	last_hit += delta
	if last_hit > 3:
		health_node.visible = false
	#_manage_animation_tree_state()
	if attacking == true:
		sprite1.play("attack")
		# print("goes here")
	
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
	

func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is Player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()
		

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE


func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()


func handle_movement(delta: float) -> void:
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)
	
	move_and_slide()


func change_direction() -> void:
	if current_state == States.WANDER:
		if !sprite1.flip_h:
			# moving right
			if self.global_position.x <= right_bounds.x:
				direction = Vector2(1, 0)
			else:
				sprite1.flip_h = true
				direction = Vector2(-1, 0)
				self.velocity = direction * -SPEED
				ray_cast.target_position = Vector2(-125, 0)
		else:
			if self.global_position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
			else:
				sprite1.flip_h = false
				ray_cast.target_position = Vector2(125, 0)
	else:
		# States.CHASE
		direction = (player.global_position - self.global_position).normalized()
		#print("direction is:", direction)
		#print(player.global_position, " and ", self.global_position)
		direction = sign(direction)
		#print(direction)
		if direction.x == 1:
			sprite1.flip_h = false
			ray_cast.target_position = Vector2(125, 0)
		else:
			sprite1.flip_h = true
			ray_cast.target_position = Vector2(-125, 0)
	

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func fire() -> void:
	var new_projectile = projectile.instantiate() as EnemyDogBullet
	if direction.x == 1:
		$ProjectileSpawnRight.add_child(new_projectile)
	else:
		$ProjectileSpawnLeft.add_child(new_projectile)

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body is Player:
		#player = body
#
# position
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body is Player:
		#pass


func _on_timer_timeout() -> void:
	current_state = States.WANDER
	left_bounds = self.global_position + Vector2(-125, 0)
	right_bounds = self.global_position + Vector2(125, 0)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body == player:
		attacking = true
		signals.player_take_damage.emit(damage)
		# print("enter")


func _on_hit_box_body_exited(body: Node2D) -> void:
	attacking = false


func _on_bullet_timer_timeout() -> void:
	fire()


func dog_facing_direction():
	return direction
	
