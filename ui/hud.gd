extends Control

@onready var common_poops_label: Label = $VBoxContainer/Poop/Poops
@onready var common_foods_label: Label = $VBoxContainer/Food/Foods
@onready var upgrades_panel: Panel = $Panel
@onready var upgrades_panel_down_position: Vector2 = Vector2(upgrades_panel.position.x, upgrades_panel.position.y + upgrades_panel.size.y)
@onready var upgrades_panel_up_position: Vector2 = upgrades_panel.position

var upgrades_panel_down: bool = false

func _ready() -> void:
	SignalBus.poop_collected.connect(_on_poop_connected)
	common_foods_label.text = str(": %s" %Global.common_food_amount)
	common_poops_label.text = str(": %s" %Global.common_poops_collected)


func _process(delta: float) -> void:
	common_foods_label.text = str(": %s" %Global.common_food_amount)
	common_poops_label.text = str(": %s" %Global.common_poops_collected)


func _on_poop_connected() -> void:
	common_poops_label.text = str(": %s" %Global.common_poops_collected)


func _on_mouse_interaction_entered() -> void:
	Global.cursor_interacted = true 


func _on_mouse_interaction_exited() -> void:
	Global.cursor_interacted = false


func _on_common_poop_mouse_entered() -> void:
	Global.cursor_common_poop_interacted = true


func _on_common_food_mouse_entered() -> void:
	Global.cursor_common_food_interacted = true


func _on_common_poop_mouse_exited() -> void:
	Global.cursor_common_poop_interacted = false


func _on_common_food_mouse_exited() -> void:
	Global.cursor_common_food_interacted = false


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


func _on_hide_upgrades_pressed() -> void:
	var tween: Tween = create_tween()
	if not upgrades_panel_down:
		tween.tween_property(upgrades_panel, "position", upgrades_panel_down_position, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		upgrades_panel_down = true
	elif upgrades_panel_down:
		tween.tween_property(upgrades_panel, "position", upgrades_panel_up_position, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		upgrades_panel_down = false
