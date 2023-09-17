extends Node
class_name PlayerBase


var owned_cards: Array
var owned_money: int = 3:
	set(new_money_amount):
		owned_money = clamp(new_money_amount, 0, 1000)
		#Signals.emit_signal("update_gold")
	get:
		return owned_money
var player_id: int = 0:
	set(new_id):
		player_id = new_id
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func increase_owned_money(increase_amount: int) -> void:
	owned_money += clamp(increase_amount, 0, 1000)
	
	
func decrease_owned_money(decrease_amount: int) -> void:
	owned_money -= clamp(decrease_amount, -1000, 0)
