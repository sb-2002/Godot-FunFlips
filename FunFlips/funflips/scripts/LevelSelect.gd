extends Control

var manager = null
var category = ""

func set_manager(mgr):
	manager = mgr

func set_category(cat):
	category = cat
	$VBoxContainer/Label.text = "Schwierigkeitsgrad für " + category

func _ready():
	$VBoxContainer/EasyButton.pressed.connect(_on_easy_pressed)
	$VBoxContainer/MediumButton.pressed.connect(_on_medium_pressed)
	$VBoxContainer/HardButton.pressed.connect(_on_hard_pressed)
	$BackButton.pressed.connect(_on_BackButton_pressed)

func _on_easy_pressed():
	if manager:
		manager.show_game(category, "Easy")

func _on_medium_pressed():
	if manager:
		manager.show_game(category, "Medium")

func _on_hard_pressed():
	if manager:
		manager.show_game(category, "Hard")


func _on_BackButton_pressed() -> void:
	if manager:
		manager.show_category_select()
	
