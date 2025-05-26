extends Node

@onready var littleguy_scene: PackedScene = preload("res://little guy/little_guy.tscn")
@onready var poop_scene: PackedScene = preload("res://poop/poop.tscn")
@onready var fry_scene: PackedScene = preload("res://food/fry/fry.tscn")
@onready var carrot_scene: PackedScene = preload("res://crop/carrot/carrot.tscn")
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
var common_carrot_amount: int = 0

# UI interaction
var cursor_interacted: bool = false
var cursor_grabbing: bool = false
var cursor_common_poop_interacted: bool = false
var cursor_common_food_interacted: bool = false
var cursor_common_carrot_interacted: bool = false
var common_poop_grabbed: bool = false
var common_food_grabbed: bool = false
var common_carrot_grabbed: bool = false

#TODO implement all the buttons and buying

# Little guy parameters
var littleguy_count: int = 1
var littleguy_speed: float = 75.0			# Little guy speed
var littleguy_max_food_pool: int = 15		# Max food little guy can eat before guaranteed poop
var poop_time: float = 10.0					# Time it takes for little guy to poop when in poop state
var poop_chance: float = 0.075				# Chance for little guy to poop when in poop state
var rest_time: float = 10.0					# Time it takes for little guy to rest when in rest state
var rest_chance: float = 0.20				# Chance for little guy to take a rest when in collect state

var poop_auto_collect: bool = false			# If poop gets auto collected
var poop_auto_collect_amount: int = 1		# Number of poops auto collected at once
var poop_auto_collect_time: float = 5.0		# Time it takes for poop to get collected

# Food parameters
var food_spawn_auto: bool = false			# If food gets auto spawned
var food_spawn_time: float = 20.0			# Time it takes for food to spawn on the map
var food_spawn_amount: int = 1				# Number of food that spawns
var carrot_spawn_auto: bool = false			# If carrot gets auto spawned 
var carrot_spawn_time: float = 20.0			# Time it takes for carrot to spawn on the map 
var carrot_spawn_amount: int = 1			# Number of carrot that spawns

# Farm parameters
var carrot_growth_time: float = 8.0			# Time for the carrot crops to grow after getting fertilized
var farm_auto_fertilize: bool = false		# If auto fertilizing is on
var farm_auto_fertilize_amount: int = 1		# Number of crops to auto fertilize
var farm_auto_fertilize_time: float = 20.0	# Time for it to auto fertilize
var farm_auto_collect: bool = false			# If auto collect carrots on the farm
var farm_auto_collect_amount: int = 1		# Number of carrot auto collected at once
var farm_auto_collect_time: float = 20.0	# Time it takes to auto collect on the farm


# Base Upgrade Costs
const littleguy_count_upgrade_cost_base: int = 0
const littleguy_speed_upgrade_cost_base: int = 0
const littleguy_max_food_pool_upgrade_cost_base: int = 0
const poop_time_upgrade_cost_base: int = 0
const poop_chance_upgrade_cost_base: int = 0
const rest_time_upgrade_cost_base: int = 0
const rest_chance_upgrade_cost_base: int = 0
const poop_auto_collect_upgrade_cost_base: int = 0
const poop_auto_collect_amount_upgrade_cost_base: int = 0
const poop_auto_collect_time_upgrade_cost_base: int = 0
const food_spawn_auto_upgrade_cost_base: int = 0
const food_spawn_time_upgrade_cost_base: int = 0
const food_spawn_amount_upgrade_cost_base: int = 0
const carrot_spawn_auto_upgrade_cost_base: int = 0
const carrot_spawn_time_upgrade_cost_base: int = 0
const carrot_spawn_amount_upgrade_cost_base: int = 0
const carrot_growth_time_upgrade_cost_base: int = 0
const farm_auto_fertilize_upgrade_cost_base: int = 0
const farm_auto_fertilize_amount_upgrade_cost_base: int = 0
const farm_auto_fertilize_time_upgrade_cost_base: int = 0
const farm_auto_collect_upgrade_cost_base: int = 0
const farm_auto_collect_amount_upgrade_cost_base: int = 0
const farm_auto_collect_time_upgrade_cost_base: int = 0


# Upgrade Costs
var littleguy_count_upgrade_cost: int = 0
var littleguy_speed_upgrade_cost: int = 0
var littleguy_max_food_pool_upgrade_cost: int = 0
var poop_time_upgrade_cost: int = 0
var poop_chance_upgrade_cost: int = 0
var rest_time_upgrade_cost: int = 0
var rest_chance_upgrade_cost: int = 0
var poop_auto_collect_upgrade_cost: int = 0
var poop_auto_collect_amount_upgrade_cost: int = 0
var poop_auto_collect_time_upgrade_cost: int = 0
var food_spawn_auto_upgrade_cost: int = 0
var food_spawn_time_upgrade_cost: int = 0
var food_spawn_amount_upgrade_cost: int = 0
var carrot_spawn_auto_upgrade_cost: int = 0
var carrot_spawn_time_upgrade_cost: int = 0
var carrot_spawn_amount_upgrade_cost: int = 0
var carrot_growth_time_upgrade_cost: int = 0
var farm_auto_fertilize_upgrade_cost: int = 0
var farm_auto_fertilize_amount_upgrade_cost: int = 0
var farm_auto_fertilize_time_upgrade_cost: int = 0
var farm_auto_collect_upgrade_cost: int = 0
var farm_auto_collect_amount_upgrade_cost: int = 0
var farm_auto_collect_time_upgrade_cost: int = 0


# Upgrade Counts
var littleguy_count_upgrade_count: int = 0
var littleguy_speed_upgrade_count: int = 0
var littleguy_max_food_pool_upgrade_count: int = 0
var poop_time_upgrade_count: int = 0
var poop_chance_upgrade_count: int = 0
var rest_time_upgrade_count: int = 0
var rest_chance_upgrade_count: int = 0
var poop_auto_collect_upgrade_count: int = 0
var poop_auto_collect_amount_upgrade_count: int = 0
var poop_auto_collect_time_upgrade_count: int = 0
var food_spawn_auto_upgrade_count: int = 0
var food_spawn_time_upgrade_count: int = 0
var food_spawn_amount_upgrade_count: int = 0
var carrot_spawn_auto_upgrade_count: int = 0
var carrot_spawn_time_upgrade_count: int = 0
var carrot_spawn_amount_upgrade_count: int = 0
var carrot_growth_time_upgrade_count: int = 0
var farm_auto_fertilize_upgrade_count: int = 0
var farm_auto_fertilize_amount_upgrade_count: int = 0
var farm_auto_fertilize_time_upgrade_count: int = 0
var farm_auto_collect_upgrade_count: int = 0
var farm_auto_collect_amount_upgrade_count: int = 0
var farm_auto_collect_time_upgrade_count: int = 0

# Upgrade Maximums
const littleguy_count_upgrade_max: int = 100
const littleguy_speed_upgrade_max: int = 7
const littleguy_max_food_pool_upgrade_max: int = 10
const poop_time_upgrade_max: int = 5
const poop_chance_upgrade_max: int = 10
const rest_time_upgrade_max: int = 5
const rest_chance_upgrade_max: int = 10
const poop_auto_collect_upgrade_max: int = 1
const poop_auto_collect_amount_upgrade_max: int = 20
const poop_auto_collect_time_upgrade_max: int = 5
const food_spawn_auto_upgrade_max: int = 1
const food_spawn_time_upgrade_max: int = 5
const food_spawn_amount_upgrade_max: int = 20
const carrot_spawn_auto_upgrade_max: int = 1
const carrot_spawn_time_upgrade_max: int = 5
const carrot_spawn_amount_upgrade_max: int = 20
const carrot_growth_time_upgrade_max: int = 5
const farm_auto_fertilize_upgrade_max: int = 1
const farm_auto_fertilize_amount_upgrade_max: int = 24
const farm_auto_fertilize_time_upgrade_max: int = 5
const farm_auto_collect_upgrade_max: int = 1
const farm_auto_collect_amount_upgrade_max: int = 24
const farm_auto_collect_time_upgrade_max: int = 5

func _ready() -> void:
	_initialized_values()


func _initialized_values() -> void:
	# Upgrade Counts
	littleguy_count_upgrade_count = 0
	littleguy_speed_upgrade_count = 0
	littleguy_max_food_pool_upgrade_count = 0
	poop_time_upgrade_count = 0
	poop_chance_upgrade_count = 0
	rest_time_upgrade_count = 0
	rest_chance_upgrade_count = 0
	poop_auto_collect_upgrade_count = 0
	poop_auto_collect_amount_upgrade_count = 0
	poop_auto_collect_time_upgrade_count = 0
	food_spawn_auto_upgrade_count = 0
	food_spawn_time_upgrade_count = 0
	food_spawn_amount_upgrade_count = 0
	carrot_spawn_auto_upgrade_count = 0
	carrot_spawn_time_upgrade_count = 0
	carrot_spawn_amount_upgrade_count = 0
	carrot_growth_time_upgrade_count = 0
	farm_auto_fertilize_upgrade_count = 0
	farm_auto_fertilize_amount_upgrade_count = 0
	farm_auto_fertilize_time_upgrade_count = 0
	farm_auto_collect_upgrade_count = 0
	
	# Upgrade Costs
	littleguy_count_upgrade_cost = littleguy_count_upgrade_cost_base
	littleguy_speed_upgrade_cost = littleguy_speed_upgrade_cost_base
	littleguy_max_food_pool_upgrade_cost = littleguy_max_food_pool_upgrade_cost_base
	poop_time_upgrade_cost = poop_time_upgrade_cost_base
	poop_chance_upgrade_cost = poop_chance_upgrade_cost_base
	rest_time_upgrade_cost = rest_time_upgrade_cost_base
	rest_chance_upgrade_cost = rest_chance_upgrade_cost_base
	poop_auto_collect_upgrade_cost = poop_auto_collect_upgrade_cost_base
	poop_auto_collect_amount_upgrade_cost = poop_auto_collect_amount_upgrade_cost_base
	poop_auto_collect_time_upgrade_cost = poop_auto_collect_time_upgrade_cost_base
	food_spawn_auto_upgrade_cost = food_spawn_auto_upgrade_cost_base
	food_spawn_time_upgrade_cost = food_spawn_time_upgrade_cost_base
	food_spawn_amount_upgrade_cost = food_spawn_amount_upgrade_cost_base
	carrot_spawn_auto_upgrade_cost = carrot_spawn_auto_upgrade_cost_base
	carrot_spawn_time_upgrade_cost = carrot_spawn_time_upgrade_cost_base
	carrot_spawn_amount_upgrade_cost = carrot_spawn_amount_upgrade_cost_base
	carrot_growth_time_upgrade_cost = carrot_growth_time_upgrade_cost_base
	farm_auto_fertilize_upgrade_cost = farm_auto_fertilize_upgrade_cost_base
	farm_auto_fertilize_amount_upgrade_cost = farm_auto_fertilize_amount_upgrade_cost_base
	farm_auto_fertilize_time_upgrade_cost = farm_auto_fertilize_time_upgrade_cost_base
	farm_auto_collect_upgrade_cost = farm_auto_collect_upgrade_cost_base
	farm_auto_collect_amount_upgrade_cost = farm_auto_collect_amount_upgrade_cost_base
	farm_auto_collect_time_upgrade_cost = farm_auto_collect_time_upgrade_cost_base

 
func play_squash_stretch(object: Node):
	var tween = create_tween()
	tween.tween_property(object, "scale", Vector2(0.8, 1.3), 0.15)
	tween.tween_property(object, "scale", Vector2(1.1, 0.8), 0.1)
	tween.tween_property(object, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BOUNCE)
