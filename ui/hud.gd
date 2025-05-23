extends Control

@onready var poops_label: Label = $HBoxContainer/Poops

func _ready() -> void:
	SignalBus.poop_collected.connect(_on_poop_connected)
	poops_label.text = str(": %s" %Global.poops_collected)

func _on_poop_connected() -> void:
	poops_label.text = str(": %s" %Global.poops_collected)
