extends RigidBody2D

@export var coin_reward:int
@onready var hitbox:Area2D = $Hitbox 


func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.get_owner() is Player:
		Stats.coins += coin_reward
		queue_free()
	
		
# Called when the node enters the scen tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)
	var random_offset = Vector2(
		randf_range(-250, 250),  # Random x offset
		randf_range(-250, 250)   # Random y offset
	)
	linear_velocity = random_offset


func _physics_process(delta: float) -> void:
	$Icon.rotation_degrees += delta*10
	
