extends Node2D

@export var spawner_component: SpawnerComponent

var food_spawned: bool = false

var poop_instance: Node

@onready var food_timer: Timer = $"Food Timer"
@onready var food_group: Node2D = $"Y-Sort/Food Group"
@onready var poop_group: Node2D = $"Y-Sort/Poop Group"
@onready var cursor: Sprite2D = $Viewport/Cursor


func _ready() -> void:
	spawner_component.spawn_littleguy()
	if not spawner_component:
		assert(spawner_component, "%s not found." %spawner_component)
	food_timer.wait_time = randf_range(Global.food_spawn_time - 1, Global.food_spawn_time + 1)
	food_timer.start()
	Global.food_group = food_group
	Global.poop_group = poop_group
	SignalBus.add_little_guy.connect(_on_add_little_guy)


func _process(delta: float) -> void:
	_process_food()
	_update_timer()
	
	_grab_item()
	_release_item()
	if Global.cursor_grabbing and Global.poop_grabbed:
			poop_instance.global_position = lerp(poop_instance.global_position, get_global_mouse_position(), 15 * delta)


func _process_food() -> void:
	if food_spawned:
		return
	elif not food_spawned:
		for food_count in range(Global.food_spawn_amount):
			spawner_component.spawn_food()
		food_spawned = true
		food_timer.start()


func _update_timer() -> void:
	if not food_timer.is_stopped():
		return
	elif food_timer.is_stopped():
		food_spawned = false


func _grab_item() -> void:
	if Global.cursor_interacted and Input.is_action_just_pressed("Click"):
		if Global.cursor_poop_interacted and Global.poops_collected > 0:
			Global.poops_collected -= 1
			Global.poop_grabbed = true
			poop_instance = Global.poop_scene.instantiate()
			poop_instance.global_position = get_global_mouse_position()
			poop_group.add_child(poop_instance)


func _release_item() -> void:
	if Global.cursor_grabbing and Input.is_action_just_released("Click"):
		if Global.cursor_interacted and Global.poop_grabbed:
			if Global.cursor_poop_interacted:
				poop_instance.queue_free()
				Global.poops_collected += 1
		Global.poop_grabbed = false
		Global.cursor_grabbing = false


func _on_add_little_guy() -> void:
	spawner_component.spawn_littleguy()
