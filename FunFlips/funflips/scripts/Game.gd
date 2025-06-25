extends Control

const CARD_SCENE = preload("res://scenes/Card.tscn")

var all_card_data = {
	"Tiere": [{"image": "res://images/animals/Cow.png", "sound": "res://assets/sounds/animals/kuh.mp3"},
		 {"image": "res://images/animals/Dog.png", "sound": "res://assets/sounds/animals/hund.mp3"},
		{"image": "res://images/animals/Fox.png", "sound": "res://assets/sounds/animals/fuchs.mp3"},
		{"image": "res://images/animals/Hippopotamus.png", "sound": "res://assets/sounds/animals/nilpferd.mp3"},
		{"image": "res://images/animals/Kangaroo.png", "sound": "res://assets/sounds/animals/känguru.mp3"},
		{"image": "res://images/animals/Monkey.png", "sound": "res://assets/sounds/animals/affe.mp3"},
		{"image": "res://images/animals/Penguin.png", "sound": "res://assets/sounds/animals/pinguin.mp3"},
		{"image": "res://images/animals/Rabbit.png", "sound": "res://assets/sounds/animals/kaninchen.mp3"},
		 {"image": "res://images/animals/Elephant.png", "sound": "res://assets/sounds/animals/elefant.mp3"},
		 {"image": "res://images/animals/Horse.png", "sound": "res://assets/sounds/animals/pferd.mp3"},
		 {"image": "res://images/animals/Lion.png", "sound": "res://assets/sounds/animals/löwe.mp3"},
		 {"image": "res://images/animals/Pig.png", "sound": "res://assets/sounds/animals/schwein.mp3"}],
	"Früchte": [{"image": "res://images/fruits/Apple.png", "sound": "res://assets/sounds/fruits/apfel.mp3"},
		{"image": "res://images/fruits/Banana.png", "sound": "res://assets/sounds/fruits/banane.mp3"},
		{"image": "res://images/fruits/Avocado.png", "sound": "res://assets/sounds/fruits/avocado.mp3"},
		{"image": "res://images/fruits/Kiwi.png", "sound": "res://assets/sounds/fruits/kiwi.mp3"},
		{"image": "res://images/fruits/Papaya.png", "sound": "res://assets/sounds/fruits/papaya.mp3"},
		{"image": "res://images/fruits/Pomegranate.png", "sound": "res://assets/sounds/fruits/granatapfel.mp3"},
		{"image": "res://images/fruits/Strawberry.png", "sound": "res://assets/sounds/fruits/erdbeere.mp3"},
		{"image": "res://images/fruits/Watermelon.png", "sound": "res://assets/sounds/fruits/wassermelone.mp3"},
		{"image": "res://images/fruits/Cherry.png", "sound": "res://assets/sounds/fruits/kirsche.mp3"},
		{"image": "res://images/fruits/Grape.png", "sound": "res://assets/sounds/fruits/traube.mp3"},
		{"image": "res://images/fruits/Mango.png", "sound": "res://assets/sounds/fruits/mango.mp3"},
		{"image": "res://images/fruits/Peach.png", "sound": "res://assets/sounds/fruits/pfirsich.mp3"}],
	"Gemüse": [{"image": "res://images/vegetables/Carrot.png", "sound": "res://assets/sounds/vegetables/karotte.mp3"},
		{"image": "res://images/vegetables/Cucumber.png", "sound": "res://assets/sounds/vegetables/gurke.mp3"},
		{"image": "res://images/vegetables/Potato.png", "sound": "res://assets/sounds/vegetables/kartoffel.mp3"},
		{"image": "res://images/vegetables/Pumpkin.png", "sound": "res://assets/sounds/vegetables/kürbis.mp3"},
		{"image": "res://images/vegetables/Spinach.png", "sound": "res://assets/sounds/vegetables/spinat.mp3"},
		{"image": "res://images/vegetables/Tomato.png", "sound": "res://assets/sounds/vegetables/tomate.mp3"},
		{"image": "res://images/vegetables/Beet.png", "sound": "res://assets/sounds/vegetables/rote_bete.mp3"},
		{"image": "res://images/vegetables/Broccoli.png", "sound": "res://assets/sounds/vegetables/brokkoli.mp3"},
		{"image": "res://images/vegetables/Cabbage.png", "sound": "res://assets/sounds/vegetables/kohl.mp3"},
		{"image": "res://images/vegetables/Cauliflower.png", "sound": "res://assets/sounds/vegetables/blumenkohl.mp3"},
		{"image": "res://images/vegetables/Eggplant.png", "sound": "res://assets/sounds/vegetables/aubergine.mp3"},
		{"image": "res://images/vegetables/Ginger.png", "sound": "res://assets/sounds/vegetables/ingwer.mp3"}]
}
var card_data = []
var flipped_cards = []
var category = ""
var level = ""
var move_count = 0

# Optional: keep a reference to the main manager if you want to go back to menu, etc.
var manager = null

func set_manager(mgr):
	manager = mgr

func set_category_and_level(cat, lvl):
	category = cat
	level = lvl
	# Normalize category just in case (removes leading/trailing spaces, capitalizes first letter)
	var normalized = category.strip_edges().capitalize()
	var all_cards = []
	print("Received category: ", category, " | Normalized: ", normalized)
	if all_card_data.has(normalized):
		all_cards = all_card_data[normalized]
	else:
		all_cards = all_card_data["Animals"]
		print("Unknown category, using Animals as fallback.")
		
	var num_pairs = 6 #Default to easy
	match level.to_lower():
		"easy":
			num_pairs =6
		"medium":
			num_pairs = 9
		"hard":
			num_pairs = 12
			
	#clamp to maximum available pairs
	num_pairs = min(num_pairs, all_cards.size())
	
	#Pick first N (or random N) cards for the level
	card_data = all_cards.duplicate()
	card_data.shuffle()
	card_data = card_data.slice(0, num_pairs)
	start_game() # <--Only call start_game here!

func _ready():
	#DO NOT call start_game() here!!
	# Fallback if card_data is not set by set_category_and_level
	# Optionally connect the PlayAgainButton if not already connected
	if $PlayAgainButton.pressed.is_connected(_on_PlayAgainButton_pressed) == false:
		$PlayAgainButton.pressed.connect(_on_PlayAgainButton_pressed)
	if $BackToMenuButton.pressed.is_connected(_on_BackToMenuButton_pressed) == false:
		$BackToMenuButton.pressed.connect(_on_BackToMenuButton_pressed)
	if $BackButton.pressed.is_connected(_on_BackButton_pressed) == false:
		$BackButton.pressed.connect(_on_BackButton_pressed)
	
func start_game():
	move_count = 0;
	update_move_label()
	print("Starting game with card_data: ", card_data)
	# Duplicate and shuffle card data (make pairs)
	var deck = card_data.duplicate()
	deck.append_array(card_data)
	deck.shuffle()

	var grid = $GridContainer
	
	#Dynamically set columns based on number of cards
	match deck.size():
		12:
			grid.columns = 4  # 6 pairs (2 rows of 6, or 4x3)
		18:
			grid.columns = 6 # 9 pairs (3 rows of 6)
		24:
			grid.columns = 6 # 12 pairs (4 rows of 6)
		_:
			grid.columns = 4 #fallback
	# Remove all existing children from the grid (to "clear" it)
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	flipped_cards.clear()

	# Make sure win label and play again button are hidden
	$WinLabel.visible = false
	$PlayAgainButton.visible = false
	$BackToMenuButton.visible = false
	$CupImage.visible = false

	# Create card nodes
	for i in range(deck.size()):
		var card = CARD_SCENE.instantiate()
		card.set_manager(self)
		card.set_card_data(i, deck[i])
		grid.add_child(card)

func on_card_clicked(card):
	# Only allow flipping if less than 2 cards are flipped and card is not already flipped
	if card.is_flipped or flipped_cards.size() >= 2:
		return
	card.flip()
	flipped_cards.append(card)

	if flipped_cards.size() == 2:
		move_count += 1
		update_move_label()
		# Delay before checking for match (so player sees both cards)
		await get_tree().create_timer(0.7).timeout
		check_match()

func check_match():
	var card1 = flipped_cards[0]
	var card2 = flipped_cards[1]
	if card1.image_path == card2.image_path:
		# Matched! Disable the cards so they can't be clicked again
		card1.disabled = true
		card2.disabled = true
		# Optionally: Play a sound or show a match animation here
		if card1.has_node("MatchSound"):
			card1.get_node("MatchSound").play()
		if card2.has_node("MatchSound"):
			card2.get_node("MatchSound").play()
	else:
		# No match, flip them back over
		card1.flip(false)  # <-- Donot play sound
		card2.flip(false)    #<-- Do not play sound
	flipped_cards.clear()
	check_win()

func check_win():
	var grid = $GridContainer
	var all_disabled = true
	for card in grid.get_children():
		if !card.disabled:
			all_disabled = false
			break
	if all_disabled:
		#$WinLabel.text = "You Win!"
		$WinLabel.visible = true
		$PlayAgainButton.visible = true
		$BackToMenuButton.visible = true
		$CupImage.visible = true
		$CupImage.scale = Vector2(0,0)  #Reset in case
		$AnimationPlayer.play("show_cup")
		$WinSound.play()
		#This is to remove all cards
		for card in grid.get_children():
			grid.remove_child(card)
			card.queue_free()
		#This hides moves label
		#$MoveLabel.visible  = false

func _on_PlayAgainButton_pressed():
	$WinLabel.visible = false
	$PlayAgainButton.visible = false
	$BackToMenuButton.visible = false
	$WinSound.stop()
	start_game()


func _on_BackToMenuButton_pressed() -> void:
	# Go back to your main menu
	if manager:
		manager.show_menu()
		
func update_move_label():
	$MoveLabel.text = "Moves: %d" % move_count
	

func _on_BackButton_pressed() -> void:
	if manager:
		manager.show_level_select(category)
	#Go back to level select
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_BackButton_pressed()
