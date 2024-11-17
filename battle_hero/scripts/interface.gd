extends Node2D

# Health
@onready var health_bar:ProgressBar = $CanvasLayer/Health/ProgressBar
@onready var health_label:Label = $CanvasLayer/Health/Label
# Coins
@onready var coins_label:Label = $CanvasLayer/Coins/Label
# Level
@onready var level_label:Label = $CanvasLayer/Level/Label
# Dialogue
@onready var dialogue:Control = $CanvasLayer/Dialogue
@onready var confirm:Button = $CanvasLayer/Dialogue/Confirm
@onready var cancel:Button = $CanvasLayer/Dialogue/Cancel
# Shop
@onready var shop:Control = $CanvasLayer/Shop
@onready var shop_close:Control = $CanvasLayer/Shop/Close
@onready var shop_container:GridContainer = $CanvasLayer/Shop/ScrollContainer/GridContainer
@onready var upgrade_item:Control = $CanvasLayer/Shop/UpgradeItem


func _ready() -> void:
	# player status
	health_bar.max_value = Stats.max_health
	health_bar.value = Stats.health
	health_label.text = str(Stats.health) + "/" + str(Stats.max_health)
	coins_label.text = str(Stats.coins)
	level_label.text = "Level: " + str(Stats.level)
	
	# dialogue
	confirm.pressed.connect(_on_confirm_pressed)
	cancel.pressed.connect(_on_cancel_pressed)
	
	# shop
	shop_close.pressed.connect(_on_shop_close)
	
	# initiate upgrades in shop
	for item in Stats.upgrades:
		var new_item = upgrade_item.duplicate()
		new_item.name = str(item)
		new_item.get_node("Cost").text = str(100)
		new_item.get_node("Label").text = str(item)
		new_item.visible = true
		shop_container.add_child(new_item)
		new_item.get_node("Button").pressed.connect(func(): _on_upgrade(new_item))
		

func _process(delta: float) -> void:
	# update player status
	health_bar.value = Stats.health
	health_label.text = str(Stats.health) + "/" + str(Stats.max_health)
	coins_label.text = str(Stats.coins)
	level_label.text = "Level: " + str(Stats.level)


func _on_confirm_pressed():
	dialogue.visible = false
	shop.visible = true


func _on_cancel_pressed():
	dialogue.visible = false
	
	
func _on_shop_close():
	shop.visible = false


func _on_upgrade(item):
	# purchase upgrade
	var cost = 100 + Stats.upgrades[item.name] * 100
	if (Stats.upgrades[item.name] >= 10 || cost > Stats.coins):
		return
	Stats.coins -= int(item.get_node("Cost").text)
	Stats.upgrades[item.name] += 1
	
	# update max health
	if (item.name == "Maximum Health"):
		Stats.health += 40
		Stats.max_health = 100 + Stats.upgrades["Maximum Health"]*40
		health_bar.max_value = Stats.max_health
	
	# cap max upgrade level at 10
	if (Stats.upgrades[item.name] >= 10):
		item.get_node("Cost").text = "Max"
	else:
		item.get_node("Cost").text = str(100+Stats.upgrades[item.name]*100)
