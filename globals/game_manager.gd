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
var card_buy_token: int = 1:
	set(amount):
		card_buy_token = amount

var repeat_player_turn: bool = false

var players: Array[PlayerBase]:
	set(new_players):
		print(new_players)
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
	Events.players_registered.connect(_on_players_registered.bind())
	Events.throw_one_dice.connect(_on_throw_one_dice.bind())
	Events.throw_two_dice.connect(_on_throw_two_dice.bind())
	Events.turn_finished.connect(_on_turn_finished.bind())
	Events.send_dice_throw_result.connect(_on_dice_throw_result_send.bind())
	Events.card_wants_to_be_bought.connect(_on_card_wants_to_be_bought.bind())

####################################################################################################
## ORAGNIZE PLAYERS ##

func _on_players_registered(plyrs: Array[PlayerBase]) -> void:
	set("players", plyrs)

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
	if dice_throw_counter_max == 2 and current_player.get("bought_amusement_park"):
		if current_dice_result == dice_eyes:
			#Events.emit_signal("amusement_park_triggered", current_player)
			repeat_player_turn = true
	current_dice_result += dice_eyes
	Events.emit_signal("random_message", str("New dice throw result: " + str(current_dice_result)))
	print("COUNTER: ", dice_throw_counter, " MAX: ", dice_throw_counter_max, " RESULT: ", current_dice_result)
	if dice_throw_counter == dice_throw_counter_max:
		print("PROCEED")
		proceed_after_dice_throw(current_dice_result)
	else:
		return


func clear_dice_throw() -> void:
	current_dice_result = 0
	dice_throw_counter = 0


####################################################################################################
## 2ND PHASE: AFTER DICE ROLL PHASE ##

func proceed_after_dice_throw(dice_eyes: int) -> void:
	print("Dice eye thrown: ", dice_eyes)
	if dice_eyes == 6:
		play_special_cards(current_player)
	else:
		proceed_card_income(dice_eyes)
		
	clear_dice_throw()

func proceed_card_income(dice_eyes: int) -> void:
	for player_index in players.size():
		#presevers turn order
		player_index += players.find(current_player)
		if player_index >= players.size():
			player_index = Helper.reset_iterator(player_index, players.size())
		#sets function player
		var player: PlayerBase = players[player_index]
		#sort cards of a player after categories
		var cards: Array[CardBase] = player.get("owned_cards")
		var enemy_cards: Array[CardBase]
		var player_cards: Array[CardBase]
		var all_cards: Array[CardBase]
		for card in cards:
			var category: String = card.get("card_income_catergory")
			match category:
				"Player": #Player
					player_cards.append(card)
				"All": #All
					all_cards.append(card)
				"Enemys": #Enemys
					enemy_cards.append(card)
		var player_has_mall: bool = player.get("bought_mall")
		if !player == current_player:
			proceed_income_category_enemys(dice_eyes, enemy_cards, player, player_has_mall)
		proceed_income_category_all(dice_eyes, all_cards, player, player_has_mall)
		if player == current_player:
			proceed_income_category_personal(dice_eyes, player_cards, player, player_has_mall)
		
	

func proceed_income_category_enemys(dice_eyes: int, cards: Array[CardBase], player: PlayerBase, player_has_mall: bool) -> void:
	for card in cards:
		print("card: ", card, "player: ", player)
		if card.card_income_numbers.has(dice_eyes):
			if player_has_mall and card.card_tags.has(3) or card.card_tags.has(4): #CLOTHING and COFFECUP
				current_player.decrease_owned_money(card.card_income_amount + 1)
				player.increase_owned_money(card.card_income_amount + 1)
			else:
				current_player.decrease_owned_money(card.card_income_amount)
				player.increase_owned_money(card.card_income_amount)


func proceed_income_category_all(dice_eyes: int, cards: Array[CardBase], player: PlayerBase, player_has_mall: bool) -> void:
	for card in cards:
		if card.card_income_numbers.has(dice_eyes):
			if player_has_mall and card.card_tags.has(3) or card.card_tags.has(4): #CLOTHING and COFFECUP
				player.increase_owned_money(card.card_income_amount + 1)
			else:
				player.increase_owned_money(card.card_income_amount)


func proceed_income_category_personal(dice_eyes: int, cards: Array[CardBase], player: PlayerBase, player_has_mall: bool) -> void:
		for card in cards:
			if card.card_income_numbers.has(dice_eyes):
				print("player has mall: ", player_has_mall, " card_tags: ", card.card_tags)
				if player_has_mall and card.card_tags.has(3) or card.card_tags.has(4): #CLOTHING and COFFECUP
					player.increase_owned_money(card.card_income_amount + 1)
				else:
					player.increase_owned_money(card.card_income_amount)


###################################
##SPECIAL CARDS##


func play_special_cards(player: PlayerBase) -> void:
	var cards: Array[CardBase] = player.get("owned_cards")
	var special_cards: Array[CardBase]
	for card in cards:
		if card.card_type == "SpecialCard":
			special_cards.append(card)
	
	for card in special_cards:
		print("Play card: ", card.card_name)
		SpecialCardExecuter.play_special_card(card)

	
	


####################################################################################################
## BUYING CARDS ##

func _on_card_wants_to_be_bought(card: CardBase) -> void:
	if card.card_cost <= current_player.owned_money and card_buy_token > 0:
		if card.card_type == "MonumentCard" or card.card_type == "SpecialCard":
			if player_has_special_or_monument_card(card, current_player):
				return
			else:
				if card.card_type == "MonumentCard":
					activate_momument_on_player(card.card_name, current_player)
		process_transaction(card.card_cost)
		transfer_card_ownership(card, current_player)
		#card_buy_token -= 1


func player_has_special_or_monument_card(card: CardBase, player: PlayerBase) -> bool:
	var card_name: String = card.card_name
	var player_cards: Array = player.get("owned_cards")
	for player_card in player_cards:
		if player_card.card_name == card_name:
			Events.emit_signal("random_message", str("[color=#74A4BC]" + str(player.name) + "[/color]", " already owns the card ", "[color=#FF3A20]" + card_name + "[/color]"))
			return true
	return false


func activate_momument_on_player(card_name: String, player: PlayerBase) -> void:
	if card_name == "mall":
		player.set("bought_mall", true)
	elif card_name == "train_station":
		player.set("bought_train_station", true)
	elif card_name == "amusement_park":
		player.set("bought_amusement_park", true)
	elif card_name == "radio_station":
		player.set("bought_radio_station", true)


func process_transaction(card_cost: int) -> void:
	current_player.decrease_owned_money(card_cost)


func transfer_card_ownership(card: CardBase, current_player: PlayerBase) -> void:
	current_player.add_card_to_player(card)
	card.card_ownership = current_player
	Events.emit_signal("card_was_bought", card)


####################################################################################################
## END PHASE: TURN FINISH ##

func _on_turn_finished() -> void:
	set("card_buy_token", 1)
	if repeat_player_turn:
		set("current_player", current_player)
		repeat_player_turn = false
		#Events.emit_signal("new_turn_starts")
		return
	game_board.change_turn_to_next_player(current_player)

