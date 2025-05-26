extends Control


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	visible = false
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_PRESS)
	if Global.infinite_mode:
		Global._initialized_values()
		Global.common_poops_collected = 0
		Global.common_carrot_amount = 0
		Global.golden_poops_collected = 0
		Global.infinite_mode = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_main_menu_mouse_entered() -> void:
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_HOVER)
