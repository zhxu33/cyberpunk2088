class_name Boss
extends Enemy 


func _ready():
	max_health = 200 + Stats.level * 100
	health = 200 + Stats.level * 100
	coin_reward = 200 + Stats.level * 100
	super()
	
	