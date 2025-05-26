extends Node2D

@export var spawner_component: SpawnerComponent

var food_spawned: bool = false
var carrot_spawned: bool = false

var common_poop_instance: Node
var common_food_instance: Node
var common_carrot_instance: Node
var poop_instances: Array[Node]

@onready var food_timer: Timer = $"Food Timer"
@onready var carrot_timer: Timer = $"Carrot Timer"
@onready var food_group: Node2D = $"Y-Sort/Food Group"
@onready var poop_group: Node2D = $"Y-Sort/Poop Group"
@onready var auto_collect_timer: Timer = $"Auto Collect Timer"


func _ready() -> void:
	spawner_component.spawn_littleguy()
	if not spawner_component:
		assert(spawner_component, "%s not found." %spawner_component)
	food_timer.wait_time = Global.food_spawn_time
	carrot_timer.wait_time = Global.carrot_spawn_time
	Global.food_group = food_group
	Global.poop_group = poop_group
	SignalBus.add_little_guy.connect(_on_add_little_guy)


func _process(delta: float) -> void:
	food_timer.wait_time = Global.food_spawn_time
	carrot_timer.wait_time = Global.carrot_spawn_time
	auto_collect_timer.wait_time = Global.poop_auto_collect_time
	poop_instances = poop_group.get_children()
	
	if Global.poop_auto_collect and len(poop_instances) > 0 and auto_collect_timer.is_stopped():
		auto_collect_timer.start()
		for i in range(min(len(poop_instances), Global.poop_auto_collect_amount)):
			var poop: Node = poop_instances.pick_random()
			poop.queue_free()
			Global.common_poops_collected += 1
	
	if Global.food_spawn_auto:
		_process_food()
		_update_timer()
	
	if Global.carrot_spawn_auto and Global.common_carrot_amount > 0:
		_process_carrot()
		_update_carrot_timer()
	
	_grab_item()
	_release_item()
	if Global.cursor_grabbing and Global.common_poop_grabbed:
		common_poop_instance.global_position = lerp(common_poop_instance.global_position, get_global_mouse_position(), 17 * delta)
	if Global.cursor_grabbing and Global.common_food_grabbed and common_food_instance:
		common_food_instance.global_position = lerp(common_food_instance.global_position, get_global_mouse_position() + Vector2(0, 10), 17 * delta)
	if Global.cursor_grabbing and Global.common_carrot_grabbed and common_carrot_instance:
		common_carrot_instance.global_position = lerp(common_carrot_instance.global_position, get_global_mouse_position() + Vector2(0, 5), 17 * delta)

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


func _process_carrot() -> void:
	if carrot_spawned:
		return
	elif not carrot_spawned:
		for carrot_count in range(min(Global.common_carrot_amount, Global.carrot_spawn_amount)):
			spawner_component.spawn_carrot()
		carrot_spawned = true
		carrot_timer.start()


func _update_carrot_timer() -> void:
	if not carrot_timer.is_stopped():
		return
	elif carrot_timer.is_stopped():
		carrot_spawned = false


func _grab_item() -> void:
	if Global.cursor_interacted and Input.is_action_just_pressed("Click"):
		if Global.cursor_common_poop_interacted and Global.common_poops_collected > 0:
			Global.common_poops_collected -= 1
			Global.common_poop_grabbed = true
			common_poop_instance = Global.poop_scene.instantiate()
			common_poop_instance.global_position = get_global_mouse_position()
			common_poop_instance.detectable = false
			common_poop_instance.z_index = 2
			Global.poop_detection_area = common_poop_instance.detection_area
			poop_group.add_child(common_poop_instance)
		elif Global.cursor_common_food_interacted:
			Global.common_food_grabbed = true
			common_food_instance = Global.fry_scene.instantiate()
			common_food_instance.global_position = get_global_mouse_position()
			common_food_instance.detectable = false
			food_group.add_child(common_food_instance)
		elif Global.cursor_common_carrot_interacted and Global.common_carrot_amount > 0:
			Global.common_carrot_amount -= 1
			Global.common_carrot_grabbed = true
			common_carrot_instance = Global.carrot_scene.instantiate()
			common_carrot_instance.global_position = get_global_mouse_position()
			common_carrot_instance.detectable = false
			food_group.add_child(common_carrot_instance)


func _release_item() -> void:
	if Global.cursor_grabbing and Input.is_action_just_released("Click"):
		if not Global.cursor_interacted and Global.common_poop_grabbed:
			Global.play_squash_stretch(common_poop_instance)
			common_poop_instance.detectable = true
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
		if not Global.cursor_interacted and Global.common_carrot_grabbed and common_carrot_instance:
			Global.play_squash_stretch(common_carrot_instance)
			common_carrot_instance.detectable = true
			common_carrot_instance.mouse_detectable = false
			Global.common_carrot_grabbed = false
		elif Global.cursor_interacted and Global.common_carrot_grabbed:
			if Global.cursor_common_carrot_interacted:
				common_carrot_instance.queue_free()
				Global.common_carrot_amount += 1
				Global.common_carrot_grabbed = false
		Global.cursor_grabbing = false


func _on_add_little_guy() -> void:
	spawner_component.spawn_littleguy()
