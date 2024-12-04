class_name RangedAttackCommand
extends Command

const bullet_group = preload("res://scenes/attacks/bullet_group.tscn")

func execute(character: Character) -> Status:
	# Measure direction
	var spawner_position = character.projectile_spawner.global_position
	var direction = (character.get_global_mouse_position() - spawner_position).normalized()
	# Create bullet
	var new_bullet_group = bullet_group.instantiate()
	new_bullet_group.velo = direction * new_bullet_group.speed
	new_bullet_group.global_position = spawner_position
	character.get_parent().current_map.add_child(new_bullet_group)
	return Status.DONE
