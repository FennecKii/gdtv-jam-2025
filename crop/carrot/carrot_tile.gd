extends Sprite2D


@onready var poop_collision: CollisionShape2D = $"Poop Detection/Poop Collision"

@export var growth_time: float = 8

func _ready() -> void:
	frame = 0


func _grow_carrot() -> void:
	await get_tree().create_timer(randf_range(growth_time/4 - 1, growth_time/4 +1)).timeout
	frame += 1


func _on_poop_detection_area_entered(area: Area2D) -> void:
	if area == Global.poop_detection_area and area.is_in_group("poop"):
		SignalBus.carrot_fertilized.emit(area)
		poop_collision.set_deferred("disabled", true)
		for i in range(3):
			await _grow_carrot()
		await get_tree().create_timer(1).timeout
		frame = 0
		SignalBus.spawn_carrot.emit(global_position)
		poop_collision.set_deferred("disabled", false)


func _on_poop_detection_mouse_entered() -> void:
	self_modulate = lerp(self_modulate, Color.GREEN, 1)


func _on_poop_detection_mouse_exited() -> void:
	self_modulate = lerp(self_modulate, Color.WHITE, 1)
