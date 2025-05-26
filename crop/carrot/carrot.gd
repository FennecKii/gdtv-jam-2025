extends Node2D

@export var tile_coord: Vector2i
@export var grabbed: bool = false
@export var detectable: bool = false
@export var mouse_detectable: bool = true

var can_pickup: bool = false

@onready var mouse_detection: CollisionShape2D = $"Mouse Detection/Mouse Detection"
@onready var mouse_detection_area: Area2D = $"Mouse Detection"
@onready var little_guy_detection: CollisionShape2D = $"Little Guy Detection/Little Guy Detection"


func _ready() -> void:
	add_to_group("carrot")
	if detectable:
		add_to_group("food")
		Global.play_squash_stretch(self)


func _process(_delta: float) -> void:
	if can_pickup and Input.is_action_just_pressed("Click"):
		Global.common_carrot_amount += 1
		AudioManager.play_sfx_global(SoundResource.SoundType.RELEASE_2)
		queue_free()
	
	if detectable:
		little_guy_detection.disabled = false
	elif not detectable:
		little_guy_detection.disabled = true
	
	if mouse_detectable:
		mouse_detection.disabled = false
	elif not mouse_detectable:
		mouse_detection.disabled = true
	
	if detectable:
		add_to_group("food")

func _on_mouse_detection_mouse_entered() -> void:
	can_pickup = true


func _on_mouse_detection_mouse_exited() -> void:
	can_pickup = false


func _on_little_guy_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("little guy"):
		SignalBus.food_collected.emit(area, true, tile_coord)
		queue_free()
