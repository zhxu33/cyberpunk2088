class_name stats
extends Node

var coins:int = 90000
var level:int = 0
var health:int = 100
var max_health:int = 100

var upgrades = {"Maximum Health":0, "Movement Speed":0, "Jump Power":0, "Double Jump":0, 
	"Bullet Count":0, "Exploding Bullet":0, "Attack Speed":0, "Ricochet Bullet": 0,
	"Bullet Damage":0, "Critical Chance":0, "Bullet Penetrate":0, "Bullet Speed":0}

func reset():
	coins = 0
	level = 0
	health = 100
	max_health = 100
	upgrades = {"Maximum Health":0, "Movement Speed":0, "Jump Power":0, "Double Jump":0, 
		"Bullet Count":0, "Exploding Bullet":0, "Attack Speed":0, "Ricochet Bullet": 0,
		"Bullet Damage":0, "Critical Chance":0, "Bullet Penetrate":0, "Bullet Speed":0}
