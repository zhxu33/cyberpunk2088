class_name BossSlime
extends Enemy 

var boss_slime_fight_start: bool = false
var direction: Vector2
var distance: Vector2
var _death:bool = false

@onready var hit_box_collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape

func _ready():
	max_health = 200 + Stats.level * 100
	health = 200 + Stats.level * 100
	coin_reward = 200 + Stats.level * 100
	
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	
	hit_box_collision_shape.disabled = false
	
	super()

func _physics_process(delta: float) -> void:
	change_direction()
	
	if _death:
		cmd_list.clear()
		if !animation_player.is_playing():
			sprite.visible = false
			global_position = Vector2(0,0)
		return
	
	if len(cmd_list)>0:
		var command_status:Command.Status = cmd_list.front().execute(self)
		#if command_status == Command.Status.ACTIVE:
		if Command.Status.DONE == command_status:
			cmd_list.pop_front()
	else:
		_manage_animation()
	

func take_damage(damage:float) -> void:
	health -= damage

	if 0 >= health:
		_death = true
		velocity = Vector2.ZERO
		animation_player.play("death")


func change_direction() -> void:
	direction = (player.global_position - self.global_position).normalized()
	direction = sign(direction)
	if direction.x == 1:
		sprite.flip_h = true
		hit_box_collision_shape.position = Vector2(26.5, 9.5)
	else:
		sprite.flip_h = false
		hit_box_collision_shape.position = Vector2(-6.5, 9.5)


func _manage_animation() -> void:
	if attacking:
		animation_player.play("attack")	
	else:
		animation_player.play("idle")


func boss_fight_start() -> void:
	boss_slime_fight_start = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
	if anim_name == "attack":
		attacking = false


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body == player:
		attacking = true
		
