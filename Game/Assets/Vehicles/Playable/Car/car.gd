class_name Car extends RigidBody2D

@export var camera: Camera2D
@export var mini_map: SubViewportContainer
@export var turning_radius: float = 25
@export var fuel_consuption: float = 0.1
@export var fuel_gauge: TextureProgressBar
@export var direction_wheels: Array[Wheel]
@export var power_wheels: Array[Wheel]
@export var speed_label: Label
@export var power_curve: Curve

var refueling_rate: int = 0
var wheels: Array[Wheel] = []

func _ready():
	fuel_gauge.value = fuel_gauge.max_value
	wheels.assign(get_children().filter(func (c): return c is Wheel))

func  _physics_process(delta):
	adjust_hud()
	
	if refueling_rate != 0:
		fuel_gauge.value += refueling_rate
	
	if Input.is_action_pressed("reverse"):
		if (forward_velocity.dot(Vector2.UP.rotated(rotation)) > 1):
			brake()
		else:
			drive(true)
	elif Input.is_action_pressed("drive"):
		if (forward_velocity.dot(Vector2.DOWN.rotated(rotation)) > 1):
			brake()
		else:
			drive()
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

func drive(reverse: bool = false) -> void:
	if fuel_gauge.value <= 0: return
	var proxy_speed = speed if !reverse else 0
	print((power_curve.sample(proxy_speed) / power_curve.max_value) * fuel_consuption)
	fuel_gauge.value -= (power_curve.sample(proxy_speed) / power_curve.max_value) * fuel_consuption
	power_curve.sample(proxy_speed)
	
	for wheel in power_wheels:
		apply_force(wheel.drive(get_velocity_at_position(wheel.global_position), power_curve.sample(proxy_speed), reverse)/power_wheels.size(), wheel.global_position - global_position)


func get_velocity_at_position(offset: Vector2) -> Vector2:
	var radius: Vector2 = to_global(center_of_mass) - offset
	return linear_velocity + angular_velocity * radius.rotated(-PI/2)

var forward_velocity: Vector2:
	get:
		return linear_velocity.dot(Vector2.UP.rotated(rotation)) * Vector2.UP.rotated(rotation)

var speed: float:
	get:
		return forward_velocity.length()/10

func adjust_hud() -> void:
	var zoom: float = clamp(1 - speed/200, 0.5, 1.0)
	camera.zoom = Vector2(zoom, zoom)
	camera.position = Vector2(0, - ((1 - zoom) * 2000 + 500))
	mini_map.scale = Vector2(zoom, zoom)

func start_refueling(rate: int) -> void:
	refueling_rate = rate

func stop_refueling() -> void:
	refueling_rate = 0
