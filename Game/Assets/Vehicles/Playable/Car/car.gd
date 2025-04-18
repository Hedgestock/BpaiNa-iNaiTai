class_name Car extends RigidBody2D

@export var turning_radius: float = 15
@export var direction_wheels: Array[Wheel]
@export var power_wheels: Array[Wheel]
@export var speed_label: Label

var wheels: Array[Wheel] = []

func _ready():
	wheels.assign(get_children().filter(func (c): return c is Wheel))

func  _physics_process(delta):
	if Input.is_action_pressed("reverse"):
		for wheel in power_wheels:
			apply_force(wheel.drive(100, true), wheel.global_position - global_position)
	elif Input.is_action_pressed("drive"):
		for wheel in power_wheels:
			apply_force(wheel.drive(100), wheel.global_position - global_position)
	if Input.is_action_pressed("turn_left"):
		for wheel in direction_wheels:
			wheel.rotation_degrees = -turning_radius
	elif Input.is_action_pressed("turn_right"):
		for wheel in direction_wheels:
			wheel.rotation_degrees = turning_radius
	else:
		for wheel in direction_wheels:
			wheel.rotation_degrees = 0
	if Input.is_action_pressed("test_left"):
		apply_central_force(Vector2.LEFT*100)
	elif Input.is_action_pressed("test_right"):
		apply_torque(10000)

	if Input.is_action_pressed("brake"):
		for wheel in wheels:
			apply_force(wheel.brake(linear_velocity), wheel.global_position - global_position)

	for wheel in wheels:
		apply_force(wheel.drag(get_velocity_at_position(wheel.global_position)), wheel.global_position - global_position)

	speed_label.text = str(linear_velocity.length()) + " kmh"

func get_velocity_at_position(offset: Vector2) -> Vector2:
	var radius: Vector2 = to_global(center_of_mass) - offset
	return linear_velocity + angular_velocity * radius.rotated(-PI/2)
