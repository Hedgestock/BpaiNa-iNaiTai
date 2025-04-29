extends Area2D

@export var destination: City
@export var destination_label: Label

func  _ready() -> void:
	destination_label.text = destination.city_name

func on_selection(body: Node2D) -> void:
	if !(body is Car): return
	var car: Car = body
	GameManager.selected_destination = destination
	car.destination_label.text = destination.city_name
	car.start_time = Time.get_unix_time_from_system()
