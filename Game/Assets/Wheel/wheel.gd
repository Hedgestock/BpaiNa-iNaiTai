class_name Wheel extends Node2D

@export var debug_display: Label
@export var durability: float = 100
@export var stress_limit: int = 400
@export var physics: Physics

var is_drifting = false
var tire_mark: Line2D 

#func _ready():
	#get_tree().root.get_node("Game").add_child.call_deferred(tire_mark)
	
func drive(power: int, reverse: bool = false) -> Vector2:
	var tire_force: Vector2
	if reverse:
		tire_force = Vector2.DOWN.rotated(global_rotation) * power
	else:
		tire_force = Vector2.UP.rotated(global_rotation) * power
	return tire_force

func brake(velocity: Vector2):
	var stress: float = velocity.dot(Vector2.UP.rotated(global_rotation))
	return stress * 2 * Vector2.DOWN.rotated(global_rotation)

func drag(velocity: Vector2) -> Vector2:
	var stress: float = velocity.dot(Vector2.RIGHT.rotated(global_rotation))
	debug_display.text = name + " stress: " + str(stress) + " durability: " + str(durability)
	var current_grip: float = physics.grip.sample(abs(stress)/stress_limit)
	if current_grip > .8:
		is_drifting = false
	else:
		start_drifting()
		tire_mark.add_point(global_position)
	return stress * current_grip * Vector2.LEFT.rotated(global_rotation)

func start_drifting():
	if is_drifting: return
	is_drifting = true
	tire_mark = load("res://Game/Assets/Wheel/tire_mark.tscn").instantiate()
	get_tree().root.get_node("Game").add_child.call_deferred(tire_mark)

func stop_drifting():
	if !is_drifting: return
	is_drifting = false
