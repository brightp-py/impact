extends Control

@export var mainMenu_level_path:String

# On back button change scene to main scene
func back_button_pressed() -> void:
	SoundFx.button_click()
	get_tree().change_scene_to_file(mainMenu_level_path)

# On button hovered play audio
func back_button_mouse_entered() -> void:
	SoundFx.button_hover()
