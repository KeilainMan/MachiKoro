extends VBoxContainer


var cardstack_name: String:
	set(new_name):
		cardstack_name = new_name
	get:
		return cardstack_name


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_child_entered_tree(node):
	if get_child(0) is CardBase:
		set("cardstack_name", get_child(0).card_name)
