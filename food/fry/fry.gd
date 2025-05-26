extends Node2D

@export var tile_coord: Vector2i
@export var detectable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if detectable:
		add_to_group("food")
		Global.play_squash_stretch(self)


func _process(_delta: float) -> void:
	if detectable:
		add_to_group("food")


func _on_little_guy_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("little guy"):
		SignalBus.food_collected.emit(area, false, tile_coord)
		queue_free()
