extends MarginContainer

## DEPENDENCIES ##
#@onready var main_scene: PackedScene = preload("res://main/main.tscn")

## NODES ##
@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func display_winner(player: PlayerBase) -> void:
	rich_text_label.text = "[center] [b] " + player.name + " Wins! [/b] [/center]"


func _on_quit_button_pressed() -> void:
	get_tree().quit()


#func _on_new_game_button_pressed() -> void:
#	get_tree().change_scene_to_packed(main_scene)
