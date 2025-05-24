extends Node

@onready var littleguy_scene: PackedScene = preload("res://little guy/little_guy.tscn")
@onready var poop_scene: PackedScene = preload("res://poop/poop.tscn")
@onready var fry_scene: PackedScene = preload("res://food/fry/fry.tscn")

const tileset_soft_collision_source_id: int = 0
const tileset_soft_ground_source_id: int = 1
const tileset_soft_ground_atlas_size: Vector2i = Vector2i(7, 1)

const tileset_vibrant_collision_source_id: int = 2
const tileset_vibrant_ground_source_id: int = 3
const tileset_vibrant_ground_atlas_size: Vector2i = Vector2i(7, 1)

var food_position: Vector2
var poop_group: Node2D
var food_group: Node2D

var poops_collected: int = 0
var crops_collected: int = 0

# UI interaction
var cursor_interacted: bool = false
var cursor_grabbing: bool = false
var cursor_poop_interacted: bool = false
var poop_grabbed: bool = false

# Little guy parameters
var littleguy_count: int = 1
var littleguy_speed: float = 25.0	# Little guy speed
var poop_time: float = 7			# Average time it takes for little guy to poop when in poop state
var poop_chance: float = 0.05		# Chance for little guy to poop when in poop state
var rest_time: float = 7			# Average time it takes for little guy to rest when in rest state
var rest_chance: float = 0.25		# Chance for little guy to take a rest when in collect state

# Fry parameters
var food_spawn_time: float = 10.0					# Average time it takes for food to spawn on the map
var food_spawn_amount: int = 1				# Number of food that spawns
