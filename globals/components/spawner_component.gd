class_name SpawnerComponent
extends Node2D

@export var tilemap_layer_ground: TileMapLayer
@export var littleguy_group: Node2D
@export var food_group: Node2D

var tilemap_coords: Array[Vector2i]
var food_pool: Array[Vector2i]


func _ready() -> void:
	if tilemap_layer_ground:
		tilemap_coords = tilemap_layer_ground.get_used_cells()
	else:
		assert(tilemap_layer_ground, "%s not found." %tilemap_layer_ground)
	assert(food_group, "%s not found." %food_group)

	SignalBus.food_collected.connect(_on_food_collected)


func _process(delta: float) -> void:
	pass


func _food_pool_remove(tile_coord: Vector2i) -> void:
	if not food_pool.has(tile_coord):
		return
	else:
		food_pool.erase(tile_coord)


func _on_food_collected(tile_coord: Vector2i) -> void:
	_food_pool_remove(tile_coord)


func spawn_food() -> void:
	var spawn_coord: Vector2i = tilemap_coords.pick_random()
	while food_pool.has(spawn_coord) == true:
		spawn_coord = tilemap_coords.pick_random()
	if food_pool.has(spawn_coord) == false:
		food_pool.append(spawn_coord)
		var spawn_position: Vector2 = tilemap_layer_ground.to_global(tilemap_layer_ground.map_to_local(spawn_coord))
		var food_instance: Node2D = Global.fry_scene.instantiate()
		food_instance.global_position = spawn_position
		food_instance.tile_coord = spawn_coord
		food_group.add_child(food_instance)
		tilemap_layer_ground.set_cell(spawn_coord, Global.tileset_soft_ground_source_id, Vector2i(randi_range(0, Global.tileset_soft_ground_atlas_size.x), randi_range(0, Global.tileset_soft_ground_atlas_size.y)))

func spawn_littleguy() -> void:
	var littleguy_instance: Node2D = Global.littleguy_scene.instantiate()
	littleguy_instance.global_position = Vector2.ZERO + Vector2(2 * 20 * cos(randf_range(0, 2*PI)), 20 * sin(randf_range(0, 2*PI)))
	littleguy_group.add_child(littleguy_instance)
