extends Control

var manager = null
var selected_category = ""

func set_manager(mgr):
	manager = mgr

func _ready():
	$VBoxContainer/AnimalsButton.pressed.connect(_on_animals_pressed)
	$VBoxContainer/FruitsButton.pressed.connect(_on_fruits_pressed)
	$VBoxContainer/VegetablesButton.pressed.connect(_on_vegetables_pressed)
	$BackButton.pressed.connect(_on_BackButton_pressed)

func _on_animals_pressed():
	selected_category = "Tiere"
	# Tell the manager to show the level select screen, and pass the chosen category
	manager.show_level_select(selected_category)

func _on_fruits_pressed():
	selected_category = "Früchte"
	manager.show_level_select(selected_category)

func _on_vegetables_pressed():
	selected_category = "Gemüse"
	manager.show_level_select(selected_category)


func _on_BackButton_pressed() -> void:
	if manager:
		manager.show_menu()
