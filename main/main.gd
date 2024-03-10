extends Node

##DEPENDENCIES##
@onready var player_scene: PackedScene = preload("res://player/player.tscn")
@onready var starting_cards: Array[PackedScene] = [
	preload("res://card_scenes/wheat_field.tscn"),
	preload("res://card_scenes/farm.tscn")
]
@onready var dice_throw: PackedScene = preload("res://animations/dice_throw.tscn")
@onready var end_game_screen: PackedScene = preload("res://main/end_game_screen.tscn")

##NODES##
@onready var main_menu_layer: CanvasLayer = $MainMenuLayer
@onready var shop_container: MarginContainer = $ShopDisplayLayer/ShopContainer
@onready var turn_process_layer: CanvasLayer = $TurnProcessLayer


var player_count: int = 2:
	set(new_player_count):
		player_count = clamp(new_player_count, 2, 4)
		initialize_game()
var players: Array[PlayerBase]


var current_gamestate: int = game_states.IDLE:
	set(new_state):
		current_gamestate = new_state
enum game_states {
	IDLE,
	DICETHROWPHASE,
	INCOMEPHASE,
	MAINPHASE
}



func _ready():
	Events.game_finished.connect(_on_game_finished.bind())
	GameManager.set("game_board", self)

################################################################################
##GAMESTART##


func initialize_game() -> void:
	main_menu_layer.hide()
	
	instance_players(player_count)
	#players.append_array(get_tree().get_nodes_in_group("player"))
	#GameManager.set("players", players)
	Events.emit_signal("players_registered", players)
	
	instance_all_cards()
	start_game()


func instance_players(number_of_players: int) -> void:
	for n in number_of_players:
		var new_player: PlayerBase = player_scene.instantiate()
		new_player.add_to_group("player")
		add_child(new_player)
		players.append(new_player)
		new_player.set("player_id", n + 1)
		new_player.name = "Player" + str(n + 1)


func instance_all_cards() -> void:
	load_shop(player_count)
	add_starting_cards_to_players()


func load_shop(count: int) -> void:
	shop_container.load_shop(count)


func add_starting_cards_to_players() -> void:
	for player in players:
		for card in starting_cards:
			instance_card_on_player(card, player)


func instance_card_on_player(card: PackedScene, player: PlayerBase) -> void:
	var new_card: CardBase = card.instantiate()
	self.add_child(new_card)
	GameManager.transfer_card_ownership(new_card, player)
	
	
################################################################################
##MainMenu##


func _on_player_count_button_item_selected(index: int) -> void:
	if index >= 0:
		set("player_count", index + 2)


################################################################################
##GAMELOOP FUNCTIONS##

func start_game() -> void:
	turn_process_layer.show()
	change_turn_to_next_player(null)


func change_turn_to_next_player(current_player: PlayerBase) -> void:
	if current_player == null:
		var new_current_player: PlayerBase = players[0]
		#Events.emit_signal("new_current_player", new_current_player)
		GameManager.set("current_player", new_current_player)
	else:
		var player_index: int = players.find(current_player)
		var new_player_index: int = player_index + 1
		if new_player_index == players.size():
			new_player_index = Helper.reset_iterator(new_player_index, players.size())
		var new_current_player: PlayerBase = players[new_player_index]
		#Events.emit_signal("new_current_player", new_current_player)
		GameManager.set("current_player", new_current_player)


func throw_one_dice() -> void:
	var viewport_size: Vector2 = get_viewport().get_size()
	
	var new_dice: Sprite2D = dice_throw.instantiate()
	new_dice.position = viewport_size/2
	add_child(new_dice)
	
	set("current_gamestate", game_states.DICETHROWPHASE)


func throw_two_dice() -> void:
	var viewport_size: Vector2 = get_viewport().get_size()
	
	var new_dice1: Sprite2D = dice_throw.instantiate()
	new_dice1.position = viewport_size/2 - Vector2(200,0)
	add_child(new_dice1)
	
	var new_dice2: Sprite2D = dice_throw.instantiate()
	new_dice2.position = viewport_size/2 - Vector2(-200,0)
	add_child(new_dice2)
	
	set("current_gamestate", game_states.DICETHROWPHASE)


################################################################################
##END GAME##

func _on_game_finished(player: PlayerBase) -> void:
	for child in get_children():
		print(child, child is CanvasLayer)
		if child is CanvasLayer:
			child.visible = false
	var new_screen: MarginContainer = end_game_screen.instantiate()
	add_child(new_screen)
	new_screen.display_winner(player)


################################################################################
##INPUTS##

func _unhandled_input(event) -> void:
	match current_gamestate:
		game_states.IDLE:
			pass
		game_states.DICETHROWPHASE:
			if event.is_action_pressed("SKIP"):
				Events.emit_signal("skip_dicethrow")
