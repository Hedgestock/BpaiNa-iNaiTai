extends Button

@export var car: PackedScene
@export var viewer: Viewport

func _ready() -> void:
	var instance = car.instantiate()
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	instance.position = Vector2.ONE * 256
	instance.get_node("Camera2D").enabled = false
	instance.get_node("Camera2D/CanvasLayer").hide()
	viewer.add_child(instance)

func start_game() -> void:
	GameManager.selected_car = car
	get_tree().change_scene_to_file("res://Game/Scenes/Game/Game.tscn")
	
