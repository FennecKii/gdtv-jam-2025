extends Node2D

@export var grabbed: bool = false

var can_pickup: bool = false


func _ready() -> void:
	add_to_group("poop")


func _process(delta: float) -> void:
	if can_pickup and Input.is_action_just_pressed("Click"):
		Global.poops_collected += 1
		SignalBus.poop_collected.emit()
		queue_free()


func _on_mouse_detection_mouse_entered() -> void:
	can_pickup = true


func _on_mouse_detection_mouse_exited() -> void:
	can_pickup = false
