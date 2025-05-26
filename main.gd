extends Node2D

@onready var settings: Control = %Settings
@onready var win_panel: Control = $"CanvasLayer/Win Panel"


func _ready() -> void:
	if Global.game_won:
		Global._initialized_values()
		Global.common_poops_collected = 0
		Global.common_carrot_amount = 0
		Global.golden_poops_collected = 0
		Global.game_won = false
		win_panel.visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Settings"):
		AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PANEL)
		settings.visible = !settings.visible
		if settings.visible:
			SignalBus.settings_entered.emit()
	
	if Global.golden_poops_collected >= 1:
		get_tree().paused = true
		Global.game_won = true
		AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_START)
		win_panel.visible = true


func _on_menu_pressed() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PRESS)
	if Global.infinite_mode:
		Global._initialized_values()
		Global.common_poops_collected = 0
		Global.common_carrot_amount = 0
		Global.golden_poops_collected = 0
		Global.infinite_mode = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
