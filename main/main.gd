extends Node

##DEPENDENCIES##
@onready var player_scene: PackedScene = preload("res://player/player.tscn")

##NODES##
@onready var main_menu_layer: CanvasLayer = $MainMenuLayer
@onready var shop_container = $ShopDisplayLayer/ShopContainer


var player_count: int = 2:
	set(new_player_count):
		player_count = clamp(new_player_count, 2, 4)
		print("new player count: ", player_count)
		initialize_game()


func _ready():
	pass # Replace with function body.

################################################################################
##GAMESTART##


func initialize_game() -> void:
	main_menu_layer.hide()
	
	instance_players(player_count)
	instance_all_cards()

func instance_players(player_count: int) -> void:
	for n in player_count:
		var new_player: PlayerBase = player_scene.instantiate()
		new_player.add_to_group("player")
		add_child(new_player)
		new_player.set("player_id", n)


func instance_all_cards() -> void:
	load_shop()


func load_shop() -> void:
	shop_container.load_shop()
################################################################################
##MainMenu##


func _on_player_count_button_item_selected(index: int) -> void:
	if index >= 0:
		set("player_count", index + 2)
	
