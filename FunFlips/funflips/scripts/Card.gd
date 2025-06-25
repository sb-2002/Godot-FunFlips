extends Button

var manager = null
var card_index = 0
var image_path = ""
var sound_path = ""
var is_flipped = false

func set_manager(mgr):
	manager = mgr

# Updated to accept a dictionary with image and sound
func set_card_data(idx, data):
	card_index = idx
	image_path = data.get("image", "")
	sound_path = data.get("sound", "")
	$FaceImage.texture = load(image_path)
	$FaceImage.visible = false
	$BackImage.visible = true
	is_flipped = false
	# Set the voice sound for this card
	if sound_path != "":
		$VoiceSound.stream = load(sound_path)
	else:
		$VoiceSound.stream = null

# Only play the voice sound when the user flips the card up
func flip(play_voice := true):
	is_flipped = !is_flipped
	$FaceImage.visible = is_flipped
	$BackImage.visible = not is_flipped
	# Play the unique voice if the card is being flipped face up,
	# triggered by the user (not for auto-mismatch flip-downs)
	if is_flipped and play_voice and $VoiceSound.stream:
		$VoiceSound.play()
	# Optionally, play a generic flip sound here if you want:
	# if play_voice and $FlipSound.stream and not $FlipSound.playing:
	#     $FlipSound.play()

func _pressed():
	if manager:
		manager.on_card_clicked(self)

# For matching, you want to compare image_path
func get_face_id():
	return image_path
