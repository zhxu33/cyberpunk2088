class_name BossEx1
extends Enemy

@export var SPEED: int = 100
@export var ACCELERATION: int = 50

var boss_slime_fight_start: bool = false
var direction: Vector2
var distance: Vector2
var _death:bool = false

@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var hurt_box_collision_shape: CollisionShape2D = $HurtBox/HurtBoxCollisionShape
@onready var weapon: CollisionShape2D = $HitBox/Weapon

func _ready() -> void:
	max_health = 200 + Stats.level * 100
	health = 200 + Stats.level * 100
	
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	
	jump_velocity = -600
	movement_speed = 400
	bind_boss_input_commands()
	facing = Facing.LEFT
	
	
	super()


func _process(_delta):
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
		animation_player.play("idle")


func take_damage(dmg:int) -> void:
	super(dmg)
	audio_player.stop()
	audio_player["parameters/switch_to_clip"] = "sadyell"
	audio_player.play()

	if 0 >= health:
		_death = true
		velocity = Vector2.ZERO
		audio_player.stop()
		audio_player["parameters/switch_to_clip"] = "yell3"
		audio_player.play()
		animation_player.play("death")


func command_callback(command_name:String) -> void:
	if "summon" == command_name:
		audio_player.stop()
		audio_player["parameters/switch_to_clip"] = "yell1"
		audio_player.play()
	if "jump" == command_name:
		audio_player.stop()
		audio_player["parameters/switch_to_clip"] = "blast"
		audio_player.play()


func bind_boss_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	idle = IdleCommand.new()


func change_direction() -> void:
	direction = (player.global_position  - self.global_position).normalized()
	direction = sign(direction)
	if direction.x == 1:
		# facing left
		sprite.flip_h = true
		collision_shape.position = Vector2(-58, 0)
		hurt_box_collision_shape.position = Vector2(-58, 0)
		weapon.position = Vector2(-12, 4)
	else:
		# facing right
		sprite.flip_h = false
		collision_shape.position = Vector2(0, 0)
		hurt_box_collision_shape.position = Vector2(0, 0)
		weapon.position = Vector2(-46, 4)
