extends TextureButton

@onready var close_img: CompressedTexture2D = preload("res://assets/icons/close_player_card_container_512.png")
@onready var open_img: CompressedTexture2D = preload("res://assets/icons/open_player_card_container_512.png")

var viewport_size: Vector2
var pcc_opened: bool = false

func _ready():
	viewport_size = get_viewport().size
	position = Vector2(13, viewport_size.y - 65)


func _on_pressed() -> void:
	var tween: Tween = create_tween()
	if pcc_opened:
		texture_normal = open_img
		pcc_opened = false
		tween.tween_property(self, "position", Vector2(13, viewport_size.y - 65), 0.3)
	else:
		texture_normal = close_img
		pcc_opened = true
		tween.tween_property(self, "position", Vector2(13, 648), 0.3)
	Events.emit_signal("player_card_container_toggled")
