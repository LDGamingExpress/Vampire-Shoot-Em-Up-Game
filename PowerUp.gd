extends CharacterBody2D

var possiblePowerUps = ["Spread", "Laser", "Missile", "Shield"]
var powerUp
var Speed = 100
var hit = false


func _ready() -> void:
	var randNum = randi_range(0, possiblePowerUps.size() - 1)
	powerUp = possiblePowerUps[randNum]
	rotation = PI/2
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))


func onEntered(body: Node2D) -> void:
	if body.name == "Player" and !hit:
		$GPUParticles2D.emitting = false
		hit = true
		body.Upgrade(powerUp)
		$AnimatedSprite2D.visible = false
		
		await get_tree().create_timer(15.0).timeout
		body.Upgrade("None")
		queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2 and !hit:
		queue_free()
