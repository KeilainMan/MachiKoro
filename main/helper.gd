extends CanvasLayer

@onready var text_input_line = $Panel/VBoxContainer/TextInputLine
@onready var log_box_label = $Panel/VBoxContainer/LogBoxLabel

var all_commands: Array[String] = Commands.get("commands")


var max_child_count: int = 40

func _ready():
	Events.new_current_player.connect(on_new_current_player.bind())
	Events.send_dice_throw_result.connect(on_send_dice_throw_results.bind())
	Events.player_money_increased.connect(on_player_money_increased.bind())
	Events.player_money_decreased.connect(on_player_money_decreased.bind())
	Events.player_card_added.connect(on_player_card_added.bind())
	Events.player_card_removed.connect(on_player_card_removed.bind())
	Events.random_message.connect(on_random_message.bind())
	

####################################################################################################
## CONSOLE OUTPUT ##

func on_new_current_player(new_player: PlayerBase) -> void:
	instance_label("New current player: " + "[color=#74A4BC]" + str(new_player.name) + "[/color]")


func on_send_dice_throw_results(dice_result: int) -> void:
	instance_label("New dice throw result: " + str(dice_result))


func on_player_money_increased(player: PlayerBase, new_money: int) -> void:
	instance_label("[color=#74A4BC]" + str(player.name) + "[/color]" + " money increased to " + "[color=#C98CA7]" + str(new_money) + "[/color]")


func on_player_money_decreased(player: PlayerBase, new_money: int) -> void:
	instance_label("[color=#74A4BC]" + str(player.name) + "[/color]" + " money decreased to " + "[color=#C98CA7]" + str(new_money) + "[/color]")


func on_player_card_added(player: PlayerBase, cardname: String) -> void:
	instance_label("[color=#74A4BC]" + str(player.name) + "[/color]" + " card added " + "[color=#FF3A20]" + cardname + "[/color]")


func on_player_card_removed(player: PlayerBase, cardname: String) -> void:
	instance_label("[color=#74A4BC]" + str(player.name) + "[/color]" + " card removed " + cardname)


func on_no_command_entered() -> void:
	instance_label("Error, missing /")


func on_false_command_entered() -> void:
	instance_label("Error, command not found")


func on_random_message(text: String) -> void:
	instance_label(text)


func instance_label(text: String) -> void:
	log_box_label.text += "\n"
	log_box_label.text += text


####################################################################################################
## INPUT ##


func _input(event):
	if event.is_action_pressed("toggle_console"):
		if self.visible:
			self.hide()
		else:
			self.show()
	if event.is_action_pressed("text_input") and self.visible and !text_input_line.has_focus():
		text_input_line.grab_focus()


func _on_text_input_line_text_submitted(new_text: String) -> void:
	if new_text == "":
		return
	check_input_command(text_input_line.text)
	text_input_line.text = ""


####################################################################################################
## COMMANDS ##


func check_input_command(text: String) -> void:
	if !text.begins_with("/"):
		on_no_command_entered()
		return
	
	text = text.erase(0, 1)
	var command_string: String = text.get_slice(" ", 0)
	if !all_commands.has(command_string):
		on_false_command_entered()
		return
	
	if command_string == "throw_dice":
		var value1: String = text.get_slice(" ", 1)
		var value2: String = text.get_slice(" ", 2)
		if value1.is_valid_int() and value2.is_valid_int():
			if (int(value1) > 0 and int(value1) <= 6) and (int(value2) > 0 and int(value2) <= 6):
				GameManager.set("dice_throw_counter_max", 2)
				Events.emit_signal("send_dice_throw_result", int(value1))
				Events.emit_signal("send_dice_throw_result", int(value2))
		elif value1.is_valid_int() and value2 == "":
			if int(value1) > 0 and int(value1) <= 6:
				Events.emit_signal("send_dice_throw_result", int(value1))
	



