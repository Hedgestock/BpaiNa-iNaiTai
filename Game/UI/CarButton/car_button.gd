extends Button

@export var car: PackedScene
@export var viewer: Viewport

func _ready() -> void:
	var instance = car.instantiate()
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	instance.position = Vector2.ONE * 256
	instance.get_node("Camera2D").enabled = false
	viewer.add_child(instance)
