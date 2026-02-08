extends CharacterBody2D
var Team = null
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = 500
var Frame = 0
var ExplosionParticles = load("res://ExplosionParticles.tscn")

func _ready() -> void:
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	#velocity = Vector2.UP.rotated(rotation) * Speed
	$AnimatedSprite2D.frame = Frame

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2 or position.y < -Globals.ScreenSize.y/2:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.Team != Team:
		body.Health -= Damage
		body.Damaged()
		var newObj = ExplosionParticles.instantiate()
		newObj.position = position
		get_parent().add_child(newObj)
		
		if Globals.PowerUp != "Laser":
			queue_free()
