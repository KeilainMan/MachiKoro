extends Node
class_name PlayerBase


var owned_cards: Array[CardBase]:
	get:
		return owned_cards.duplicate()
var owned_money: int = 3:
	set(new_money_amount):
		owned_money = clamp(new_money_amount, 0, 1000)
		#Signals.emit_signal("update_gold")
	get:
		return owned_money
var player_id: int = 0:
	set(new_id):
		player_id = new_id

##Monument Bools##
var bought_main_station: bool = false:
	set(value):
		bought_main_station = value
	get:
		return bought_main_station 
var bought_amusement_park: bool = false:
	set(value):
		bought_amusement_park = value
	get:
		return bought_amusement_park
var bought_mall: bool = false:
	set(value):
		bought_mall = value
	get:
		return bought_mall  
var bought_radio_tower: bool = false:
	set(value):
		bought_radio_tower = value
	get:
		return bought_radio_tower   


func _ready():
	pass # Replace with function body.


func increase_owned_money(increase_amount: int) -> void:
	owned_money += clamp(increase_amount, 0, 1000)
	
	
func decrease_owned_money(decrease_amount: int) -> void:
	owned_money -= clamp(decrease_amount, -1000, 0)


func add_card_to_player(new_card: CardBase) -> void:
	owned_cards.append(new_card)


func remove_card_from_player(target_card: CardBase) -> void:
	owned_cards.erase(target_card)
