extends Node2D

@export var tile_coord: Vector2i

func _ready() -> void:
	add_to_group("food")


func _process(delta: float) -> void:
	pass


func _on_little_guy_detection_body_entered(body: Node2D) -> void:
	if body == Global.little_guy_node:
		SignalBus.food_collected.emit(tile_coord)
		self.queue_free()
