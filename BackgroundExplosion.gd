extends GPUParticles2D

func _ready() -> void:
	await get_tree().create_timer(0.1,false).timeout
	emitting = true
	print(global_position)


func _on_finished() -> void:
	queue_free()
