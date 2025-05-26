extends Control


@onready var settings: Control = $Settings
@onready var how_to_play: Control = $"How To Play"


func _ready() -> void:
	AudioServer.set_bus_volume_db(0, Global.master_volume)
	AudioServer.set_bus_volume_db(1, Global.music_volume)
	AudioServer.set_bus_volume_db(2, Global.sfx_volume)
	AudioManager.play_background_track1(MusicResource.MusicType.BACKGROUND_TRACK)


func _on_play_pressed() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_START)
	get_tree().change_scene_to_file("res://main.tscn")


func _on_settings_pressed() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PANEL)
	settings.visible = true
	SignalBus.settings_entered.emit()


func _on_quit_pressed() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PRESS)
	get_tree().quit()


func _on_button_mouse_entered() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_HOVER)


func _on_infinite_pressed() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_START)
	Global.infinite_mode = true
	Global.common_poops_collected = 1000000000000
	Global.common_carrot_amount = 0
	Global.golden_poops_collected = 0
	Global._initialized_values()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_how_to_play_pressed() -> void:
	how_to_play.visible = true
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PANEL)
