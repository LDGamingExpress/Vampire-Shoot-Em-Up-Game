extends CharacterBody2D

var Speed = 100
var hit = false

var LabelText = load("res://PowerupLabel.tscn")


func _ready() -> void:
	rotation = PI/2
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))


func onEntered(body: Node2D) -> void:
	if body.name == "Player" and !hit:
		$GPUParticles2D.emitting = false
		hit = true
		body.Heal()
		$AnimatedSprite2D.visible = false
		var newObj = LabelText.instantiate()
		newObj.position = global_position
		newObj.text = "Health"
		newObj.modulate = Color(0.0, 1.0, 0.0, 1.0)
		get_parent().add_child(newObj)
		
		await get_tree().create_timer(15.0).timeout
		body.Upgrade("None")
		queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2 and !hit:
		queue_free()
