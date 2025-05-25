extends Node2D

@export var carrot_crops_node: Node2D
@export var dirt_tilemap_layer: TileMapLayer
@export var y_sort_node: Node2D


var dirt_tiles: Array[Vector2i]

func _ready() -> void:
	SignalBus.farm_pressed.connect(_on_farm_pressed)
	SignalBus.spawn_carrot.connect(_on_spawn_carrot)
	dirt_tiles = dirt_tilemap_layer.get_used_cells()
	for tile in dirt_tiles:
		var tile_position = dirt_tilemap_layer.to_global(dirt_tilemap_layer.map_to_local(tile))
		_spawn_carrot_crop(tile_position)


func _spawn_carrot_crop(crop_position: Vector2) -> void:
	var carrot_crop_instance: Node = Global.carrot_crop_scene.instantiate()
	carrot_crop_instance.global_position = crop_position
	carrot_crops_node.add_child(carrot_crop_instance)
	Global.play_squash_stretch(carrot_crop_instance)


func _on_farm_pressed() -> void:
	visible = !visible


func _on_spawn_carrot(spawn_position: Vector2) -> void:
	_spawn_carrot(spawn_position)


func _spawn_carrot(spawn_position) -> void:
	var carrot_instance: Node = Global.carrot_scene.instantiate()
	carrot_instance.global_position = spawn_position
	y_sort_node.add_child(carrot_instance)
