extends MarginContainer

@onready var v_box_container: VBoxContainer = $VBoxContainer




func _ready() -> void:
	Events.players_registered.connect(on_players_registered.bind())


func on_players_registered(players: Array[PlayerBase]) -> void:
	var player_count: int = players.size()
	var small_player_huds: Array = v_box_container.get_children()
	for n in small_player_huds.size():
		if n <= (player_count - 1):
			small_player_huds[n].show()
		else:
			small_player_huds[n].hide()
