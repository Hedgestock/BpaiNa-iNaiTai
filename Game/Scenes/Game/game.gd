extends Node2D

func _ready() -> void:
	add_child(GameManager.selected_car.instantiate())
