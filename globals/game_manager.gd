extends Node
class_name GAMEMANAGER


var game_board: Node:
	set(new_board):
		game_board = new_board



var players: Array[PlayerBase]:
	set(new_players):
		players = new_players
var current_player: PlayerBase:
	set(new_player):
		current_player = new_player
		Events.emit_signal("new_current_player", current_player)
	get:
		return current_player 






# Called when the node enters the scene tree for the first time.
func _ready():
	Events.throw_one_dice.connect(_on_throw_one_dice.bind())
	Events.throw_two_dice.connect(_on_throw_two_dice.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


####################################################################################################
## 1ST PHASE: DICE ROLL PHASE ##

func _on_throw_one_dice() -> void:
	var dice_eyes: int = game_board.throw_one_dice()
	proceed_after_dice_throw(dice_eyes)


func _on_throw_two_dice() -> void:
	var dice_eyes: int = game_board.throw_two_dice()
	proceed_after_dice_throw(dice_eyes)


####################################################################################################
## 2ND PHASE: AFTER DICE ROLL PHASE ##

func proceed_after_dice_throw(dice_eyes: int) -> void:
	proceed_card_income(dice_eyes)


func proceed_card_income(dice_eyes: int) -> void:
	for player in players:
		#sort cards of a player after categories
		var cards: Array[CardBase] = player.get("owned_cards")
		var enemy_cards: Array[CardBase]
		var player_cards: Array[CardBase]
		var all_cards: Array[CardBase]
		for card in cards:
			var category: int = card.get("card_income_catergory")
			match category:
				0: #Player
					player_cards.append(card)
				1: #All
					all_cards.append(card)
				2: #Enemys
					enemy_cards.append(card)
		
		proceed_income_category_enemys(dice_eyes, enemy_cards, player)
		proceed_income_category_all(dice_eyes, all_cards, player)
		proceed_income_category_personal(dice_eyes, player_cards, player)


func proceed_income_category_enemys(dice_eyes: int, cards: Array[CardBase], player: PlayerBase) -> void:
	if !player == current_player:
		

func proceed_income_category_all(dice_eyes: int, cards: Array[CardBase]) -> void:
	pass

func proceed_income_category_personal(dice_eyes: int, cards: Array[CardBase]) -> void:
	pass
