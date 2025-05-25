extends Sprite2D

@export var growth_time: float = 10.0

func _ready() -> void:
	frame = 0


func _grow_carrot() -> void:
	await get_tree().create_timer(growth_time/4).timeout
	frame += 1


func _on_poop_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("poop"):
		print("woah")
	if area == Global.poop_detection_area and area.is_in_group("poop"):
		SignalBus.carrot_fertilized.emit(area)
		for i in range(3):
			await _grow_carrot()
		await get_tree().create_timer(growth_time/4).timeout
		frame = 0
		print("got carrot!")
		# Spawn carrot item


func _on_poop_detection_mouse_entered() -> void:
	self_modulate = lerp(self_modulate, Color.GREEN, 1)


func _on_poop_detection_mouse_exited() -> void:
	self_modulate = lerp(self_modulate, Color.WHITE, 1)
