extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options



var manager = null

func set_manager(mgr):
	manager = mgr

func _ready():
	$MainButtons/PlayButton.pressed.connect(_on_play_pressed)
	$MainButtons/OptionButton.pressed.connect(_on_option_pressed)
	$MainButtons/QuitButton.pressed.connect(_on_quit_pressed)
	main_buttons.visible  = true
	options.visible = false

func _on_play_pressed():
	if manager:
		manager.show_category_select()

func _on_option_pressed():
	#$Options/HelpAudioPlayer.pressed.connect(_on_help_pressed)
	print("Option pressed")
	main_buttons.visible = false
	options.visible = true
	#You can add a help popup or screen here

func _on_quit_pressed():
	get_tree().quit()


func _on_back_option_pressed() -> void:
	$Options/HelpAudioPlayer.stop()
	_ready()
	
#func _on_stop_music_pressed():
	#if manager:
		#manager.stop_music()


func _on_mute_pressed() -> void:
	if manager:
		manager.stop_music()


func _on_un_mute_pressed() -> void:
	if manager:
		manager.play_music()


func _on_help_pressed() -> void:
	$Options/HelpAudioPlayer.play()
