extends MarginContainer
class_name CardBase

##CARD RESOURCE##
@export var card_resource: CardBaseResource 

##NODES##
@onready var card_image = $CardImage


##CARD DATA##
var card_name: String
var card_type: String
var card_income_catergory: String
var card_income_numbers: Array[int]
var card_cost: int
var card_income_amount: int
var card_tags: Array
var logic_tags: Array

var card_image_texture: Texture
var card_ownership: PlayerBase:
	set(card_owner):
		card_ownership = card_owner
		if card_ownership != null:
			set("current_mode", card_modes.PLAYEROWNED)
	get:
		return card_ownership


##CARD IN GAME MODES##
enum card_modes {
	SHOP,
	PLAYEROWNED
}
var current_mode: int:
	set(new_mode):
		current_mode = new_mode
		if new_mode == card_modes.PLAYEROWNED:
			size_flags_vertical = 0
			size_flags_horizontal = 0
	get:
		return current_mode

##CARD TAGS THAT DETERMINE THAT CARDS BEHAVIOUR (ONLY SPECIALCARDS)##




################################################################################
##INITIALIZATION##

func _ready():
	assemble_card()


func assemble_card() -> void:
	set_card_data()
	card_image.texture = card_image_texture


func set_card_data() -> void:
	card_name = card_resource.card_name
	card_type = card_resource.card_type
	card_income_catergory = card_resource.card_income_catergory
	card_income_numbers = card_resource.card_income_numbers
	card_cost = card_resource.card_cost
	card_image_texture = card_resource.card_image
	card_income_amount = card_resource.income_amount
	card_tags = card_resource.card_tags
	logic_tags = card_resource.logic_tags
	set("card_ownership", card_resource.card_ownership)


################################################################################
##CLICK-AKTION##

func _on_action_button_pressed() -> void:
	
	match current_mode:
		card_modes.SHOP:
			Events.emit_signal("card_wants_to_be_bought", self)
		card_modes.PLAYEROWNED:
			pass

