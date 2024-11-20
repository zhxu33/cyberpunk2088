extends Node2D

#connect player
@onready var punk_player: Player = $"../Punk_Player"
# Start Screen
@onready var start_screen:Control = $Canvas/StartScreen
@onready var start_button:Button = $Canvas/StartScreen/Button
# Health
@onready var health:Control = $Canvas/Health
@onready var health_bar:ProgressBar = $Canvas/Health/ProgressBar
@onready var health_label:Label = $Canvas/Health/Label
# Coins
@onready var coins:Control = $Canvas/Coins
@onready var coins_label:Label = $Canvas/Coins/Label
# Level
@onready var level:Control = $Canvas/Level
@onready var level_label:Label = $Canvas/Level/Label
# Dialogue
@onready var dialogue:Control = $Canvas/Dialogue
@onready var confirm:Button = $Canvas/Dialogue/Confirm
@onready var cancel:Button = $Canvas/Dialogue/Cancel
# Shop
@onready var shop:Control = $Canvas/Shop
@onready var shop_close:Control = $Canvas/Shop/Close
@onready var shop_container:GridContainer = $Canvas/Shop/ScrollContainer/GridContainer
@onready var upgrade_item:Control = $Canvas/Shop/UpgradeItem

var current_player:Player

func _ready() -> void:
	# set current player
	current_player = punk_player
	# start screen
	start_screen.visible = true
	start_button.pressed.connect(_on_start_screen)
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
		

func _process(_delta: float) -> void:
	# update player status
	health_bar.value = Stats.health
	health_bar.max_value = Stats.max_health
	health_label.text = str(Stats.health) + "/" + str(Stats.max_health)
	coins_label.text = str(Stats.coins)
	level_label.text = "Level: " + str(Stats.level)


func _on_start_screen():
	start_screen.visible = false
	health.visible = true 
	coins.visible = true
	level.visible = true
	current_player.bind_player_input_commands()
	


func _on_confirm_pressed():
	dialogue.visible = false
	shop.visible = true
	current_player.unbind_player_input_commands()


func _on_cancel_pressed():
	dialogue.visible = false
	
	
func _on_shop_close():
	shop.visible = false
	current_player.bind_player_input_commands()

func _on_upgrade(item):
	# purchase upgrade
	var cost = 100 + Stats.upgrades[item.name] * 100
	if (Stats.upgrades[item.name] >= 10 || cost > Stats.coins):
		return
	Stats.coins -= cost
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
