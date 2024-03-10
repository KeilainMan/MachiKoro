extends HBoxContainer



@export var pic: Texture
@onready var player_pic: NinePatchRect = $PlayerPic
@onready var shader_pic: NinePatchRect = $PlayerPic/ShaderPic

@export var player_id: int = 0 #set through the editor in the PlayerHUD scene



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_pic.texture = pic
	
	Events.new_current_player.connect(on_new_current_player.bind())


func on_new_current_player(player: PlayerBase) -> void:
	if player_id == player.player_id:
		shader_pic.material.set_shader_parameter("turn_bool", true)
		shader_pic.show()
	else:
		shader_pic.material.set_shader_parameter("turn_bool", false)
		shader_pic.hide()
