extends CanvasLayer



@onready var label_parent = $Panel/VBoxContainer

var max_child_count: int = 15

func _ready():
	Events.new_current_player.connect(on_new_current_player.bind())
	Events.send_dice_throw_result.connect(on_send_dice_throw_results.bind())
	Events.player_money_increased.connect(on_player_money_increased.bind())
	Events.player_money_decreased.connect(on_player_money_decreased.bind())
	Events.player_card_added.connect(on_player_card_added.bind())
	Events.player_card_removed.connect(on_player_card_removed.bind())


func on_new_current_player(new_player: PlayerBase) -> void:
	var new_label: Label = Label.new()
	new_label.text = "New current player: " + str(new_player)
	label_parent.add_child(new_label)
	limit_max_labels()


func on_send_dice_throw_results(dice_result: int) -> void:
	var new_label: Label = Label.new()
	new_label.text = "New dice throw result: " + str(dice_result)
	label_parent.add_child(new_label)
	limit_max_labels()


func on_player_money_increased(player: PlayerBase, new_money: int) -> void:
	var new_label: Label = Label.new()
	new_label.text = str(player) + " money increased to " + str(new_money)
	label_parent.add_child(new_label)
	limit_max_labels()


func on_player_money_decreased(player: PlayerBase, new_money: int) -> void:
	var new_label: Label = Label.new()
	new_label.text = str(player) + " money decreased to " + str(new_money)
	label_parent.add_child(new_label)
	limit_max_labels()


func on_player_card_added(player: PlayerBase, cardname: String) -> void:
	var new_label: Label = Label.new()
	new_label.text = str(player) + " card added " + cardname
	label_parent.add_child(new_label)
	limit_max_labels()


func on_player_card_removed(player: PlayerBase, cardname: String) -> void:
	var new_label: Label = Label.new()
	new_label.text = str(player) + " card removed " + cardname
	label_parent.add_child(new_label)
	limit_max_labels()


func limit_max_labels() -> void:
	if label_parent.get_child_count() > max_child_count:
		label_parent.get_child(0).queue_free()
