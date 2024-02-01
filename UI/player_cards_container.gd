extends MarginContainer

##DEPENDENCIES##
@onready var card_stack: PackedScene = preload("res://shop/card_stack.tscn")

@onready var h_box_container = $VScrollBar/HBoxContainer
@onready var margin_container = $VScrollBar/HBoxContainer/MarginContainer


var viewport_size: Vector2 
var opened: bool = false



func _ready():
	viewport_size = get_viewport().size
	position = Vector2(13, viewport_size.y + size.y)
	Events.card_was_bought.connect(_on_card_was_bought.bind())
	Events.player_card_container_toggled.connect(_on_player_card_container_was_toggled.bind())
	Events.new_current_player.connect(_on_new_current_player.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_current_player(new_current_player: PlayerBase) -> void:
	update_display(new_current_player)


func update_display(current_player: PlayerBase) -> void:
	for cardstack in h_box_container.get_children():
		for card in cardstack.get_children():
			if card.card_ownership == current_player:
				card.visible = true
			else:
				card.visible = false


func _on_card_was_bought(card: CardBase) -> void:
	add_new_card(card)


func add_new_card(card: CardBase) -> void:
	if cardstack_exists(card.card_name):
		for cardstack in h_box_container.get_children():
			if cardstack.get("cardstack_name") == card.card_name:
				card.reparent(cardstack)
	else:
		var new_stack: VBoxContainer = instance_card_stack()
		card.reparent(new_stack)
		h_box_container.move_child(margin_container, h_box_container.get_child_count())
		


func cardstack_exists(card_name: String) -> bool:
	var card_stack_names: Array = []
	for cardstack in h_box_container.get_children():
		card_stack_names.append(cardstack.get("cardstack_name"))
	var index: int = card_stack_names.find(card_name)
	if index == -1:
		return false
	else:
		return true


func instance_card_stack() -> VBoxContainer:
	var new_card_stack: VBoxContainer = card_stack.instantiate()
	h_box_container.add_child(new_card_stack)
	return new_card_stack


func _on_player_card_container_was_toggled() -> void:
	var tween: Tween = create_tween()
	if opened:
		tween.tween_property(self, "position", Vector2(13, viewport_size.y + size.y), 0.3)
		opened = false
	else:
		tween.tween_property(self, "position", Vector2(13, viewport_size.y - size.y+50), 0.3)
		opened = true

