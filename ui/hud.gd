extends Control

@onready var poops_label: Label = $VBoxContainer/Poop/Poops
@onready var foods_label: Label = $VBoxContainer/Food/Foods

func _ready() -> void:
	SignalBus.poop_collected.connect(_on_poop_connected)
	poops_label.text = str(": %s" %Global.poops_collected)


func _process(delta: float) -> void:
	foods_label.text = str(": %s" %Global.food_amount)
	poops_label.text = str(": %s" %Global.poops_collected)


func _on_poop_connected() -> void:
	poops_label.text = str(": %s" %Global.poops_collected)


func _on_mouse_interaction_entered() -> void:
	Global.cursor_interacted = true


func _on_mouse_interaction_exited() -> void:
	Global.cursor_interacted = false


func _on_poop_mouse_entered() -> void:
	Global.cursor_poop_interacted = true
