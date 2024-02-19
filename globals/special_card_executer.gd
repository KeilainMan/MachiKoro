extends Node

#DEPENDENCIES
@onready var player_selection: PackedScene = preload("res://UI/player_selection_interface.tscn")



var players: Array[PlayerBase]:
	set(new_players):
		players = new_players
var current_player: PlayerBase:
	set(new_player):
		current_player = new_player
	get:
		return current_player 




func _ready():
	Events.new_current_player.connect(_on_new_current_player.bind())
	Events.players_registered.connect(_on_players_registered.bind())


####################################################################################################
## ORGANIZE PLAYERS ##

func _on_new_current_player(new_current_player: PlayerBase) -> void:
	set("current_player", new_current_player)


func _on_players_registered(plyrs: Array[PlayerBase]) -> void:
		set("players", plyrs)


####################################################################################################
## PLAY SPECIAL CARD ##

func play_special_card(card: CardBase) -> void:
	Events.emit_signal("random_message", str("SpecialCard" + "[color=#FF3A20]" + card.card_name + "[/color]" + "will be executed!"))
	var tags: Array[int] = card.get("logic_tags")
	var targets: Array[PlayerBase]
	
	for tag in tags:
		if tag == tags[0]:
			targets = await play_target_tag(tags[0])
		match tag:
			50: #CHOOSECARDS
				pass
			100: #SWAPCARDS
				pass
			150: #STEALINCOME
				steal_income(targets, current_player, card.card_income_amount)
			151: #EARNINCOME
				pass


####################################################################################################
## TARGET SELECTOR/ PREPARATION TAGS < 50 ##

func play_target_tag(tag: int):
	var target: Array[PlayerBase]
	match tag:
		0: #Playerselection
			target = await choose_a_player_as_target(current_player, players)
		2: #AllEnemys
			target = choose_all_enemys_as_target(current_player, players)
	
	return target


func choose_a_player_as_target(player: PlayerBase, players: Array[PlayerBase]) -> Array[PlayerBase]:
	var new_player_selection: Control = player_selection.instantiate()
	get_tree().get_root().get_node("Main").get_node("PlayerSelectionLayer").add_child(new_player_selection)
	var target: PlayerBase = await new_player_selection.start_player_selection(player, players)

	return [target]


func choose_all_enemys_as_target(player: PlayerBase, players: Array[PlayerBase]) -> Array[PlayerBase]:
	players.erase(player)
	
	return players


####################################################################################################
## EXECUTE FUNCTIONS ID > 50 ##


##150
func steal_income(targets: Array[PlayerBase], player: PlayerBase, amount: int) -> void:
	for target in targets:
		target.decrease_owned_money(amount)
		player.increase_owned_money(amount)


##151
func earn_income(player: PlayerBase, amount: int) -> void:
	player.increase_owned_money(amount)
		
