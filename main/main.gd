extends Node

##DEPENDENCIES##
@onready var player_scene: PackedScene = preload("res://player/player.tscn")
@onready var starting_cards: Array[PackedScene] = [
	preload("res://card_scenes/wheat_field.tscn"),
	preload("res://card_scenes/farm.tscn")
]
##NODES##
@onready var main_menu_layer: CanvasLayer = $MainMenuLayer
@onready var shop_container: MarginContainer = $ShopDisplayLayer/ShopContainer
@onready var turn_process_layer:CanvasLayer = $TurnProcessLayer



var player_count: int = 2:
	set(new_player_count):
		player_count = clamp(new_player_count, 2, 4)
		initialize_game()
var players: Array


func _ready():
	GameManager.set("game_board", self)

################################################################################
##GAMESTART##


func initialize_game() -> void:
	main_menu_layer.hide()
	
	instance_players(player_count)
	players.append_array(get_tree().get_nodes_in_group("player"))
	Events.emit_signal("players_registered", players)
	
	instance_all_cards()
	start_game()


func instance_players(number_of_players: int) -> void:
	for n in number_of_players:
		var new_player: PlayerBase = player_scene.instantiate()
		new_player.add_to_group("player")
		add_child(new_player)
		new_player.set("player_id", n)


func instance_all_cards() -> void:
	load_shop()
	add_starting_cards_to_players()


func load_shop() -> void:
	shop_container.load_shop()


func add_starting_cards_to_players() -> void:
	for player in players:
		for card in starting_cards:
			instance_card_on_player(card, player)


func instance_card_on_player(card: PackedScene, player: PlayerBase) -> void:
	var new_card: CardBase = card.instantiate()
	player.add_card_to_player(new_card)
	player.add_child(new_card)
	
	
################################################################################
##MainMenu##


func _on_player_count_button_item_selected(index: int) -> void:
	if index >= 0:
		set("player_count", index + 2)


################################################################################
##GAMELOOP FUNCTIONS##
func start_game() -> void:
	turn_process_layer.show()


func change_turn_to_next_player(current_player: PlayerBase) -> PlayerBase:
	if current_player == null:
		var new_current_player: PlayerBase = players[0]
		return new_current_player
	else:
		var player_index: int = players.find(current_player)
		var new_player_index: int = player_index + 1
		if new_player_index < players.size():
			var new_current_player: PlayerBase = players[new_player_index]
			return new_current_player
		else:
			var new_current_player: PlayerBase = players[0]
			return new_current_player


func throw_one_dice() -> int:
	var dice1: int = randi_range(0, 6)
	#optical things
	return dice1


func throw_two_dice() -> int:
	var dice1: int = randi_range(0, 6)
	var dice2: int = randi_range(0, 6)
	#Optical things
	return dice1 + dice2

