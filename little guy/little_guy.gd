extends CharacterBody2D

#TODO poop is the currency :)

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

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_label: Label = $Control/State
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var food_collected_label: Label = $"Control/Food Collected"


func _ready() -> void:
	add_to_group("little guy")
	current_state = State.COLLECT
	SignalBus.food_collected.connect(_on_food_collected)


func _process(delta: float) -> void:
	food_collected_label.text = str("Food Ate: %s" %food_pool, "/%s" %Global.littleguy_max_food_pool)
	
	_update_state(delta)
	_update_state_action()
	
	if not next_food:
		collecting = false
		food_found = false
	elif next_food:
		food_found = true
	
	if food_pool >= Global.littleguy_max_food_pool:
		guaranteed_poop = true


func _physics_process(delta: float) -> void:
	_handle_movement(delta)


func _handle_movement(delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = lerp(velocity, direction.normalized() * Global.littleguy_speed, slip_factor * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, slip_factor * delta)

	if (next_food_position - global_position).length() <= 1:
		collision.disabled = false
	else:
		collision.disabled = true

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

	if current_state == State.COLLECT and not food_found:
		previous_state = current_state
		current_state = State.WAIT
		collision.disabled = true
		return

	if current_state == State.COLLECT and collected:
		previous_state = current_state
		current_state = State.POOP
		collision.disabled = true
		return

	if current_state == State.POOP and not pooping:
		previous_state = current_state
		current_state = State.WAIT
		collision.disabled = true
		return

	if current_state == State.WAIT and food_found:
		previous_state = current_state
		current_state = State.COLLECT
		collision.disabled = true
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
		state_label.text = "COLLECTING"
		collecting = true
		collected = false
		next_food = _get_food()
		next_food_position = next_food.global_position
		direction = next_food_position - global_position
	elif current_state == State.POOP and not pooping:
		state_label.text = "POOPING"
		pooping = true
		direction = Vector2.ZERO
		await get_tree().create_timer(Global.poop_time).timeout
		pooping = false
		if guaranteed_poop:
			guaranteed_poops = food_pool % Global.littleguy_max_food_pool
			for i in range(guaranteed_poops):
				var poop_instance: Node = Global.poop_scene.instantiate()
				poop_instance.global_position = global_position
				poop_instance.detectable = true
				Global.poop_group.add_child(poop_instance)
			pooped = true
			guaranteed_poop = false
			guaranteed_poops = 0
			food_pool = 0
		elif randf_range(0, 1) <= Global.poop_chance:
			var poop_instance: Node = Global.poop_scene.instantiate()
			poop_instance.global_position = global_position
			poop_instance.detectable = true
			Global.poop_group.add_child(poop_instance)
			pooped = true
			guaranteed_poops = 0
			food_pool = 0


func _get_food() -> Node:
	var food: Array[Node] = get_tree().get_nodes_in_group("food")
	if food:
		return food.pick_random()
	else:
		return null


func _on_food_collected(little_guy: Node2D, _tile_coord: Vector2i) -> void:
	if little_guy == self:
		food_pool += 1
		collected = true
		collecting = false
