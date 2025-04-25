extends Node2D

@export var main_soundtrack: AudioStream

func _ready() -> void:
	var car: Car = GameManager.selected_car.instantiate()
	car.position = Vector2(-64527.0, -50111.0)
	add_child(car)
	AudioManager.change_music_to(main_soundtrack)
