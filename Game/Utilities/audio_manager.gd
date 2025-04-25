extends AudioStreamPlayer

func change_music_to(music: AudioStream) -> void:
	if music == stream: return;
	var tween: Tween = create_tween();
	if stream != null:
		tween.tween_property(self, "volume_linear", 0, 0.5)
	tween.tween_callback(func(): stream = music; play())
	tween.tween_property(self, "volume_linear", 1, 0.5)
