extends Area2D

@export_multiline var city_name: String
@export var city_label: Label

func _ready() -> void:
	city_label.text = city_name
