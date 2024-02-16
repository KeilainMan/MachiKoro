extends Control

@onready var player1_pic: PackedScene = preload("res://UI/player_1.tscn")
@onready var player2_pic: PackedScene = preload("res://UI/player_2.tscn")
@onready var player3_pic: PackedScene = preload("res://UI/player_3.tscn")
@onready var player4_pic: PackedScene = preload("res://UI/player_4.tscn")
@onready var player_pic_base_script: Script = preload("res://UI/player_pic_base.gd")
@onready var panel_parent: HBoxContainer = $CenterContainer/HBoxContainer

var player_pics: Array[PackedScene] = []


signal target_selected

func _ready():
	player_pics = [player1_pic, player2_pic, player3_pic, player4_pic]
	print("Playerselection instanced")


func start_player_selection(player: PlayerBase, players: Array[PlayerBase]) -> PlayerBase:
	var player_index: int = players.find(player)
	for n in players.size():
		if !n == player_index:
			
			var new_panel: VBoxContainer = player_pics[n].instantiate()
			panel_parent.add_child(new_panel)
			new_panel.set_script(player_pic_base_script)
			new_panel.set("id", n)
			new_panel.mouse_entered.connect(new_panel._on_mouse_entered.bind())
			new_panel.mouse_exited.connect(new_panel._on_mouse_exited.bind())
			new_panel.I_was_clicked.connect(_on_panel_clicked.bind())
			print(new_panel, " id ", n)
	
	var target_id: int = await target_selected
	return players[target_id]


func _on_panel_clicked(id: int) -> void:
	emit_signal("target_selected", id)
