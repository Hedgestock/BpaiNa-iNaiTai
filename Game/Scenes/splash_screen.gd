extends ColorRect

@export var waffle_stock: Label
@export var logo: VideoStreamPlayer
@export var last_frame: TextureRect


func _ready():
	visible = true

	if (!visible):
		return

	waffle_stock.modulate = Color("ffffff00")
	logo.play();
	var tween = get_tree().create_tween()
	tween.tween_property(waffle_stock, "modulate", Color("ffffff"), 1)
	tween.tween_property(self, "modulate", Color("ffffff"), 1)
	tween.tween_property(self, "modulate", Color("ffffff00"), 1)
	tween.tween_callback(func(): queue_free()) #music.play())
