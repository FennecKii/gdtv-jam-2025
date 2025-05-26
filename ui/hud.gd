extends Control

# Data Labels
@onready var add_little_guy_data_label: Label = %"Add Little Guy Data Label"
@onready var little_guy_speed_data_label: Label = %"Little Guy Speed Data Label"
@onready var little_guy_threshold_data_label: Label = %"Little Guy Threshold Data Label"
@onready var little_guy_poop_chance_data_label: Label = %"Little Guy Poop Chance Data Label"
@onready var little_guy_poop_time_data_label: Label = %"Little Guy Poop Time Data Label"
@onready var little_guy_rest_chance_data_label: Label = %"Little Guy Rest Chance Data Label"
@onready var little_guy_rest_time_data_label: Label = %"Little Guy Rest Time Data Label"
@onready var auto_feed_fries_data_label: Label = %"Auto Feed Fries Data Label"
@onready var feed_fries_amount_data_label: Label = %"Feed Fries Amount Data Label"
@onready var feed_fries_time_data_label: Label = %"Feed Fries Time Data Label"
@onready var auto_feed_carrot_data_label: Label = %"Auto Feed Carrot Data Label"
@onready var feed_carrot_amount_data_label: Label = %"Feed Carrot Amount Data Label"
@onready var feed_carrot_time_data_label: Label = %"Feed Carrot Time Data Label"
@onready var auto_collect_poop_data_label: Label = %"Auto Collect Poop Data Label"
@onready var collect_poop_amount_data_label: Label = %"Collect Poop Amount Data Label"
@onready var collect_poop_time_data_label: Label = %"Collect Poop Time Data Label"
@onready var auto_collect_carrot_data_label: Label = %"Auto Collect Carrot Data Label"
@onready var collect_carrot_amount_data_label: Label = %"Collect Carrot Amount Data Label"
@onready var collect_carrot_time_data_label: Label = %"Collect Carrot Time Data Label"
@onready var auto_fertilize_data_label: Label = %"Auto Fertilize Data Label"
@onready var fertilize_amount_data_label: Label = %"Fertilize Amount Data Label"
@onready var fertilize_time_data_label: Label = %"Fertilize Time Data Label"
@onready var carrot_growth_time_data_label: Label = %"Carrot Growth Time Data Label"


# Upgrade Buttons
@onready var add_little_guy: Button = %"Add Little Guy"
@onready var increase_little_guy_speed: Button = %"Increase Little Guy Speed"
@onready var food_threshold: Button = %"Food Threshold"
@onready var increase_poop_chance: Button = %"Increase Poop Chance"
@onready var decrease_poop_time: Button = %"Decrease Poop Time"
@onready var decrease_rest_chance: Button = %"Decrease Rest Chance"
@onready var decrease_rest_time: Button = %"Decrease Rest Time"
@onready var auto_feed_fries: Button = %"Auto Feed Fries"
@onready var increase_food_spawn_amount: Button = %"Increase Food Spawn Amount"
@onready var decrease_food_spawn_time: Button = %"Decrease Food Spawn Time"
@onready var auto_feed_carrot: Button = %"Auto Feed Carrot"
@onready var auto_feed_carrot_amount: Button = %"Auto Feed Carrot Amount"
@onready var auto_feed_carrot_time: Button = %"Auto Feed Carrot Time"
@onready var auto_collect_poop: Button = %"Auto Collect Poop"
@onready var auto_collect_poop_amount: Button = %"Auto Collect Poop Amount"
@onready var auto_collect_poop_time: Button = %"Auto Collect Poop Time"
@onready var auto_collect_carrot: Button = %"Auto Collect Carrot"
@onready var auto_collect_carrot_amount: Button = %"Auto Collect Carrot Amount"
@onready var auto_collect_carrot_time: Button = %"Auto Collect Carrot Time"
@onready var auto_fertilize: Button = %"Auto Fertilize"
@onready var auto_fertilize_amount: Button = %"Auto Fertilize Amount"
@onready var auto_fertilize_time: Button = %"Auto Fertilize Time"
@onready var carrot_growth_time: Button = %"Carrot Growth Time"


@onready var common_poops_label: Label = %Poops
@onready var golden_poops_label: Label = %GoldenPoops
@onready var common_foods_label: Label = %Foods
@onready var common_carrots_label: Label = %Carrot
@onready var upgrades_panel: Panel = $Panel
@onready var hide_upgrades_button: Button = %"Hide Upgrades"

@onready var upgrades_panel_down_position: Vector2 = Vector2(upgrades_panel.position.x, upgrades_panel.position.y + upgrades_panel.size.y)
@onready var upgrades_panel_up_position: Vector2 = upgrades_panel.position

var upgrades_panel_down: bool = false

func _ready() -> void:
	_on_hide_upgrades_pressed()
	SignalBus.poop_collected.connect(_on_poop_connected)
	common_foods_label.text = str(": %s" %Global.common_food_amount)
	common_poops_label.text = str(": %s" %Global.common_poops_collected)
	common_carrots_label.text = str(": %s" %Global.common_carrot_amount)
	golden_poops_label.text = str(": %s" %Global.golden_poops_collected)


func _process(_delta: float) -> void:
	common_foods_label.text = str(": %s" %Global.common_food_amount)
	common_poops_label.text = str(": %s" %Global.common_poops_collected)
	common_carrots_label.text = str(": %s" %Global.common_carrot_amount)
	golden_poops_label.text = str(": %s" %Global.golden_poops_collected)

	_update_labels()
	_update_label_colors()


func _on_poop_connected() -> void:
	common_poops_label.text = str(": %s" %Global.common_poops_collected)


func _on_hide_upgrades_pressed() -> void:
	var tween: Tween = create_tween()
	if not upgrades_panel_down:
		tween.tween_property(upgrades_panel, "position", upgrades_panel_down_position, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		upgrades_panel_down = true
		hide_upgrades_button.text = "Show Upgrades"
	elif upgrades_panel_down:
		tween.tween_property(upgrades_panel, "position", upgrades_panel_up_position, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
		upgrades_panel_down = false
		hide_upgrades_button.text = "Hide Upgrades"


func _on_farm_pressed() -> void:
	SignalBus.farm_pressed.emit()


func _on_mouse_interaction_entered() -> void:
	Global.cursor_interacted = true 


func _on_mouse_interaction_exited() -> void:
	Global.cursor_interacted = false


func _on_common_poop_mouse_entered() -> void:
	Global.cursor_common_poop_interacted = true


func _on_common_food_mouse_entered() -> void:
	Global.cursor_common_food_interacted = true


func _on_common_poop_mouse_exited() -> void:
	Global.cursor_common_poop_interacted = false


func _on_common_food_mouse_exited() -> void:
	Global.cursor_common_food_interacted = false


func _on_common_carrot_mouse_entered() -> void:
	Global.cursor_common_carrot_interacted = true


func _on_common_carrot_mouse_exited() -> void:
	Global.cursor_common_carrot_interacted = false


func _update_labels() -> void:
	# Data Labels
	add_little_guy_data_label.text = str(Global.littleguy_count_upgrade_count, "/", Global.littleguy_count_upgrade_max, "  |  ", Global.littleguy_count)
	little_guy_speed_data_label.text = str(Global.littleguy_speed_upgrade_count, "/", Global.littleguy_speed_upgrade_max, "  |  ", Global.littleguy_speed/100)
	little_guy_threshold_data_label.text = str(Global.littleguy_max_food_pool_upgrade_count, "/", Global.littleguy_max_food_pool_upgrade_max, "  |  ", Global.littleguy_max_food_pool)
	little_guy_poop_chance_data_label.text = str(Global.poop_chance_upgrade_count, "/", Global.poop_chance_upgrade_max, "  |  ", "%.2f" %Global.poop_chance)
	little_guy_poop_time_data_label.text = str(Global.poop_time_upgrade_count, "/", Global.poop_time_upgrade_max, "  |  ", "%.2f" %Global.poop_time, "s")
	little_guy_rest_chance_data_label.text = str(Global.rest_chance_upgrade_count, "/", Global.rest_chance_upgrade_max, "  |  ", "%.2f" %Global.rest_chance)
	little_guy_rest_time_data_label.text = str(Global.rest_time_upgrade_count, "/", Global.rest_time_upgrade_max, "  |  ", "%.2f" %Global.rest_time, "s")
	auto_feed_fries_data_label.text = str(Global.food_spawn_auto_upgrade_count, "/", Global.food_spawn_auto_upgrade_max, "  |  ", Global.food_spawn_auto)
	feed_fries_amount_data_label.text = str(Global.food_spawn_amount_upgrade_count, "/", Global.food_spawn_amount_upgrade_max, "  |  ", Global.food_spawn_amount)
	feed_fries_time_data_label.text = str(Global.food_spawn_time_upgrade_count, "/", Global.food_spawn_time_upgrade_max, "  |  ", "%.2f" %Global.food_spawn_time, "s")
	auto_feed_carrot_data_label.text = str(Global.carrot_spawn_auto_upgrade_count, "/", Global.carrot_spawn_auto_upgrade_max, "  |  ", Global.carrot_spawn_auto)
	feed_carrot_amount_data_label.text = str(Global.carrot_spawn_amount_upgrade_count, "/", Global.carrot_spawn_amount_upgrade_max, "  |  ", Global.carrot_spawn_amount)
	feed_carrot_time_data_label.text = str(Global.carrot_spawn_time_upgrade_count, "/", Global.carrot_spawn_time_upgrade_max, "  |  ", "%.2f" %Global.carrot_spawn_time, "s")
	auto_collect_poop_data_label.text = str(Global.poop_auto_collect_upgrade_count, "/", Global.poop_auto_collect_upgrade_max, "  |  ", Global.poop_auto_collect)
	collect_poop_amount_data_label.text = str(Global.poop_auto_collect_amount_upgrade_count, "/", Global.poop_auto_collect_amount_upgrade_max, "  |  ", Global.poop_auto_collect_amount)
	collect_poop_time_data_label.text = str(Global.poop_auto_collect_time_upgrade_count, "/", Global.poop_auto_collect_time_upgrade_max, "  |  ", "%.2f" %Global.poop_auto_collect_time, "s")
	auto_collect_carrot_data_label.text = str(Global.farm_auto_collect_upgrade_count, "/", Global.farm_auto_collect_upgrade_max, "  |  ", Global.farm_auto_collect)
	collect_carrot_amount_data_label.text = str(Global.farm_auto_collect_amount_upgrade_count, "/", Global.farm_auto_collect_amount_upgrade_max, "  |  ", Global.farm_auto_collect_amount)
	collect_carrot_time_data_label.text = str(Global.farm_auto_collect_time_upgrade_count, "/", Global.farm_auto_collect_time_upgrade_max, "  |  ", "%.2f" %Global.farm_auto_collect_time, "s")
	auto_fertilize_data_label.text = str(Global.farm_auto_fertilize_upgrade_count, "/", Global.farm_auto_fertilize_upgrade_max, "  |  ", Global.farm_auto_fertilize)
	fertilize_amount_data_label.text = str(Global.farm_auto_fertilize_amount_upgrade_count, "/", Global.farm_auto_fertilize_amount_upgrade_max, "  |  ", Global.farm_auto_fertilize_amount)
	fertilize_time_data_label.text = str(Global.farm_auto_fertilize_time_upgrade_count, "/", Global.farm_auto_fertilize_time_upgrade_max, "  |  ", "%.2f" %Global.farm_auto_fertilize_time, "s")
	carrot_growth_time_data_label.text = str(Global.carrot_growth_time_upgrade_count, "/", Global.carrot_growth_time_upgrade_max, "  |  ", "%.2f" %Global.carrot_growth_time, "s")
	
	# Button Texts
	add_little_guy.text = str("Little Guy +1\n", "Cost: ", Global.littleguy_count_upgrade_cost)
	increase_little_guy_speed.text = str("Little Guy Speed\n", "Cost: ", Global.littleguy_speed_upgrade_cost)
	food_threshold.text = str("Food Threshold\n", "Cost: ", Global.littleguy_max_food_pool_upgrade_cost)
	increase_poop_chance.text = str("Poop Chance\n", "Cost: ", Global.poop_chance_upgrade_cost)
	decrease_poop_time.text = str("Poop Timer\n", "Cost: ", Global.poop_time_upgrade_cost)
	decrease_rest_chance.text = str("Rest Chance\n", "Cost: ", Global.rest_chance_upgrade_cost)
	decrease_rest_time.text = str("Rest Timer\n", "Cost: ", Global.rest_time_upgrade_cost)
	auto_feed_fries.text = str("Auto Spawn Fries\n", "Cost: ", Global.food_spawn_auto_upgrade_cost)
	increase_food_spawn_amount.text = str("Spawn Fries +1\n", "Cost: ", Global.food_spawn_amount_upgrade_cost)
	decrease_food_spawn_time.text = str("Spawn Fries Timer\n", "Cost: ", Global.food_spawn_time_upgrade_cost)
	auto_feed_carrot.text = str("Auto Spawn Carrots\n", "Cost: ", Global.carrot_spawn_auto_upgrade_cost)
	auto_feed_carrot_amount.text = str("Spawn Carrot +1\n", "Cost: ", Global.carrot_spawn_amount_upgrade_cost)
	auto_feed_carrot_time.text = str("Spawn Carrot Timer\n", "Cost: ", Global.carrot_spawn_time_upgrade_cost)
	auto_collect_poop.text = str("Auto Collect Poop\n", "Cost: ", Global.poop_auto_collect_upgrade_cost)
	auto_collect_poop_amount.text = str("Collect Poop +1\n", "Cost: ", Global.poop_auto_collect_amount_upgrade_cost)
	auto_collect_poop_time.text = str("Collect Poop Timer\n", "Cost: ", Global.poop_auto_collect_time_upgrade_cost)
	auto_collect_carrot.text = str("Auto Collect Carrot\n", "Cost: ", Global.farm_auto_collect_upgrade_cost)
	auto_collect_carrot_amount.text = str("Collect Carrot +1\n", "Cost: ", Global.farm_auto_collect_amount_upgrade_cost)
	auto_collect_carrot_time.text = str("Collect Carrot Timer\n", "Cost: ", Global.farm_auto_collect_time_upgrade_cost)
	auto_fertilize.text = str("Auto Fertilize\n", "Cost: ", Global.farm_auto_fertilize_upgrade_cost)
	auto_fertilize_amount.text = str("Auto Fertilize +1\n", "Cost: ", Global.farm_auto_fertilize_amount_upgrade_cost)
	auto_fertilize_time.text = str("Auto Fertilize Timer\n", "Cost: ", Global.farm_auto_fertilize_time_upgrade_cost)
	carrot_growth_time.text = str("Carrot Growth Timer\n", "Cost: ", Global.carrot_growth_time_upgrade_cost)

func _update_label_colors() -> void:
	# Button Color
	if add_little_guy.disabled:
		add_little_guy.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.littleguy_count_upgrade_cost:
		add_little_guy.self_modulate = Color.GREEN
	else:
		add_little_guy.self_modulate = Color.INDIAN_RED
	
	if increase_little_guy_speed.disabled:
		increase_little_guy_speed.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.littleguy_speed_upgrade_cost:
		increase_little_guy_speed.self_modulate = Color.GREEN
	else:
		increase_little_guy_speed.self_modulate = Color.INDIAN_RED
	
	if food_threshold.disabled:
		food_threshold.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.littleguy_max_food_pool_upgrade_cost:
		food_threshold.self_modulate = Color.GREEN
	else:
		food_threshold.self_modulate = Color.INDIAN_RED
	
	if increase_poop_chance.disabled:
		increase_poop_chance.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.poop_chance_upgrade_cost:
		increase_poop_chance.self_modulate = Color.GREEN
	else:
		increase_poop_chance.self_modulate = Color.INDIAN_RED
	
	if decrease_poop_time.disabled:
		decrease_poop_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.poop_time_upgrade_cost:
		decrease_poop_time.self_modulate = Color.GREEN
	else:
		decrease_poop_time.self_modulate = Color.INDIAN_RED
	
	if decrease_rest_chance.disabled:
		decrease_rest_chance.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.rest_chance_upgrade_cost:
		decrease_rest_chance.self_modulate = Color.GREEN
	else:
		decrease_rest_chance.self_modulate = Color.INDIAN_RED
	
	if decrease_rest_time.disabled:
		decrease_rest_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.rest_time_upgrade_cost:
		decrease_rest_time.self_modulate = Color.GREEN
	else:
		decrease_rest_time.self_modulate = Color.INDIAN_RED
	
	if auto_feed_fries.disabled:
		auto_feed_fries.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.food_spawn_auto_upgrade_cost:
		auto_feed_fries.self_modulate = Color.GREEN
	else:
		auto_feed_fries.self_modulate = Color.INDIAN_RED
	
	if increase_food_spawn_amount.disabled:
		increase_food_spawn_amount.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.food_spawn_amount_upgrade_cost:
		increase_food_spawn_amount.self_modulate = Color.GREEN
	else:
		increase_food_spawn_amount.self_modulate = Color.INDIAN_RED
	
	if decrease_food_spawn_time.disabled:
		decrease_food_spawn_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.food_spawn_time_upgrade_cost:
		decrease_food_spawn_time.self_modulate = Color.GREEN
	else:
		decrease_food_spawn_time.self_modulate = Color.INDIAN_RED
	
	if auto_feed_carrot.disabled:
		auto_feed_carrot.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.carrot_spawn_auto_upgrade_cost:
		auto_feed_carrot.self_modulate = Color.GREEN
	else:
		auto_feed_carrot.self_modulate = Color.INDIAN_RED
	
	if auto_feed_carrot_amount.disabled:
		auto_feed_carrot_amount.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.carrot_spawn_amount_upgrade_cost:
		auto_feed_carrot_amount.self_modulate = Color.GREEN
	else:
		auto_feed_carrot_amount.self_modulate = Color.INDIAN_RED
	
	if auto_feed_carrot_time.disabled:
		auto_feed_carrot_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.carrot_spawn_time_upgrade_cost:
		auto_feed_carrot_time.self_modulate = Color.GREEN
	else:
		auto_feed_carrot_time.self_modulate = Color.INDIAN_RED
	
	if auto_collect_poop.disabled:
		auto_collect_poop.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.poop_auto_collect_upgrade_cost:
		auto_collect_poop.self_modulate = Color.GREEN
	else:
		auto_collect_poop.self_modulate = Color.INDIAN_RED
	
	if auto_collect_poop_amount.disabled:
		auto_collect_poop_amount.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.poop_auto_collect_amount_upgrade_cost:
		auto_collect_poop_amount.self_modulate = Color.GREEN
	else:
		auto_collect_poop_amount.self_modulate = Color.INDIAN_RED
	
	if auto_collect_poop_time.disabled:
		auto_collect_poop_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.poop_auto_collect_time_upgrade_cost:
		auto_collect_poop_time.self_modulate = Color.GREEN
	else:
		auto_collect_poop_time.self_modulate = Color.INDIAN_RED
	
	if auto_collect_carrot.disabled:
		auto_collect_carrot.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.farm_auto_collect_upgrade_cost:
		auto_collect_carrot.self_modulate = Color.GREEN
	else:
		auto_collect_carrot.self_modulate = Color.INDIAN_RED
	
	if auto_collect_carrot_amount.disabled:
		auto_collect_carrot_amount.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.farm_auto_collect_amount_upgrade_cost:
		auto_collect_carrot_amount.self_modulate = Color.GREEN
	else:
		auto_collect_carrot_amount.self_modulate = Color.INDIAN_RED
	
	if auto_collect_carrot_time.disabled:
		auto_collect_carrot_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.farm_auto_collect_time_upgrade_cost:
		auto_collect_carrot_time.self_modulate = Color.GREEN
	else:
		auto_collect_carrot_time.self_modulate = Color.INDIAN_RED
	
	if auto_fertilize.disabled:
		auto_fertilize.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.farm_auto_fertilize_upgrade_cost:
		auto_fertilize.self_modulate = Color.GREEN
	else:
		auto_fertilize.self_modulate = Color.INDIAN_RED
	
	if auto_fertilize_amount.disabled:
		auto_fertilize_amount.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.farm_auto_fertilize_amount_upgrade_cost:
		auto_fertilize_amount.self_modulate = Color.GREEN
	else:
		auto_fertilize_amount.self_modulate = Color.INDIAN_RED
	
	if auto_fertilize_time.disabled:
		auto_fertilize_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.farm_auto_fertilize_time_upgrade_cost:
		auto_fertilize_time.self_modulate = Color.GREEN
	else:
		auto_fertilize_time.self_modulate = Color.INDIAN_RED
	
	if carrot_growth_time.disabled:
		carrot_growth_time.self_modulate = Color.WHITE
	elif Global.common_poops_collected >= Global.carrot_growth_time_upgrade_cost:
		carrot_growth_time.self_modulate = Color.GREEN
	else:
		carrot_growth_time.self_modulate = Color.INDIAN_RED


func _on_add_little_guy_pressed() -> void:
	if Global.littleguy_count_upgrade_count < Global.littleguy_count_upgrade_max:
		if Global.common_poops_collected >= Global.littleguy_count_upgrade_cost:
			Global.common_poops_collected -= Global.littleguy_count_upgrade_cost
			Global.littleguy_count_upgrade_count += 1
			Global.littleguy_count += 1
			SignalBus.add_little_guy.emit()
			Global.littleguy_count_upgrade_cost += Global.littleguy_count_upgrade_cost_base * Global.littleguy_count_upgrade_count
	if Global.littleguy_count_upgrade_count == Global.littleguy_count_upgrade_max:
		add_little_guy.disabled = true
		return


func _on_increase_little_guy_speed_pressed() -> void:
	if Global.littleguy_speed_upgrade_count < Global.littleguy_speed_upgrade_max:
		if Global.common_poops_collected >= Global.littleguy_speed_upgrade_cost:
			Global.common_poops_collected -= Global.littleguy_speed_upgrade_cost
			Global.littleguy_speed_upgrade_count += 1
			Global.littleguy_speed += 75.0
			Global.littleguy_speed_upgrade_cost += Global.littleguy_speed_upgrade_cost_base * Global.littleguy_speed_upgrade_count
	if Global.littleguy_speed_upgrade_count == Global.littleguy_speed_upgrade_max:
		increase_little_guy_speed.disabled = true
		return


func _on_food_threshold_pressed() -> void:
	if Global.littleguy_max_food_pool_upgrade_count < Global.littleguy_max_food_pool_upgrade_max:
		if Global.common_poops_collected >= Global.littleguy_max_food_pool_upgrade_cost:
			Global.common_poops_collected -= Global.littleguy_max_food_pool_upgrade_cost
			Global.littleguy_max_food_pool_upgrade_count += 1
			Global.littleguy_max_food_pool -= 1
			Global.littleguy_max_food_pool_upgrade_cost += Global.littleguy_max_food_pool_upgrade_cost_base * Global.littleguy_max_food_pool_upgrade_count
	if Global.littleguy_max_food_pool_upgrade_count == Global.littleguy_max_food_pool_upgrade_max:
		food_threshold.disabled = true
		return


func _on_increase_poop_chance_pressed() -> void:
	if Global.poop_chance_upgrade_count < Global.poop_chance_upgrade_max:
		if Global.common_poops_collected >= Global.poop_chance_upgrade_cost:
			Global.common_poops_collected -= Global.poop_chance_upgrade_cost
			Global.poop_chance += Global.poop_chance/(Global.poop_chance_upgrade_max - Global.poop_chance_upgrade_count + 2)
			Global.poop_chance_upgrade_count += 1
			Global.poop_chance_upgrade_cost += Global.poop_chance_upgrade_cost_base * Global.poop_chance_upgrade_count
	if Global.poop_chance_upgrade_count == Global.poop_chance_upgrade_max:
		increase_poop_chance.disabled = true
		return


func _on_decrease_poop_time_pressed() -> void:
	if Global.poop_time_upgrade_count < Global.poop_time_upgrade_max:
		if Global.common_poops_collected >= Global.poop_time_upgrade_cost:
			Global.common_poops_collected -= Global.poop_time_upgrade_cost
			Global.poop_time -= Global.poop_time/(Global.poop_time_upgrade_max - Global.poop_time_upgrade_count + 2)
			Global.poop_time_upgrade_count += 1
			Global.poop_time_upgrade_cost += Global.poop_time_upgrade_cost_base * Global.poop_time_upgrade_count
	if Global.poop_time_upgrade_count == Global.poop_time_upgrade_max:
		decrease_poop_time.disabled = true
		return


func _on_decrease_rest_chance_pressed() -> void:
	if Global.rest_chance_upgrade_count < Global.rest_chance_upgrade_max:
		if Global.common_poops_collected >= Global.rest_chance_upgrade_cost:
			Global.common_poops_collected -= Global.rest_chance_upgrade_cost
			Global.rest_chance -= Global.rest_chance/(Global.rest_chance_upgrade_max - Global.rest_chance_upgrade_count + 2)
			Global.rest_chance_upgrade_count += 1
			Global.rest_chance_upgrade_cost += Global.rest_chance_upgrade_cost_base * Global.rest_chance_upgrade_count
	if Global.rest_chance_upgrade_count == Global.rest_chance_upgrade_max:
		decrease_rest_chance.disabled = true
		return


func _on_decrease_rest_time_pressed() -> void:
	if Global.rest_time_upgrade_count < Global.rest_time_upgrade_max:
		if Global.common_poops_collected >= Global.rest_time_upgrade_cost:
			Global.common_poops_collected -= Global.rest_time_upgrade_cost
			Global.rest_time -= Global.rest_time/(Global.rest_time_upgrade_max - Global.rest_time_upgrade_count + 2)
			Global.rest_time_upgrade_count += 1
			Global.rest_time_upgrade_cost += Global.rest_time_upgrade_cost_base * Global.rest_time_upgrade_count
	if Global.rest_time_upgrade_count == Global.rest_time_upgrade_max:
		decrease_rest_time.disabled = true
		return


func _on_auto_feed_fries_pressed() -> void:
	if Global.food_spawn_auto_upgrade_count < Global.food_spawn_auto_upgrade_max:
		if Global.common_poops_collected >= Global.food_spawn_auto_upgrade_cost:
			Global.common_poops_collected -= Global.food_spawn_auto_upgrade_cost
			Global.food_spawn_auto = true
			Global.food_spawn_auto_upgrade_count += 1
			Global.food_spawn_auto_upgrade_cost += Global.food_spawn_auto_upgrade_cost_base * Global.food_spawn_auto_upgrade_count
	if Global.food_spawn_auto_upgrade_count == Global.food_spawn_auto_upgrade_max:
		auto_feed_fries.disabled = true
		return


func _on_increase_food_spawn_amount_pressed() -> void:
	if Global.food_spawn_amount_upgrade_count < Global.food_spawn_amount_upgrade_max:
		if Global.common_poops_collected >= Global.food_spawn_amount_upgrade_cost:
			Global.common_poops_collected -= Global.food_spawn_amount_upgrade_cost
			Global.food_spawn_amount += 1
			Global.food_spawn_amount_upgrade_count += 1
			Global.food_spawn_amount_upgrade_cost += Global.food_spawn_amount_upgrade_cost_base * Global.food_spawn_amount_upgrade_count
	if Global.food_spawn_amount_upgrade_count == Global.food_spawn_amount_upgrade_max:
		increase_food_spawn_amount.disabled = true
		return


func _on_decrease_food_spawn_time_pressed() -> void:
	if Global.food_spawn_time_upgrade_count < Global.food_spawn_time_upgrade_max:
		if Global.common_poops_collected >= Global.food_spawn_time_upgrade_cost:
			Global.common_poops_collected -= Global.food_spawn_time_upgrade_cost
			Global.food_spawn_time -= Global.food_spawn_time/(Global.food_spawn_time_upgrade_max - Global.food_spawn_time_upgrade_count + 2)
			Global.food_spawn_time_upgrade_count += 1
			Global.food_spawn_time_upgrade_cost += Global.food_spawn_time_upgrade_cost_base * Global.food_spawn_time_upgrade_count
	if Global.food_spawn_time_upgrade_count == Global.food_spawn_time_upgrade_max:
		decrease_food_spawn_time.disabled = true
		return


func _on_auto_feed_carrot_pressed() -> void:
	if Global.carrot_spawn_auto_upgrade_count < Global.carrot_spawn_auto_upgrade_max:
		if Global.common_poops_collected >= Global.carrot_spawn_auto_upgrade_cost:
			Global.common_poops_collected -= Global.carrot_spawn_auto_upgrade_cost
			Global.carrot_spawn_auto = true
			Global.carrot_spawn_auto_upgrade_count += 1
			Global.carrot_spawn_auto_upgrade_cost += Global.carrot_spawn_auto_upgrade_cost_base * Global.carrot_spawn_auto_upgrade_count
	if Global.carrot_spawn_auto_upgrade_count == Global.carrot_spawn_auto_upgrade_max:
		auto_feed_carrot.disabled = true
		return


func _on_auto_feed_carrot_amount_pressed() -> void:
	if Global.carrot_spawn_amount_upgrade_count < Global.carrot_spawn_amount_upgrade_max:
		if Global.common_poops_collected >= Global.carrot_spawn_amount_upgrade_cost:
			Global.common_poops_collected -= Global.carrot_spawn_amount_upgrade_cost
			Global.carrot_spawn_amount += 1
			Global.carrot_spawn_amount_upgrade_count += 1
			Global.carrot_spawn_amount_upgrade_cost += Global.carrot_spawn_amount_upgrade_cost_base * Global.carrot_spawn_amount_upgrade_count
	if Global.carrot_spawn_amount_upgrade_count == Global.carrot_spawn_amount_upgrade_max:
		auto_feed_carrot_amount.disabled = true
		return


func _on_auto_feed_carrot_time_pressed() -> void:
	if Global.carrot_spawn_time_upgrade_count < Global.carrot_spawn_time_upgrade_max:
		if Global.common_poops_collected >= Global.carrot_spawn_time_upgrade_cost:
			Global.common_poops_collected -= Global.carrot_spawn_time_upgrade_cost
			Global.carrot_spawn_time -= Global.carrot_spawn_time/(Global.carrot_spawn_time_upgrade_max - Global.carrot_spawn_time_upgrade_count + 2)
			Global.carrot_spawn_time_upgrade_count += 1
			Global.carrot_spawn_time_upgrade_cost += Global.carrot_spawn_time_upgrade_cost_base * Global.carrot_spawn_time_upgrade_count
	if Global.carrot_spawn_time_upgrade_count == Global.carrot_spawn_time_upgrade_max:
		auto_feed_carrot_time.disabled = true
		return


func _on_auto_collect_poop_pressed() -> void:
	if Global.poop_auto_collect_upgrade_count < Global.poop_auto_collect_upgrade_max:
		if Global.common_poops_collected >= Global.poop_auto_collect_upgrade_cost:
			Global.common_poops_collected -= Global.poop_auto_collect_upgrade_cost
			Global.poop_auto_collect = true
			Global.poop_auto_collect_upgrade_count += 1
			Global.poop_auto_collect_upgrade_cost += Global.poop_auto_collect_upgrade_cost_base * Global.poop_auto_collect_upgrade_count
	if Global.poop_auto_collect_upgrade_count == Global.poop_auto_collect_upgrade_max:
		auto_collect_poop.disabled = true
		return


func _on_auto_collect_poop_amount_pressed() -> void:
	if Global.poop_auto_collect_amount_upgrade_count < Global.poop_auto_collect_amount_upgrade_max:
		if Global.common_poops_collected >= Global.poop_auto_collect_amount_upgrade_cost:
			Global.common_poops_collected -= Global.poop_auto_collect_amount_upgrade_cost
			Global.poop_auto_collect_amount += 1
			Global.poop_auto_collect_amount_upgrade_count += 1
			Global.poop_auto_collect_amount_upgrade_cost += Global.poop_auto_collect_amount_upgrade_cost_base * Global.poop_auto_collect_amount_upgrade_count
	if Global.poop_auto_collect_amount_upgrade_count == Global.poop_auto_collect_amount_upgrade_max:
		auto_collect_poop_amount.disabled = true
		return


func _on_auto_collect_poop_time_pressed() -> void:
	if Global.poop_auto_collect_time_upgrade_count < Global.poop_auto_collect_time_upgrade_max:
		if Global.common_poops_collected >= Global.poop_auto_collect_time_upgrade_cost:
			Global.common_poops_collected -= Global.poop_auto_collect_time_upgrade_cost
			Global.poop_auto_collect_time -= Global.poop_auto_collect_time/(Global.poop_auto_collect_time_upgrade_max - Global.poop_auto_collect_time_upgrade_count + 2)
			Global.poop_auto_collect_time_upgrade_count += 1
			Global.poop_auto_collect_time_upgrade_cost += Global.poop_auto_collect_time_upgrade_cost_base * Global.poop_auto_collect_time_upgrade_count
	if Global.poop_auto_collect_time_upgrade_count == Global.poop_auto_collect_time_upgrade_max:
		auto_collect_poop_time.disabled = true
		return


func _on_auto_collect_carrot_pressed() -> void:
	if Global.farm_auto_collect_upgrade_count < Global.farm_auto_collect_upgrade_max:
		if Global.common_poops_collected >= Global.farm_auto_collect_upgrade_cost:
			Global.common_poops_collected -= Global.farm_auto_collect_upgrade_cost
			Global.farm_auto_collect = true
			Global.farm_auto_collect_upgrade_count += 1
			Global.farm_auto_collect_upgrade_cost += Global.farm_auto_collect_upgrade_cost_base * Global.farm_auto_collect_upgrade_count
	if Global.farm_auto_collect_upgrade_count == Global.farm_auto_collect_upgrade_max:
		auto_collect_carrot.disabled = true
		return


func _on_auto_collect_carrot_amount_pressed() -> void:
	if Global.farm_auto_collect_amount_upgrade_count < Global.farm_auto_collect_amount_upgrade_max:
		if Global.common_poops_collected >= Global.farm_auto_collect_amount_upgrade_cost:
			Global.common_poops_collected -= Global.farm_auto_collect_amount_upgrade_cost
			Global.farm_auto_collect_amount += 1
			Global.farm_auto_collect_amount_upgrade_count += 1
			Global.farm_auto_collect_amount_upgrade_cost += Global.farm_auto_collect_amount_upgrade_cost_base * Global.farm_auto_collect_amount_upgrade_count
	if Global.farm_auto_collect_amount_upgrade_count == Global.farm_auto_collect_amount_upgrade_max:
		auto_collect_carrot_amount.disabled = true
		return


func _on_auto_collect_carrot_time_pressed() -> void:
	if Global.farm_auto_collect_time_upgrade_count < Global.farm_auto_collect_time_upgrade_max:
		if Global.common_poops_collected >= Global.farm_auto_collect_time_upgrade_cost:
			Global.common_poops_collected -= Global.farm_auto_collect_time_upgrade_cost
			Global.farm_auto_collect_time -= Global.farm_auto_collect_time/(Global.farm_auto_collect_time_upgrade_max - Global.farm_auto_collect_time_upgrade_count + 2)
			Global.farm_auto_collect_time_upgrade_count += 1
			Global.farm_auto_collect_time_upgrade_cost += Global.farm_auto_collect_time_upgrade_cost_base * Global.farm_auto_collect_time_upgrade_count
	if Global.farm_auto_collect_time_upgrade_count == Global.farm_auto_collect_time_upgrade_max:
		auto_collect_carrot_time.disabled = true
		return


func _on_auto_fertilize_pressed() -> void:
	if Global.farm_auto_fertilize_upgrade_count < Global.farm_auto_fertilize_upgrade_max:
		if Global.common_poops_collected >= Global.farm_auto_fertilize_upgrade_cost:
			Global.common_poops_collected -= Global.farm_auto_fertilize_upgrade_cost
			Global.farm_auto_fertilize = true
			Global.farm_auto_fertilize_upgrade_count += 1
			Global.farm_auto_fertilize_upgrade_cost += Global.farm_auto_fertilize_upgrade_cost_base * Global.farm_auto_fertilize_upgrade_count
	if Global.farm_auto_fertilize_upgrade_count == Global.farm_auto_fertilize_upgrade_max:
		auto_fertilize.disabled = true
		return


func _on_auto_fertilize_amount_pressed() -> void:
	if Global.farm_auto_fertilize_amount_upgrade_count < Global.farm_auto_fertilize_amount_upgrade_max:
		if Global.common_poops_collected >= Global.farm_auto_fertilize_amount_upgrade_cost:
			Global.common_poops_collected -= Global.farm_auto_fertilize_amount_upgrade_cost
			Global.farm_auto_fertilize_amount += 1
			Global.farm_auto_fertilize_amount_upgrade_count += 1
			Global.farm_auto_fertilize_amount_upgrade_cost += Global.farm_auto_fertilize_amount_upgrade_cost_base * Global.farm_auto_fertilize_amount_upgrade_count
	if Global.farm_auto_fertilize_amount_upgrade_count == Global.farm_auto_fertilize_amount_upgrade_max:
		auto_fertilize_amount.disabled = true
		return


func _on_auto_fertilize_time_pressed() -> void:
	if Global.farm_auto_fertilize_time_upgrade_count < Global.farm_auto_fertilize_time_upgrade_max:
		if Global.common_poops_collected >= Global.farm_auto_fertilize_time_upgrade_cost:
			Global.common_poops_collected -= Global.farm_auto_fertilize_time_upgrade_cost
			Global.farm_auto_fertilize_time -= Global.farm_auto_fertilize_time/(Global.farm_auto_fertilize_time_upgrade_max - Global.farm_auto_fertilize_time_upgrade_count + 2)
			Global.farm_auto_fertilize_time_upgrade_count += 1
			Global.farm_auto_fertilize_time_upgrade_cost += Global.farm_auto_fertilize_time_upgrade_cost_base * Global.farm_auto_fertilize_time_upgrade_count
	if Global.farm_auto_fertilize_time_upgrade_count == Global.farm_auto_fertilize_time_upgrade_max:
		auto_fertilize_time.disabled = true
		return


func _on_carrot_growth_time_pressed() -> void:
	if Global.carrot_growth_time_upgrade_count < Global.carrot_growth_time_upgrade_max:
		if Global.common_poops_collected >= Global.carrot_growth_time_upgrade_cost:
			Global.common_poops_collected -= Global.carrot_growth_time_upgrade_cost
			Global.carrot_growth_time -= Global.carrot_growth_time/(Global.carrot_growth_time_upgrade_max - Global.carrot_growth_time_upgrade_count + 2)
			Global.carrot_growth_time_upgrade_count += 1
			Global.carrot_growth_time_upgrade_cost += Global.carrot_growth_time_upgrade_cost_base * Global.carrot_growth_time_upgrade_count
	if Global.carrot_growth_time_upgrade_count == Global.carrot_growth_time_upgrade_max:
		carrot_growth_time.disabled = true
		return
