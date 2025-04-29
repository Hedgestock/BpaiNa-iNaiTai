class_name City extends Area2D

@export_multiline var city_name: String
@export var city_label: Label
@export var results: AudioStream

func _ready() -> void:
	city_label.text = city_name

func on_arrival(body: Node2D) -> void:
	if !(body is Car): return
	var car: Car = body
	if GameManager.selected_destination == self:
		car.congratulate()
		AudioManager.change_music_to(results)
		GameManager.selected_destination = null
