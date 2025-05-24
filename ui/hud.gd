extends Control

@onready var poops_label: Label = $VBoxContainer/Poop/Poops
@onready var crops_label: Label = $VBoxContainer/Crop/Crops

func _ready() -> void:
	SignalBus.poop_collected.connect(_on_poop_connected)
	crops_label.text = str(": %s" %Global.crops_collected)
	poops_label.text = str(": %s" %Global.poops_collected)


func _process(delta: float) -> void:
	crops_label.text = str(": %s" %Global.crops_collected)
	poops_label.text = str(": %s" %Global.poops_collected)


func _on_poop_connected() -> void:
	poops_label.text = str(": %s" %Global.poops_collected)


func _on_mouse_interaction_entered() -> void:
	Global.cursor_interacted = true 


func _on_mouse_interaction_exited() -> void:
	Global.cursor_interacted = false


func _on_poop_mouse_entered() -> void:
	Global.cursor_poop_interacted = true


func _on_add_little_guy_pressed() -> void:
	if Global.poops_collected >= 10:
		Global.poops_collected -= 10
		Global.littleguy_count += 1
		SignalBus.add_little_guy.emit()


func _on_increase_little_guy_speed_pressed() -> void:
	if Global.poops_collected >= 10:
		Global.poops_collected -= 10
		Global.littleguy_speed += Global.littleguy_speed * 0.25


func _on_decrease_poop_time_pressed() -> void:
	if Global.poops_collected >= 5:
		Global.poops_collected -= 5
		Global.poop_time -= Global.poop_time * 0.25


func _on_increase_poop_chance_pressed() -> void:
	if Global.poops_collected >= 2:
		Global.poops_collected -= 2
		Global.poop_chance += Global.poop_chance * 0.25


func _on_decrease_rest_time_pressed() -> void:
	if Global.poops_collected >= 5:
		Global.poops_collected -= 5
		Global.rest_time -= Global.rest_time * 0.25


func _on_decrease_rest_chance_pressed() -> void:
	if Global.poops_collected >= 10:
		Global.poops_collected -= 10
		Global.rest_chance += Global.rest_chance * 0.25


func _on_decrease_food_spawn_time_pressed() -> void:
	if Global.poops_collected >= 15:
		Global.poops_collected -= 15
		Global.food_spawn_time -= Global.food_spawn_time * 0.25


func _on_increase_food_spawn_amount_pressed() -> void:
	if Global.poops_collected >= 25:
		Global.poops_collected -= 25
		Global.food_spawn_amount += 1
