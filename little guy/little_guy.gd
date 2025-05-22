extends CharacterBody2D

#TODO poop is the currency :)

enum State {SCAVENGE, COLLECT, EAT, POOP, TIRED}


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var direction: Vector2
var slip_factor: float = 0.5


var current_state: State
var previous_state: State


var food_collected: bool = false
var food_ate: bool = false
var poop_produced: bool = false


const SPEED = 300.0


func _ready() -> void:
	current_state = State.SCAVENGE


func _physics_process(delta: float) -> void:
	_handle_movement()


func _handle_movement() -> void:
	if direction:
		velocity = lerp(velocity, direction * SPEED, slip_factor)
	else:
		velocity = lerp(velocity, Vector2.ZERO, slip_factor)

	move_and_slide()


func _update_animation() -> void:
	if velocity:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	
	if velocity.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false


func _update_state() -> void:
	if current_state == State.SCAVENGE and randf_range(0, 1) <= 0.5:
		previous_state = current_state
		current_state = State.COLLECT
		return
	
	if current_state == State.COLLECT and food_collected:
		previous_state = current_state
		current_state = State.EAT
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
	
	if previous_state != State.TIRED and randf_range(0, 1) <= 0.1:
		previous_state = current_state
		current_state = State.TIRED
		await get_tree().create_timer(randf_range(5, 10)).timeout
		if previous_state == State.COLLECT:
			previous_state = current_state
			current_state = State.COLLECT
		elif previous_state == State.POOP:
			previous_state = current_state
			current_state = State.POOP
		elif previous_state == State.POOP:
			previous_state = current_state
			current_state = State.POOP
		elif previous_state == State.SCAVENGE:
			previous_state = current_state
			current_state = State.SCAVENGE
		return


func _update_state_action() -> void:
	if current_state == State.TIRED:
		direction = Vector2.ZERO
	elif current_state == State.SCAVENGE:
		direction = Vector2(randf_range(10, 25), randf_range(10, 25))
	elif current_state == State.COLLECT:
		direction = Global.food_position - global_position
	elif current_state == State.EAT:
		direction = Vector2.ZERO
	elif current_state == State.POOP:
		direction = Vector2.ZERO
