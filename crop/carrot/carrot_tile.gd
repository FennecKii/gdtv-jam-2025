class_name CarrotCrop
extends Sprite2D


@onready var poop_collision: CollisionShape2D = $"Poop Detection/Poop Collision"


func _ready() -> void:
	frame = 0


func _on_poop_detection_area_entered(area: Area2D) -> void:
	if area == Global.poop_detection_area and area.is_in_group("poop"):
		SignalBus.carrot_fertilized.emit(area)
		await grow_carrot()


func _on_poop_detection_mouse_entered() -> void:
	self_modulate = lerp(self_modulate, Color.GREEN, 1)
	AudioManager.play_sfx_global(SoundResource.SoundType.BUTTON_HOVER)


func _on_poop_detection_mouse_exited() -> void:
	self_modulate = lerp(self_modulate, Color.WHITE, 1)


func grow_carrot() -> void:
	poop_collision.set_deferred("disabled", true)
	await get_tree().create_timer(randf_range(Global.carrot_growth_time/4 - 1, Global.carrot_growth_time/4 +1)).timeout
	frame = 1
	await get_tree().create_timer(randf_range(Global.carrot_growth_time/4 - 1, Global.carrot_growth_time/4 +1)).timeout
	frame = 2
	await get_tree().create_timer(randf_range(Global.carrot_growth_time/4 - 1, Global.carrot_growth_time/4 +1)).timeout
	frame = 3
	await get_tree().create_timer(Global.carrot_growth_time/4).timeout
	frame = 0
	SignalBus.spawn_carrot.emit(global_position)
	poop_collision.set_deferred("disabled", false)
