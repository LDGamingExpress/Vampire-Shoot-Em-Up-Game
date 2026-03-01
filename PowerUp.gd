extends CharacterBody2D

var possiblePowerUps = ["Spread", "Gauss", "Missile", "Shield","Laser"]
var powerUp
var Speed = 100
var hit = false

var LabelText = load("res://PowerupLabel.tscn")


func _ready() -> void:
	var randNum = randi_range(0, possiblePowerUps.size() - 1)
	powerUp = possiblePowerUps[randNum]
	#rotation = PI/2
	velocity = Vector2(Speed * cos(PI/2),Speed * sin(PI/2))
	match powerUp:
		"Spread":
			$AnimatedSprite2D.frame = 0
		"Gauss":
			$AnimatedSprite2D.frame = 1
		"Missile":
			$AnimatedSprite2D.frame = 2
		"Shield":
			$AnimatedSprite2D.frame = 3
		"Laser":
			$AnimatedSprite2D.frame = 4
		"Reinforcements":
			$AnimatedSprite2D.frame = 5
	$Label.text = powerUp


func onEntered(body: Node2D) -> void:
	if body.name == "Player" and !hit:
		$GPUParticles2D.emitting = false
		hit = true
		body.Upgrade(powerUp)
		$AnimatedSprite2D.visible = false
		$Label.visible = false
		var newObj = LabelText.instantiate()
		newObj.position = global_position
		newObj.text = powerUp
		get_parent().add_child(newObj)
		
		await get_tree().create_timer(15.0).timeout
		if Globals.PowerUp == powerUp:
			body.Upgrade("None")
			queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2 and !hit:
		queue_free()
