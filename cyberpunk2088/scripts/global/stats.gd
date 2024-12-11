class_name stats
extends Node

var coins:int = 900000
var level:int = -1
var health:int = 100
var max_health:int = 100

var upgrades = {"Maximum Health":0, "Double Jump":0, "Movement Speed":0, "Jump Power":0, 
		"Bullet Count":0, "Ricochet Bullet": 0, "Bullet Penetrate":0, "Bullet Speed":0,
		"Exploding Attack":0, "Attack Damage":5, "Attack Speed": 0, "Critical Chance":0}

func reset():
	coins = 0
	level = -1
	health = 100
	max_health = 100
	for upg in upgrades:
		upgrades[upg] = 0
