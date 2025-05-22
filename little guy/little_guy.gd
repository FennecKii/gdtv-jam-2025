extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2
var slip_factor: float = 0.5

const SPEED = 300.0

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
