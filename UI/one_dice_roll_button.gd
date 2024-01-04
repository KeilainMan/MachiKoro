extends ButtonBase


var dice_throw_counter: int = 0
var dice_throw_counter_max: int = 1:
	set(new_max):
		dice_throw_counter_max = new_max


func _ready():
	Events.new_current_player.connect(_on_new_current_player.bind())
	Events.dice_throw_succeced.connect(_on_dice_throw_succeced.bind())
	Events.new_turn_starts.connect(_on_new_turn_starts.bind())


################################################################################
##TURN START FUNCTIONS, GET EXECUTED IN ORDER ##

func _on_new_turn_starts() -> void:
	reset_dice_throw_counter()
	_on_enable_button()


func _on_new_current_player(player: PlayerBase) -> void:
	if player.bought_radio_tower:
		set("dice_throw_counter_max", 2)


################################################################################
## ##

func reset_dice_throw_counter() -> void:
	dice_throw_counter = 0


func increase_dice_throw_counter() -> void:
	dice_throw_counter += 1
	if dice_throw_counter == dice_throw_counter_max:
		disabled = true
		modulate = Color.GRAY


func _on_dice_throw_succeced() -> void:
	increase_dice_throw_counter()


func _on_enable_button() -> void: #overrides BaseButton function
	if dice_throw_counter == dice_throw_counter_max:
		return
	else:
		super._on_enable_button()

