extends Node2D

@export var rate: int = 1

func start_refueling(body: Node2D) -> void:
	if !(body is Car): return
	body.start_refueling(rate)

func stop_refueling(body: Node2D) -> void:
	if !(body is Car): return
	body.stop_refueling()
