extends TextureButton
class_name ButtonBase




# Called when the node enters the scene tree for the first time.
func _init():
	modulate = Color.BLACK
	Events.disable_buttons.connect(_on_disable_button.bind())
	Events.enable_buttons.connect(_on_enable_button.bind())


func _on_disable_button() -> void:
	disabled = true
	modulate = Color.GRAY


func _on_enable_button() -> void:
	disabled = false
	modulate = Color.BLACK
