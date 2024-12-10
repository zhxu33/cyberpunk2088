class_name Explosion
extends Node2D

@onready var hitbox: Area2D = $Hitbox
@onready var particle: CPUParticles2D = $Particle

var enemies_hit = {}

func _ready() -> void:
	var explosion_scale = 2 + 0.5 * Stats.upgrades["Exploding Bullet"]
	hitbox.scale = Vector2(explosion_scale, explosion_scale)
	particle.initial_velocity_max = 75 + 10 * Stats.upgrades["Exploding Bullet"]
	particle.amount = 10 + 1 * Stats.upgrades["Exploding Bullet"]
	particle.emitting = true
	await get_tree().create_timer(0.15).timeout
	hitbox.monitoring = true
	await get_tree().create_timer(0.35).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var overlaps = hitbox.get_overlapping_areas()
	for hurtbox in overlaps:
		if hurtbox.get_owner() is Enemy and not enemies_hit.has(hurtbox):
			enemies_hit[hurtbox] = "hit"
			var damage = 10 + 5 * Stats.upgrades["Exploding Bullet"]
			hurtbox.get_owner().take_damage(damage)
