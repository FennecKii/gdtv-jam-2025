extends Node

signal food_collected(littleguy_area: Area2D, is_carrot: bool, tile_coord: Vector2i)
signal poop_collected
signal add_little_guy
signal farm_pressed
signal carrot_fertilized(detection: Area2D)
signal spawn_carrot(spawn_position: Vector2)
signal settings_entered
