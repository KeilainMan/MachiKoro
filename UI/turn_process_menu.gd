extends HBoxContainer

##NODES
@onready var one_dice_roll_button: TextureButton = $OneDiceRollButton
@onready var two_dice_roll_button: TextureButton = $TwoDiceRollButton
@onready var end_turn_burron: TextureButton = $EndTurnBurron
@onready var shop_button: TextureButton = $ShopButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.new_current_player.connect(_on_new_current_player.bind())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_current_player(new_player: PlayerBase) -> void:
	print("Now its ", new_player, " turn.")
	update_layout_based_on_current_player(new_player)
	
	
func update_layout_based_on_current_player(player: PlayerBase) -> void:
	var has_main_station: bool = player.get("bought_main_station")
	if has_main_station: 
		two_dice_roll_button.show()




func _on_one_dice_roll_button_pressed() -> void:
	Events.emit_signal("throw_one_dice")
	disable_dice_buttons()


func _on_two_dice_roll_button_pressed() -> void:
	Events.emit_signal("throw_two_dice")
	disable_dice_buttons()


func disable_dice_buttons() -> void:
	one_dice_roll_button.disabled = true
	two_dice_roll_button.disabled = true
	one_dice_roll_button.modulate = Color(255,255,255,80)
	two_dice_roll_button.modulate = Color(255,255,255,80)
