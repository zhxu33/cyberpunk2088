class_name AttackCommand
extends Command

const bullet_group = preload("res://scenes/attacks/bullet_group.tscn")

func execute(character: Character) -> Status:
	var new_bullet_group = bullet_group.instantiate()
	var direction = (character.get_global_mouse_position() - character.global_position).normalized()
	new_bullet_group.velo = direction * new_bullet_group.speed
	new_bullet_group.global_position = character.global_position
	character.get_parent().current_map.add_child(new_bullet_group)
	return Status.DONE
