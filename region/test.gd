extends Node2D

@export var spawner_component: SpawnerComponent
@export var food_wait_time: float = 5.0

var food_spawned: bool = false

@onready var food_timer: Timer = $"Food Timer"
@onready var food_group: Node2D = $"Y-Sort/Food Group"
@onready var poop_group: Node2D = $"Y-Sort/Poop Group"


func _ready() -> void:
	if not spawner_component:
		assert(spawner_component, "%s not found." %spawner_component)
	food_timer.wait_time = food_wait_time
	food_timer.start()
	Global.poop_group = poop_group


func _process(delta: float) -> void:
	_process_food()
	_update_timer()


func _process_food() -> void:
	if food_spawned:
		return
	elif not food_spawned:
		spawner_component.spawn_food()
		food_spawned = true
		food_timer.start()


func _update_timer() -> void:
	if not food_timer.is_stopped():
		return
	elif food_timer.is_stopped():
		food_spawned = false
