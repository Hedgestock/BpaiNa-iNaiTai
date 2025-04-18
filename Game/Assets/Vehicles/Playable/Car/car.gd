class_name Car extends RigidBody2D

@export var turning_radius: float = 15
@export var direction_wheels: Array[Wheel]
@export var power_wheels: Array[Wheel]
@export var speed_label: Label
@export var power_curve: Curve

var wheels: Array[Wheel] = []

func _ready():
	wheels.assign(get_children().filter(func (c): return c is Wheel))

func  _physics_process(delta):
	if Input.is_action_pressed("reverse"):
		if (forward_velocity.dot(Vector2.UP.rotated(rotation)) > 1):
			brake()
		else:
			for wheel in power_wheels:
				apply_force(wheel.drive(get_velocity_at_position(wheel.global_position), power_curve.sample(0)/power_wheels.size(), true), wheel.global_position - global_position)
	elif Input.is_action_pressed("drive"):
		if (forward_velocity.dot(Vector2.DOWN.rotated(rotation)) > 1):
			brake()
		else:
			for wheel in power_wheels:
				apply_force(wheel.drive(get_velocity_at_position(wheel.global_position), power_curve.sample(speed))/power_wheels.size(), wheel.global_position - global_position)
	if Input.is_action_pressed("turn_left"):
		for wheel in direction_wheels:
			wheel.rotation_degrees = -turning_radius
	elif Input.is_action_pressed("turn_right"):
		for wheel in direction_wheels:
			wheel.rotation_degrees = turning_radius
	else:
		for wheel in direction_wheels:
			wheel.rotation_degrees = 0
	for wheel in wheels:
		apply_force(wheel.drag(get_velocity_at_position(wheel.global_position)), wheel.global_position - global_position)
	speed_label.text = str("%0.1f" % speed," kmh")

func brake() -> void:
	for wheel in wheels:
		apply_force(wheel.brake(linear_velocity), wheel.global_position - global_position)

func get_velocity_at_position(offset: Vector2) -> Vector2:
	var radius: Vector2 = to_global(center_of_mass) - offset
	return linear_velocity + angular_velocity * radius.rotated(-PI/2)

var forward_velocity: Vector2:
	get:
		return linear_velocity.dot(Vector2.UP.rotated(rotation)) * Vector2.UP.rotated(rotation)

var speed: float:
	get:
		return forward_velocity.length()/10
