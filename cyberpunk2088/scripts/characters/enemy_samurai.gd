class_name EnemySamurai
extends Enemy

@export var SPEED: int = 100
@export var CHASE_SPEED: int = 400
@export var ACCELERATION: int = 300


var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2


@onready var ray_cast:RayCast2D = $RayCast2D
@onready var timer:Timer = $ChaseTimer
@onready var sprite1: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var collision_shape: CollisionShape2D = $HitBox/CollisionShape2D


var current_state = States.WANDER


func _ready():
	#animation_tree.active = true
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	damage = 10
	
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
	
	_manage_animation()
	last_hit += delta
	if last_hit > 3:
		health_node.visible = false
	
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
		animation_player.play("death")
		queue_free()


func _manage_animation() -> void:
	if attacking:
		animation_player.play("attack")	
	else:
		if !is_zero_approx(velocity.x):
			animation_player.play("move")
		else:
			animation_player.play("idle")
		
	
	#if not is_on_floor():
		#animation_player.play("jump")
	
	
		
	if _damaged:
		animation_player.play("hurt")
	

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
			attacking = true
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
		attacking = false
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
				ray_cast.target_position = Vector2(-40, 0)
		else:
			# moving left
			if self.global_position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
			else:
				sprite1.flip_h = false
				ray_cast.target_position = Vector2(40, 0)
	else:
		# States.CHASE
		direction = (player.global_position - self.global_position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			sprite1.flip_h = false
			ray_cast.target_position = Vector2(40, 0)
		else:
			sprite1.flip_h = true
			ray_cast.target_position = Vector2(-40, 0)
	

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body == player:
		#attacking = true
		signals.player_take_damage.emit(damage)
		print("enter")


#func _on_hit_box_body_exited(body: Node2D) -> void:
	#attacking = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		pass

func _on_chase_timer_timeout() -> void:
	current_state = States.WANDER
	left_bounds = self.global_position + Vector2(-125, 0)
	right_bounds = self.global_position + Vector2(125, 0)
