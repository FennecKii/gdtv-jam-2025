extends Node2D

@export var detection_area: Area2D
@export var detectable: bool = false

var can_pickup: bool = false

@onready var mouse_detection: CollisionShape2D = $"Mouse Detection/Mouse Detection"
@onready var mouse_detection_area: Area2D = $"Mouse Detection"


func _ready() -> void:
	add_to_group("poop")
	mouse_detection_area.add_to_group("poop")
	Global.play_3x_squash_stretch(self)


func _process(_delta: float) -> void:
	if can_pickup and Input.is_action_just_pressed("Click"):
		Global.golden_poops_collected += 1
		queue_free()
	
	if detectable:
		mouse_detection.disabled = false
	elif not detectable:
		mouse_detection.disabled = true


func _on_mouse_detection_mouse_entered() -> void:
	can_pickup = true


func _on_mouse_detection_mouse_exited() -> void:
	can_pickup = false
