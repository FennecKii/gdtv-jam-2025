extends Node2D

@onready var settings: Control = %Settings


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Settings"):
		settings.visible = !settings.visible


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
