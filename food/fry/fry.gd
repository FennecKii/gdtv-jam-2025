extends Node2D

@export var tile_coord: Vector2i

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	add_to_group("food")


func _process(delta: float) -> void:
	pass


func _on_little_guy_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("little guy"):
		SignalBus.food_collected.emit(body, tile_coord)
		queue_free()
