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

func play_special_card(tags: Array[int]) -> void:
	var target =  await play_target_tag(tags[0])
	print("Target: ", target)




func play_target_tag(tag: int):
	var target
	match tag:
		0: #Playerselection
			target = await choose_a_player_as_target(current_player, players)
		1: #AllEnemys
			pass
	
	return target

func choose_a_player_as_target(player: PlayerBase, players: Array[PlayerBase]) -> PlayerBase:
	var new_player_selection: Control = player_selection.instantiate()
	get_tree().get_root().get_node("Main").get_node("PlayerSelectionLayer").add_child(new_player_selection)
	var target: PlayerBase = await new_player_selection.start_player_selection(player, players)

	return target
