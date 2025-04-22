class_name Wheel extends Node2D

@export var durability: TextureProgressBar
@export var stress_limit: int = 400
@export var new_physics: Physics
@export var rim_physics: Physics

var physics: Physics
var tire_mark: Line2D

var is_drifting: bool = false
var is_burning_out: bool = false
var has_grip: bool:
	get: return !is_drifting && !is_burning_out

func _ready() -> void:
	renew()
	durability.value_changed.connect(wear_tire)
	
func _physics_process(delta):
	if !has_grip:
		tire_mark.add_point(global_position)
		durability.value -= 0.05 * physics.durability_mod

func drive(velocity: Vector2, power: int, reverse: bool = false) -> Vector2:
	var tire_force: Vector2
	var current_grip: float = physics.grip.sample(abs(power)/(velocity.length()*2))
	if reverse:
		tire_force = Vector2.DOWN.rotated(global_rotation) * power * current_grip
	else:
		tire_force = Vector2.UP.rotated(global_rotation) * power * current_grip
	if current_grip > .8:
		stop_burning_out()
	else:
		start_burning_out()
	return tire_force

func brake(velocity: Vector2):
	var stress: float = velocity.dot(Vector2.UP.rotated(global_rotation))
	durability.value -= abs(stress) * 0.0005 * physics.durability_mod
	return stress * Vector2.DOWN.rotated(global_rotation)

func drag(velocity: Vector2) -> Vector2:
	var stress: float = velocity.dot(Vector2.RIGHT.rotated(global_rotation))
	var current_grip: float = physics.grip.sample(abs(stress)/stress_limit)
	if current_grip > .8:
		stop_drifting()
	else:
		start_drifting()
	durability.value -= abs(stress) * 0.0001 * physics.durability_mod
	return stress * current_grip * Vector2.LEFT.rotated(global_rotation)

func start_drifting() -> void:
	if is_drifting: return
	add_tire_mark()
	is_drifting = true

func stop_drifting() -> void:
	if !is_drifting: return
	is_drifting = false

func start_burning_out() -> void:
	if is_burning_out: return
	add_tire_mark()
	is_burning_out = true

func stop_burning_out() -> void:
	if !is_burning_out: return
	is_burning_out = false

func add_tire_mark() -> void:
	if !has_grip: return
	tire_mark = physics.drift_mark.instantiate()
	get_tree().root.get_node("Game").add_child.call_deferred(tire_mark)

func renew() -> void:
	apply_physics(new_physics)
	durability.value = physics.durability

func explode() -> void:
	apply_physics(rim_physics)
	
func wear_tire(value: float) -> void:
	if value <= 0:
		explode()

func apply_physics(physics: Physics) -> void:
	stop_drifting()
	stop_burning_out()
	self.physics = physics
	durability.max_value = physics.durability
	get_node("Tire").texture = physics.texture
