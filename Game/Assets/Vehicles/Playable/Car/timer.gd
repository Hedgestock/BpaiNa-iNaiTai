extends Label

@export var car: Car

func _physics_process(delta):
	if car.start_time != 0:
		text = str("%0.1f" % [Time.get_unix_time_from_system() - car.start_time])
