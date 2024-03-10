extends HBoxContainer

##DEPENDENCIES##
@onready var monument_card: Texture = preload("res://assets/all_cards/amusement_park.png")

##NODES##
@onready var player_pic: NinePatchRect = $PlayerPic
@onready var shader_pic: NinePatchRect = $PlayerPic/ShaderPic
@onready var money_label: Label = $VBoxContainer/MoneyRect/MoneyLabel
@onready var grid_container: GridContainer = $VBoxContainer/NinePatchRect/MarginContainer/GridContainer

##LOCALS##
@export var pic: Texture
@export var player_id: int = 0 #set through the editor in the PlayerHUD scene

var monument_counter: int = 0


func _ready() -> void:
	player_pic.texture = pic
	
	Events.new_current_player.connect(on_new_current_player.bind())
	Events.player_money_increased.connect(on_player_money_changed.bind())
	Events.player_money_decreased.connect(on_player_money_changed.bind())
	Events.monument_bought.connect(on_player_monument_bought.bind())


####################################################################################################
## GENERAL USAGE ##

func match_player_id(id: int) -> bool:
	if player_id == id:
		return true
	else: 
		return false


####################################################################################################
## ADJUSTMENT FUNCTIONS ##

func on_new_current_player(player: PlayerBase) -> void:
	if match_player_id(player.player_id):
		shader_pic.material.set_shader_parameter("turn_bool", true)
		shader_pic.show()
	else:
		shader_pic.material.set_shader_parameter("turn_bool", false)
		shader_pic.hide()


func on_player_money_changed(player: PlayerBase, money_change: int) -> void:
	if match_player_id(player.player_id):
		money_label.text = str(player.get("owned_money"))


func on_player_monument_bought(player: PlayerBase) -> void:
	if match_player_id(player.player_id):
		monument_counter += 1
		for n in monument_counter:
			grid_container.get_child(n).texture = monument_card
		
