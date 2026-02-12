extends Label

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)
	await get_tree().create_timer(0.25).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	await get_tree().create_timer(0.5).timeout
	queue_free()
