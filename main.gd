extends Node2D

@onready var settings: Control = %Settings


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Settings"):
		AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PANEL)
		settings.visible = !settings.visible
		if settings.visible:
			SignalBus.settings_entered.emit()


func _on_menu_pressed() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PRESS)
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
