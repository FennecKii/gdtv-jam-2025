extends CharacterBody2D

#TODO poop is the currency :)

enum State {
	SCAVENGE,
	COLLECT,
	EAT,
	POOP,
	TIRED,
}

const SPEED = 100.0

var direction: Vector2
var next_food_position: Vector2
var slip_factor: float = 1 #upgrade: little guy slides into consecutive foods ("piercing upgrade", the lower the more slip)

var current_state: State
var previous_state: State

var determining_state: bool = false
var tracking_food: bool = false
var food_collected: bool = true
var food_ate: bool = false
var poop_produced: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_label: Label = $State
@onready var collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	current_state = State.SCAVENGE
	Global.little_guy_node = self
	SignalBus.food_collected.connect(_on_food_collected)


func _process(delta: float) -> void:
	#_update_state_action()
	#_update_state()

	if food_collected:
		direction = Vector2.ZERO
		food_collected = false
		await get_tree().create_timer(randf_range(1, 3)).timeout
		next_food_position = _get_food().global_position
		direction = (next_food_position - global_position).normalized()


func _physics_process(delta: float) -> void:
	_handle_movement()


func _handle_movement() -> void:
	if direction != Vector2.ZERO:
		velocity = lerp(velocity, direction * SPEED, slip_factor)
	else:
		velocity = lerp(velocity, Vector2.ZERO, slip_factor)
	
	if (next_food_position - global_position).length() <= 5:
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


func _update_state() -> void:
	if previous_state != State.TIRED and randf_range(0, 1) <= 0.5:
		previous_state = current_state
		current_state = State.TIRED

	if current_state == State.SCAVENGE and randf_range(0, 1) <= 0.5:
		previous_state = current_state
		current_state = State.COLLECT
		food_collected = false
		return

	if current_state == State.COLLECT and food_collected:
		previous_state = current_state
		current_state = State.SCAVENGE
		poop_produced = false
		return

	if current_state == State.EAT and food_ate:
		previous_state = current_state
		current_state = State.POOP
		food_collected = false
		return

	if current_state == State.POOP and poop_produced:
		previous_state = current_state
		current_state = State.SCAVENGE
		food_ate = false
		return


func _update_state_action() -> void:
	if not determining_state:
		return
	if current_state == State.TIRED:
		direction = Vector2.ZERO
		state_label.text = "RESTING"
		await get_tree().create_timer(randf_range(5, 10)).timeout
		current_state = previous_state
		previous_state = State.TIRED
	elif current_state == State.SCAVENGE:
		direction = Vector2(randf_range(10, 25), randf_range(10, 25))
		state_label.text = "SCAVENGING"
	elif current_state == State.COLLECT:
		direction = (_get_food().global_position - global_position).normalized()
		state_label.text = "COLLECTING"
	elif current_state == State.EAT:
		direction = Vector2.ZERO
		state_label.text = "EATING"
	elif current_state == State.POOP:
		direction = Vector2.ZERO
		state_label.text = "POOPING"


func _get_food() -> Node:
	var food: Array[Node] = get_tree().get_nodes_in_group("food")
	if food:
		return food.pick_random()
	else:
		return self


func _on_food_collected(tile_coord: Vector2i) -> void:
	food_collected = true
	if randf_range(0, 1) <= 0.5:
		var poop_instance: Node = Global.poop_scene.instantiate()
		poop_instance.global_position = global_position
		Global.poop_group.add_child(poop_instance)
