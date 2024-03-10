extends HBoxContainer



@export var pic: Texture
@onready var player_pic: NinePatchRect = $PlayerPic



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_pic.texture = pic


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
