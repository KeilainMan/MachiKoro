extends Node
class_name GAMEMANAGER


var game_board: Node:
	set(new_board):
		game_board = new_board

var dice_throw_counter: int = 0
var dice_throw_counter_max: int = 1:
	set(new_counter):
		dice_throw_counter_max = new_counter
var current_dice_result: int = 0


var players: Array[PlayerBase]:
	set(new_players):
		players = new_players
var current_player: PlayerBase:
	set(new_player):
		current_player = new_player
		Events.emit_signal("new_current_player", current_player)
		Events.emit_signal("new_turn_starts")
	get:
		return current_player 






# Called when the node enters the scene tree for the first time.
func _ready():
	Events.throw_one_dice.connect(_on_throw_one_dice.bind())
	Events.throw_two_dice.connect(_on_throw_two_dice.bind())
	Events.turn_finished.connect(_on_turn_finished.bind())
	Events.send_dice_throw_result.connect(_on_dice_throw_result_send.bind())
	Events.card_wants_to_be_bought.connect(_on_card_wants_to_be_bought.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


####################################################################################################
## 1ST PHASE: DICE ROLL PHASE ##

func _on_throw_one_dice() -> void:
	game_board.throw_one_dice()
	set("dice_throw_counter_max", 1)
	Events.emit_signal("dice_throw_succeced")


func _on_throw_two_dice() -> void:
	game_board.throw_two_dice()
	set("dice_throw_counter_max", 2)
	Events.emit_signal("dice_throw_succeced")


func _on_dice_throw_result_send(dice_eyes: int) -> void:
	dice_throw_counter += 1
	current_dice_result += dice_eyes
	print("Dice thrown, eyes: ", dice_eyes, " dice throw counter: ", dice_throw_counter, " current_dice_result: ", current_dice_result)
	if dice_throw_counter == dice_throw_counter_max:
		proceed_after_dice_throw(current_dice_result)
	else:
		return


func clear_dice_throw() -> void:
	current_dice_result = 0
	dice_throw_counter = 0


####################################################################################################
## 2ND PHASE: AFTER DICE ROLL PHASE ##

func proceed_after_dice_throw(dice_eyes: int) -> void:
	proceed_card_income(dice_eyes)


func proceed_card_income(dice_eyes: int) -> void:
	for player_index in players.size():
		#presevers turn order
		player_index += players.find(current_player)
		if player_index > players.size():
			Helper.reset_iterator(player_index, players.size())
		#sets function player
		var player: PlayerBase = players[player_index]
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
		
	clear_dice_throw()

func proceed_income_category_enemys(dice_eyes: int, cards: Array[CardBase], player: PlayerBase) -> void:
	if !player == current_player:
		for card in cards:
			if card.card_income_numbers.has(dice_eyes):
				current_player.decrease_owned_money(card.income_amount)
				player.increase_owned_money(card.income_amount)
	else:
		return


func proceed_income_category_all(dice_eyes: int, cards: Array[CardBase], player: PlayerBase) -> void:
	for card in cards:
		if card.card_income_numbers.has(dice_eyes):
			player.increase_owned_money(card.income_amount)


func proceed_income_category_personal(dice_eyes: int, cards: Array[CardBase], player: PlayerBase) -> void:
	if player == current_player:
		for card in cards:
			if card.card_income_numbers.has(dice_eyes):
				player.increase_owned_money(card.income_amount)
	else:
		return

####################################################################################################
## BUYING CARDS ##

func _on_card_wants_to_be_bought(card: CardBase) -> void:
	if card.card_cost <= current_player.owned_money:
		process_transaction(card.card_cost)
		transfer_card_ownership(card, current_player)

func process_transaction(card_cost: int) -> void:
	current_player.decrease_owned_money(card_cost)


func transfer_card_ownership(card: CardBase, current_player: PlayerBase) -> void:
	current_player.add_card_to_player(card)
	card.card_ownership = current_player
	Events.emit_signal("card_was_bought", card)
	

####################################################################################################
## END PHASE: TURN FINISH ##

func _on_turn_finished() -> void:
	game_board.change_turn_to_next_player(current_player)
