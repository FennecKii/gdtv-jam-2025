extends Sprite2D

var mouse_accel: float = 20
var click_rotation: float = -200
var click_scale: Vector2 = Vector2(0.0075, 0.0075)
var default_scale: Vector2 = Vector2(0.5, 0.5)


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), mouse_accel * delta)

	if not Global.cursor_interacted and not Global.cursor_grabbing:
		_update_cursor_default(delta)
	elif Global.cursor_grabbing:
		frame = 2
	elif Global.cursor_interacted:
		_update_cursor_interacted(delta)


func _update_cursor_default(delta: float) -> void:
	frame = 0
	if Input.is_action_just_pressed("Click"):
		scale = lerp(scale, click_scale, mouse_accel * delta)
		rotation_degrees = lerp(rotation_degrees, click_rotation, mouse_accel * delta)
	else:
		scale = lerp(scale, default_scale, mouse_accel * delta)
		rotation_degrees = lerp(rotation_degrees, 0.0, mouse_accel * delta)


func _update_cursor_interacted(delta: float) -> void:
	if Input.is_action_pressed("Click"):
		Global.cursor_grabbing = true
		frame = 2
	else:
		frame = 1
