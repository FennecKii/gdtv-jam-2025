extends Node2D

@export var carrot_crops_node: Node2D
@export var dirt_tilemap_layer: TileMapLayer
@export var y_sort_node: Node2D
@onready var carrots_node: Node2D = $"Y-sort/Carrots"


var dirt_tiles: Array[Vector2i]
var carrot_crop_instances: Array[CarrotCrop] = []
var carrot_instances: Array[Node] = []


@onready var fertilize_all_timer: Timer = $FertilizeAllTimer
@onready var fertilize_all_button: Button = $"Panel/Fertilize All"
@onready var auto_fertilize_timer: Timer = $AutoFertilizeTimer
@onready var auto_collect_timer: Timer = $AutoCollectTimer
@onready var panel: Panel = $Panel
@onready var border_layer: TileMapLayer = $"Y-sort/Border Layer"
@onready var dirt_layer: TileMapLayer = $"Y-sort/Dirt Layer"
@onready var carrot_crops: Node2D = $"Y-sort/Carrot Crops"


func _ready() -> void:
	SignalBus.farm_pressed.connect(_on_farm_pressed)
	SignalBus.spawn_carrot.connect(_on_spawn_carrot)
	dirt_tiles = dirt_tilemap_layer.get_used_cells()
	for tile in dirt_tiles:
		var tile_position = dirt_tilemap_layer.to_global(dirt_tilemap_layer.map_to_local(tile))
		_spawn_carrot_crop(tile_position)


func _process(_delta: float) -> void:
	fertilize_all_timer.wait_time = Global.carrot_growth_time
	auto_fertilize_timer.wait_time = Global.farm_auto_fertilize_time
	auto_collect_timer.wait_time = Global.farm_auto_collect_time
	carrot_instances = carrots_node.get_children()
	
	if not fertilize_all_timer.is_stopped():
		fertilize_all_button.disabled = true
	elif fertilize_all_timer.is_stopped():
		fertilize_all_button.disabled = false
	
	if Global.farm_auto_fertilize and Global.common_poops_collected >= 0 and auto_fertilize_timer.is_stopped():
		auto_fertilize_timer.start()
		for i in range(min(Global.farm_auto_fertilize_amount, Global.common_poops_collected)):
			var carrot_crop = carrot_crop_instances.pick_random()
			carrot_crop.grow_carrot()
			Global.common_poops_collected -= 1
	
	if Global.farm_auto_collect and len(carrot_instances) > 0 and auto_collect_timer.is_stopped():
		auto_collect_timer.start()
		for i in range(min(len(carrot_instances), Global.farm_auto_collect_amount)):
			var carrot: Node = carrot_instances.pick_random()
			carrot.queue_free()
			Global.common_carrot_amount += 1

func _spawn_carrot_crop(crop_position: Vector2) -> void:
	var carrot_crop_instance: CarrotCrop = Global.carrot_crop_scene.instantiate()
	carrot_crop_instance.global_position = crop_position
	carrot_crop_instances.append(carrot_crop_instance)
	carrot_crops_node.add_child(carrot_crop_instance)
	Global.play_squash_stretch(carrot_crop_instance)


func _on_farm_pressed() -> void:
	if visible == false:
		border_layer.scale = Vector2.ZERO
		dirt_layer.scale = Vector2.ZERO
		carrot_crops.scale = Vector2.ZERO
		var tween: Tween = create_tween().parallel()
		tween.tween_property(border_layer, "scale", Vector2.ONE, 0.225).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(dirt_layer, "scale", Vector2.ONE, 0.225).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(carrot_crops, "scale", Vector2.ONE, 0.225).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		visible = true
	elif visible == true:
		visible = false


func _on_spawn_carrot(spawn_position: Vector2) -> void:
	_spawn_carrot(spawn_position)


func _spawn_carrot(spawn_position) -> void:
	var carrot_instance: Node = Global.carrot_scene.instantiate()
	var rand_angle: float = randf_range(0, 2*PI)
	carrot_instance.global_position = spawn_position + Vector2(2*4*cos(rand_angle), 4*sin(rand_angle))
	Global.play_squash_stretch(carrot_instance)
	carrots_node.add_child(carrot_instance)


func _on_fertilize_all_pressed() -> void:
	if Global.common_poops_collected >= 30:
		fertilize_all_timer.start()
		for carrot_crop in carrot_crop_instances:
			carrot_crop.grow_carrot()
		Global.common_poops_collected -= 30
