extends Node2D
@onready var display_1 = $HBoxContainer/Display1
@onready var display_2 = $HBoxContainer/Display2
@onready var display_3 = $HBoxContainer/Display3
@onready var display_4 = $HBoxContainer/Display4
@onready var display_5 = $HBoxContainer/Display5
@onready var display_6 = $HBoxContainer/Display6
@onready var displays: Array = [
	display_1,
	display_2,
	display_3,
	display_4,
	display_5,
	display_6,
]
@onready var label_1 = $HBoxContainer2/Label1
@onready var label_2 = $HBoxContainer2/Label2
@onready var label_3 = $HBoxContainer2/Label3
@onready var label_4 = $HBoxContainer2/Label4
@onready var label_5 = $HBoxContainer2/Label5
@onready var label_6 = $HBoxContainer2/Label6
@onready var labels: Array = [
	label_1,
	label_2,
	label_3,
	label_4,
	label_5,
	label_6,
]

var counter1: int = 0
var counter2: int = 0
var counter3: int = 0
var counter4: int = 0
var counter5: int = 0
var counter6: int = 0
@onready var counters: Array = [
	counter1,
	counter2,
	counter3,
	counter4,
	counter5,
	counter6,
]

func _ready():
	start_simulation()


func start_simulation() -> void:
	for n in 1000:
		var x: int = randi_range(1,6)
		if x == 1:
			counter1 += 1
		if x == 2:
			counter2 += 1
		if x == 3:
			counter3 += 1
		if x == 4:
			counter4 += 1
		if x == 5:
			counter5 += 1
		if x == 6:
			counter6 += 1
	for n in counters.size():
		var y: int
		if n == 0:
			y = counter1
		if n == 1:
			y = counter2
		if n == 2:
			y = counter3
		if n == 3:
			y = counter4
		if n == 4:
			y = counter5
		if n == 5:
			y = counter6
		displays[n].custom_minimum_size.y = y
		labels[n].text = str(y)
		


func _on_button_pressed():
	counter1 = 0
	counter2 = 0
	counter3 = 0
	counter4 = 0
	counter5 = 0
	counter6 = 0
	
	start_simulation()
