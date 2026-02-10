extends GPUParticles2D
var SFXObj = load("res://SFXObject.tscn")


func _ready() -> void:
	emitting = true
	var newSFX = SFXObj.instantiate()
	newSFX.stream = load("res://SFX/Explosion1.mp3")
	newSFX.position = position
	newSFX.pitch_scale = randf_range(0.95,1.05)
	get_parent().call_deferred("add_child",newSFX)


func _on_finished() -> void:
	queue_free()
