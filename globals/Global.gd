extends Node

@onready var littleguy_scene: PackedScene = preload("res://little guy/little_guy.tscn")
@onready var poop_scene: PackedScene = preload("res://poop/poop.tscn")
@onready var fry_scene: PackedScene = preload("res://food/fry/fry.tscn")
@onready var carrot_crop_scene: PackedScene = preload("res://crop/carrot/carrot_tile.tscn")


const tileset_soft_collision_source_id: int = 0
const tileset_soft_ground_source_id: int = 1
const tileset_soft_ground_atlas_size: Vector2i = Vector2i(7, 1)

const tileset_vibrant_collision_source_id: int = 2
const tileset_vibrant_ground_source_id: int = 3
const tileset_vibrant_ground_atlas_size: Vector2i = Vector2i(7, 1)

var food_position: Vector2
var poop_group: Node2D
var poop_detection_area: Area2D
var food_group: Node2D

var common_poops_collected: int = 0
var common_food_amount: float = INF

# UI interaction
var cursor_interacted: bool = false
var cursor_grabbing: bool = false
var cursor_common_poop_interacted: bool = false
var cursor_common_food_interacted: bool = false
var common_poop_grabbed: bool = false
var common_food_grabbed: bool = false

#TODO implement all the buttons and buying

# Little guy parameters
var littleguy_count: int = 1
var littleguy_speed: float = 75.0			# Little guy speed
var littleguy_max_food_pool: int = 15		# Max food little guy can eat before guaranteed poop
var poop_time: float = 7					# Time it takes for little guy to poop when in poop state
var poop_chance: float = 0.075				# Chance for little guy to poop when in poop state
var poop_drag_mouse_collect: bool = false	# If poop can be collected by dragging mouse over poop #TODO implement
var poop_auto_collect: bool = false			# If poop gets auto collected #TODO implement
var poop_auto_collect_time: float = 10		# Time it takes for poop to get collected #TODO implement
var rest_time: float = 9					# Time it takes for little guy to rest when in rest state
var rest_chance: float = 0.20				# Chance for little guy to take a rest when in collect state

# Fry parameters
var food_spawn_auto: bool = false		# If food gets auto spawned #TODO implement 
var food_spawn_time: float = 20.0		# Time it takes for food to spawn on the map
var food_spawn_amount: int = 1			# Number of food that spawns

func play_squash_stretch(object: Node):
	var tween = create_tween()
	
	# Scale up vertically (stretch)
	tween.tween_property(object, "scale", Vector2(0.8, 1.3), 0.15)
	
	# Squash horizontally when hitting "ground"
	tween.tween_property(object, "scale", Vector2(1.1, 0.8), 0.1)
	
	# Return to normal
	tween.tween_property(object, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BOUNCE)
