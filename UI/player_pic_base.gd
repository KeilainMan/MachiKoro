extends VBoxContainer
class_name PlayerPicBase

var hovered: bool = false:
	set(new_state):
		hovered = new_state
	get:
		return hovered
var id: int = 10:
	set(new_id):
		id = new_id


signal I_was_clicked


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered.bind())
	mouse_exited.connect(_on_mouse_exited.bind())


func _on_mouse_entered() -> void:
	print("hovered")
	set("hovered", true)


func _on_mouse_exited() -> void:
	set("hovered", false)


func _input(event: InputEvent) -> void:
	if hovered and event.is_action_pressed("left_mouse_click"):
		emit_signal("I_was_clicked", id)
