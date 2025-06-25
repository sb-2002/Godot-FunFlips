extends Node
@onready var music_player: AudioStreamPlayer2D = $MusicPlayer

var current_screen: Node = null

const START_SCREEN = preload("res://scenes/StartScreen.tscn")
const CATEGORY_SCREEN = preload("res://scenes/CategorySelect.tscn")
const LEVEL_SCREEN = preload("res://scenes/LevelSelect.tscn")
const GAME_SCREEN = preload("res://scenes/Game.tscn")

func play_music():
	$MusicPlayer.play()
	
func stop_music():
	$MusicPlayer.stop()	

func _ready():
	#Set the custom cursor
	Input.set_custom_mouse_cursor(
		load("res://images/click_cursor.png"),
		Input.CURSOR_ARROW,
		Vector2(0,0)
		)
	show_screen(START_SCREEN)

func show_screen(screen_packed):
	if current_screen:
		current_screen.queue_free()
	current_screen = screen_packed.instantiate()
	add_child(current_screen)
	# Tell the screen who the manager is (for callbacks)
	if current_screen.has_method("set_manager"):
		current_screen.set_manager(self)

func show_category_select():
	show_screen(CATEGORY_SCREEN)

func show_level_select(category):
	if current_screen:
		current_screen.queue_free()
	var level_screen = LEVEL_SCREEN.instantiate()
	add_child(level_screen)
	if level_screen.has_method("set_manager"):
		level_screen.set_manager(self)
	if level_screen.has_method("set_category"):
		level_screen.set_category(category)
	current_screen = level_screen

func show_game(category, level):
	if current_screen:
		current_screen.queue_free()
	var game_screen = GAME_SCREEN.instantiate()
	add_child(game_screen)
	if game_screen.has_method("set_manager"):
		game_screen.set_manager(self)
	if game_screen.has_method("set_category_and_level"):
		game_screen.set_category_and_level(category, level)
	current_screen = game_screen
	
func show_menu():
	show_screen(START_SCREEN)
