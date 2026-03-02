extends GPUParticles2D

func _ready() -> void:
	await get_tree().create_timer(0.1,false).timeout
	emitting = true


func _on_finished() -> void:
	queue_free()
