extends MarginContainer

##DEPENDENCIES##
@onready var card_stack: PackedScene = preload("res://shop/card_stack.tscn")

@onready var h_box_container = $ScrollContainer/HBoxContainer
@onready var margin_container = $ScrollContainer/HBoxContainer/MarginContainer

signal card_selected


func _ready():
	pass


func load_player_cards(cards: Array[CardBase]) -> CardBase:
	for card in cards:
		print("CardTyp: ", card.card_type)
		if card.card_type == "IncomeCard":
			var new_card: CardBase = card.duplicate(8)
			add_child(new_card)
			new_card.card_selected.connect(_on_card_selected.bind())
			new_card.set("current_mode", 2)
			new_card.set("original_card", card)
			add_new_card(new_card)
	
	var target_card: CardBase = await card_selected
	return target_card.get("original_card")


####################################################################################################
##BUILD INTERFACE##

func add_new_card(card: CardBase) -> void:
	print("CardStack Exists: ", cardstack_exists(card.card_name), " for Name: ", card.card_name)
	if cardstack_exists(card.card_name):
		for cardstack in h_box_container.get_children():
			if cardstack.get("cardstack_name") == card.card_name:
				card.reparent(cardstack)
	else:
		var new_stack: VBoxContainer = instance_card_stack()
		card.reparent(new_stack)
		h_box_container.move_child(margin_container, h_box_container.get_child_count())
	card.visible = true


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


####################################################################################################
## ##


func _on_card_selected(card: CardBase) -> void:
	emit_signal("card_selected", card)
	queue_free()
