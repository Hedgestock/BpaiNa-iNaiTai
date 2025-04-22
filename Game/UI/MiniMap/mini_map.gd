extends Node2D

@export var car: Car
@export var indicator: Sprite2D

func _physics_process(delta):
	indicator.position = car.position/1000
	indicator.rotation = car.rotation
