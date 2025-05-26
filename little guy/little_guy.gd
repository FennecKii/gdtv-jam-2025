extends CharacterBody2D

enum State {
	COLLECT,
	POOP,
	REST,
	WAIT
}

var next_food: Node

var direction: Vector2
var next_food_position: Vector2
var slip_factor: float = 20
var food_pool: int = 0
var carrot_pool: int = 0
var guaranteed_poops: int = 0

var current_state: State
var previous_state: State

var performing_action: bool = false
var resting: bool = false
var collected: bool = false
var collecting: bool = false
var pooped: bool = false
var pooping: bool = false
var food_found: bool = false
var guaranteed_poop: bool = false
var is_golden_poop_chance: bool = false
var poop_multiplier: float = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_label: Label = $Control/State
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var food_collected_label: Label = $"Control/Food Collected"
@onready var food_collision: CollisionShape2D = $"Item Detection/CollisionShape2D"
@onready var food_detection_area: Area2D = $"Item Detection"
@onready var carrot_collected_label: Label = $"Control/Carrot Collected"
@onready var collection_safety_timer: Timer = $"Collection Safety Timer"


func _ready() -> void:
	add_to_group("little guy")
	food_detection_area.add_to_group("little guy")
	current_state = State.COLLECT
	SignalBus.food_collected.connect(_on_food_collected)


func _process(delta: float) -> void:
	food_collected_label.text = str("Food Ate: %s" %food_pool, "/%s" %Global.littleguy_max_food_pool)
	carrot_collected_label.text = str("Carrots Ate: %s" %carrot_pool, "/%s" %Global.carrot_pool_max)
	
	_update_state(delta)
	_update_state_action()
	
	if not next_food:
		collecting = false
		food_found = false
	elif next_food:
		food_found = true
	
	if food_pool >= Global.littleguy_max_food_pool:
		guaranteed_poop = true
	
	if carrot_pool >= Global.carrot_pool_max:
		is_golden_poop_chance = true


func _physics_process(delta: float) -> void:
	_handle_movement(delta)


func _handle_movement(delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = lerp(velocity, direction.normalized() * Global.littleguy_speed, slip_factor * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, slip_factor * delta)

	if (next_food_position - global_position).length() <= Global.littleguy_speed/100:
		food_collision.disabled = false
	else:
		food_collision.disabled = true

	_update_animation()

	move_and_slide()


func _update_animation() -> void:
	if direction:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false


func _update_state(delta: float) -> void:
	if previous_state != State.REST and current_state == State.COLLECT:
		if randf_range(0, 1) <= Global.rest_chance * delta:
			previous_state = current_state
			current_state = State.REST
			collection_safety_timer.stop()
			food_collision.disabled = true

	if current_state == State.COLLECT and not food_found:
		previous_state = current_state
		current_state = State.WAIT
		collection_safety_timer.stop()
		food_collision.disabled = true
		return

	if current_state == State.COLLECT and collected:
		previous_state = current_state
		current_state = State.POOP
		collection_safety_timer.stop()
		food_collision.disabled = true
		return

	if current_state == State.POOP and not pooping:
		previous_state = current_state
		current_state = State.WAIT
		food_collision.disabled = true
		return

	if current_state == State.WAIT and food_found:
		previous_state = current_state
		current_state = State.COLLECT
		return


func _update_state_action() -> void:
	if current_state == State.WAIT:
		state_label.text = "WAITING"
		next_food = _get_food()
		direction = Vector2.ZERO
	elif current_state == State.REST and not resting:
		state_label.text = "RESTING"
		resting = true
		collecting = false
		direction = Vector2.ZERO
		await get_tree().create_timer(Global.rest_time).timeout
		resting = false
		current_state = previous_state
		previous_state = State.REST
	elif current_state == State.COLLECT and not collecting:
		collection_safety_timer.start(15.0 - Global.littleguy_speed/100)
		state_label.text = "COLLECTING"
		collecting = true
		collected = false
		next_food = _get_food()
		if next_food == null:
			previous_state = current_state
			current_state = State.WAIT
			return
		next_food_position = next_food.global_position
		direction = next_food_position - global_position
	elif current_state == State.POOP and not pooping:
		state_label.text = "POOPING"
		pooping = true
		direction = Vector2.ZERO
		await get_tree().create_timer(Global.poop_time).timeout
		pooping = false
		if guaranteed_poop:
			guaranteed_poops = int(floori(float(food_pool) / Global.littleguy_max_food_pool))
			for i in range(guaranteed_poops):
				_poop()
			pooped = true
			guaranteed_poop = false
			guaranteed_poops = 0
			food_pool = 0
		if randf_range(0, 1) <= Global.poop_chance * poop_multiplier:
			if Global.poop_chance >= 1:
				for i in range(int(floori(Global.poop_chance))):
					_poop()
			else:
				_poop()
			pooped = true
			food_pool = 0
			poop_multiplier = 1
		if is_golden_poop_chance:
			for i in range(int(floori(float(carrot_pool) / Global.carrot_pool_max))):
				if randf_range(0, 1) <= Global.golden_poop_chance:
					_poop_golden()
			pooped = true
			is_golden_poop_chance = false
			carrot_pool = 0


func _poop() -> void:
	var poop_instance: Node = Global.poop_scene.instantiate()
	var rand_angle: float = randf_range(0, 2*PI)
	poop_instance.global_position = global_position + Vector2(2*10*cos(rand_angle), 10*sin(rand_angle))
	poop_instance.detectable = true
	Global.poop_group.add_child(poop_instance)


func _poop_golden() -> void:
	var poop_instance: Node = Global.golden_poop_scene.instantiate()
	var rand_angle: float = randf_range(0, 2*PI)
	poop_instance.global_position = global_position + Vector2(2*10*cos(rand_angle), 10*sin(rand_angle))
	poop_instance.detectable = true
	Global.golden_poop_group.add_child(poop_instance)


func _get_food() -> Node:
	var food: Array[Node] = get_tree().get_nodes_in_group("food")
	if food:
		return food.pick_random()
	else:
		return null


func _on_food_collected(area: Area2D, is_carrot: bool, _tile_coord: Vector2i) -> void:
	if area == food_detection_area:
		food_pool += 1
		collected = true
		collecting = false
	if is_carrot:
		carrot_pool += 1
		poop_multiplier += 1


func _on_collection_safety_timer_timeout() -> void:
	if current_state == State.COLLECT:
		previous_state = current_state
		current_state = State.REST
