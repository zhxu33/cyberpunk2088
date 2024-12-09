class_name Boss
extends Enemy 

var boss_slime_fight_start: bool

func _ready():
	max_health = 200 + Stats.level * 100
	health = 200 + Stats.level * 100
	coin_reward = 200 + Stats.level * 100
	super()

func _physics_process(delta: float) -> void:
	if !boss_slime_fight_start:
		return
	
	

func boss_fight_start() -> void:
	boss_slime_fight_start = true
