extends Control

#Main menu configuration. Link each button to it's function in _ready

func _ready() -> void:
	$Options/PlayButton.pressed.connect(_on_play)
	$Options/ExitButton.pressed.connect(_on_exit)

func _on_play() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_exit() -> void:
	get_tree().quit()
