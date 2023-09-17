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

var card_image_texture: Texture

##CARD IN GAME MODES##
enum card_modes {
	SHOP,
	PLAYEROWNED
}
var current_mode: int:
	set(new_mode):
		current_mode = new_mode
	get:
		return current_mode





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


################################################################################
##CLICK-AKTION##

func _on_action_button_pressed() -> void:
	match current_mode:
		card_modes.SHOP:
			#Signals.emit_signal("card_wants_to_be_bought")
			pass
		card_modes.PLAYEROWNED:
			pass
