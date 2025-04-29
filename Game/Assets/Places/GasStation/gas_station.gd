extends Node2D

@export var rate: float = 0.2
@export var tire_timer: Timer

func start_refueling(body: Node2D) -> void:
	if !(body is Car): return
	body.start_refueling(rate)

func stop_refueling(body: Node2D) -> void:
	if !(body is Car): return
	body.stop_refueling()

func check_for_tire(body: Node2D) -> void:
	if !(body is Car): return
	var car: Car = body
	#var current_tire: Wheel = car.wheels.filter(func (w: Wheel): return w.durability.value <= 0 || w.durability.max_value > w.durability.value).pick_random()
	var current_tire: Wheel = car.wheels.reduce(func (acc: Wheel, w: Wheel):
		if w.durability.value < acc.durability.value:
			return w
		return acc
		, car.wheels[0])
	if current_tire != null:
		tire_timer.timeout.connect(func(): end_tire_change(body, current_tire))
		tire_timer.start()

func end_tire_change(body: Node2D, tire: Wheel) -> void:
	tire.renew()
	for connection in tire_timer.timeout.get_connections():
		tire_timer.timeout.disconnect(connection["callable"])
	check_for_tire(body)

func stop_checking_for_tire(body: Node2D) -> void:
	if !(body is Car): return
	for connection in tire_timer.timeout.get_connections():
		tire_timer.timeout.disconnect(connection["callable"])
	tire_timer.stop()
