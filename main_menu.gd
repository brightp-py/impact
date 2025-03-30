extends Control

@export var credits_level_path:String
@export var howToPlay_level_path:String
@export var main_level_path:String

# On play button change scene to main scene
func play_button_pressed() -> void:
	SoundFx.button_click()
	get_tree().change_scene_to_file(main_level_path)
# On button hovered play audio
func play_button_mouse_entered() -> void:
	SoundFx.button_hover()

# On how to play button change scene to how to play scene
func how_to_play_button_pressed() -> void:
	SoundFx.button_click()
	get_tree().change_scene_to_file(howToPlay_level_path)
# On button hovered play audio
func how_to_play_button_mouse_entered() -> void:
	SoundFx.button_hover()

# On credits button change scene to credits scene
func credits_button_pressed() -> void:
	SoundFx.button_click()
	get_tree().change_scene_to_file(credits_level_path)
# On button hovered play audio
func credits_button_mouse_entered() -> void:
	SoundFx.button_hover()

# On exit button quit game
func exit_button_pressed() -> void:
	SoundFx.button_click()
	get_tree().quit()
# On button hovered play audio
func exit_button_mouse_entered() -> void:
	SoundFx.button_hover()
