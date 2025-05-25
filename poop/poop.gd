extends Node2D

@export var detection_area: Area2D
@export var grabbed: bool = false
@export var detectable: bool = false

var can_pickup: bool = false

@onready var mouse_detection: CollisionShape2D = $"Mouse Detection/Mouse Detection"
@onready var mouse_detection_area: Area2D = $"Mouse Detection"


func _ready() -> void:
	add_to_group("poop")
	mouse_detection_area.add_to_group("poop")
	Global.play_squash_stretch(self)
	SignalBus.carrot_fertilized.connect(_on_carrot_fertilized)


func _process(delta: float) -> void:
	if can_pickup and Input.is_action_just_pressed("Click"):
		Global.common_poops_collected += 1
		SignalBus.poop_collected.emit()
		queue_free()
	
	if detectable:
		mouse_detection.disabled = false
	elif not detectable:
		mouse_detection.disabled = true


func _on_mouse_detection_mouse_entered() -> void:
	can_pickup = true


func _on_mouse_detection_mouse_exited() -> void:
	can_pickup = false


func _on_carrot_fertilized(detection: Area2D) -> void:
	if detection == mouse_detection_area:
		queue_free()
