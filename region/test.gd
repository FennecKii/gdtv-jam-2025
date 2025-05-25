extends Node2D

@export var spawner_component: SpawnerComponent

var food_spawned: bool = false

var common_poop_instance: Node
var common_food_instance: Node

@onready var food_timer: Timer = $"Food Timer"
@onready var food_group: Node2D = $"Y-Sort/Food Group"
@onready var poop_group: Node2D = $"Y-Sort/Poop Group"


func _ready() -> void:
	spawner_component.spawn_littleguy()
	if not spawner_component:
		assert(spawner_component, "%s not found." %spawner_component)
	food_timer.wait_time = Global.food_spawn_time
	food_timer.start()
	Global.food_group = food_group
	Global.poop_group = poop_group
	SignalBus.add_little_guy.connect(_on_add_little_guy)


func _process(delta: float) -> void:
	if Global.food_spawn_auto:
		_process_food()
		_update_timer()
	
	_grab_item()
	_release_item()
	if Global.cursor_grabbing and Global.common_poop_grabbed:
		common_poop_instance.global_position = lerp(common_poop_instance.global_position, get_global_mouse_position(), 17 * delta)
	if Global.cursor_grabbing and Global.common_food_grabbed and common_food_instance:
		common_food_instance.global_position = lerp(common_food_instance.global_position, get_global_mouse_position() + Vector2(0, 10), 17 * delta)


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
		if Global.cursor_common_poop_interacted and Global.common_poops_collected > 0:
			Global.common_poops_collected -= 1
			Global.common_poop_grabbed = true
			common_poop_instance = Global.poop_scene.instantiate()
			common_poop_instance.global_position = get_global_mouse_position()
			poop_group.add_child(common_poop_instance)
		elif Global.cursor_common_food_interacted:
			Global.common_food_grabbed = true
			common_food_instance = Global.fry_scene.instantiate()
			common_food_instance.global_position = get_global_mouse_position()
			common_food_instance.detectable = false
			food_group.add_child(common_food_instance)


func _release_item() -> void:
	if Global.cursor_grabbing and Input.is_action_just_released("Click"):
		if not Global.cursor_interacted and Global.common_poop_grabbed:
			Global.play_squash_stretch(common_poop_instance)
			Global.common_poop_grabbed = false
		elif Global.cursor_interacted and Global.common_poop_grabbed:
			if Global.cursor_common_poop_interacted:
				common_poop_instance.queue_free()
				Global.common_poops_collected += 1
				Global.common_poop_grabbed = false
		if not Global.cursor_interacted and Global.common_food_grabbed and common_food_instance:
			Global.play_squash_stretch(common_food_instance)
			common_food_instance.detectable = true
			Global.common_food_grabbed = false
		elif Global.cursor_interacted and Global.common_food_grabbed:
			if Global.cursor_common_food_interacted:
				common_food_instance.queue_free()
				Global.common_food_grabbed = false
		Global.cursor_grabbing = false


func _on_add_little_guy() -> void:
	spawner_component.spawn_littleguy()
