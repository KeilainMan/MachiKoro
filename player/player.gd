extends Node
class_name PlayerBase


var owned_cards: Array[CardBase] = []:
	set(new_array):
		owned_cards = new_array
	get:
		return owned_cards.duplicate(true)
var owned_money: int = 50:
	set(new_money_amount):
		owned_money = clamp(new_money_amount, 0, 1000)
		#Signals.emit_signal("update_gold")
	get:
		return owned_money
var player_id: int = 0:
	set(new_id):
		player_id = new_id

##Monument Bools##
var bought_train_station: bool = true:
	set(value):
		bought_train_station = value
	get:
		return bought_train_station 
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
var bought_radio_station: bool = false:
	set(value):
		bought_radio_station = value
	get:
		return bought_radio_station   


func _ready():
	pass # Replace with function body.


func increase_owned_money(increase_amount: int) -> void:
	owned_money += clamp(increase_amount, 0, 1000)
	Events.emit_signal("player_money_increased", self, owned_money)
	
	
func decrease_owned_money(decrease_amount: int) -> void:
	owned_money -= clamp(decrease_amount, 0, 1000)
	Events.emit_signal("player_money_decreased", self, owned_money)


func add_card_to_player(new_card: CardBase) -> void:
	var arr: Array = get("owned_cards")
	print("Arr: ", arr)
	arr.append(new_card)
#	if owned_cards.is_empty():
#		owned_cards[0] = new_card
#	else:
#		owned_cards[owned_cards.size() +1] = new_card
	set("owned_cards", arr)
	#owned_cards.append_array(arr)
	print("owned cards: ", owned_cards)
	Events.emit_signal("player_card_added", self, new_card.card_name)


func remove_card_from_player(target_card: CardBase) -> void:
	owned_cards.erase(target_card)
	Events.emit_signal("player_card_removed", self, target_card.card_name)
