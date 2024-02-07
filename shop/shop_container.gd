extends MarginContainer

##DEPENDENCIES##
@onready var card_stack: PackedScene = preload("res://shop/card_stack.tscn")

##NODES##
@onready var grid_container = $VScrollBar/GridContainer

##
var viewport_size: Vector2
var open: bool = false

func _ready():
	viewport_size = get_viewport().size
	position = Vector2(viewport_size.x + size.x, 140)
	Events.toggle_shop.connect(_on_toggle_shop.bind())


####################################################################################################
##LOADING THE SHOP WITH ALL GAME CARDS##

func load_shop(player_count: int) -> void:
	var standard_cards: Array[Array] = StandardCardDeck.get("all_standard_cards")
	
	instance_cards_with_fixed_numbers_of(standard_cards[0])
	instance_cards_with_variable_numbers_of(standard_cards[1], player_count)


func instance_cards_with_fixed_numbers_of(cards: Array) -> void:
	for card_info in cards:
		var new_card_stack: VBoxContainer = instance_card_stack()
		var card_count: int = card_info.get("card_count")
		var card_scene: PackedScene = card_info.get("card_path") 
		for n in card_count:
			instance_card_on_stack(card_scene, new_card_stack)


func instance_cards_with_variable_numbers_of(cards: Array, player_count: int) -> void:
	for card_info in cards:
		var new_card_stack: VBoxContainer = instance_card_stack()
		var card_scene: PackedScene = card_info.get("card_path") 
		for n in player_count:
			instance_card_on_stack(card_scene, new_card_stack)


func instance_card_stack() -> VBoxContainer:
	var new_card_stack: VBoxContainer = card_stack.instantiate()
	grid_container.add_child(new_card_stack)
	return new_card_stack


func instance_card_on_stack(card_scene: PackedScene, new_card_stack: VBoxContainer) -> void:
	var new_card: CardBase = card_scene.instantiate()
	new_card_stack.add_child(new_card)


####################################################################################################
##VISUALS##

func _on_toggle_shop() -> void:
	if open:
		disappear()
	else:
		appear()


func appear() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(viewport_size.x - size.x, 140), 0.3)
	open = true


func disappear() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(viewport_size.x + size.x, 140), 0.3)
	open = false
