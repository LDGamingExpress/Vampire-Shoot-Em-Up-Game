extends CharacterBody2D
var Team = null
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = 500
var Frame = 0
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var SFXObj = load("res://SFXObject.tscn")

var currentTarget = null

func _ready() -> void:
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	$AnimatedSprite2D.frame = Frame
	$AnimatedSprite2D/PointLight2D.color = $AnimatedSprite2D.modulate
	var newSFX = SFXObj.instantiate()
	newSFX.stream = load("res://SFX/LaserSoundEffect.mp3")
	newSFX.position = position
	newSFX.pitch_scale = randf_range(0.95,1.05)
	get_parent().call_deferred("add_child",newSFX)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2 or position.y < -Globals.ScreenSize.y/2:
		queue_free()
	
	if currentTarget != null:
		var dir = (currentTarget.position - position).normalized()
		rotation = dir.angle()
		velocity = dir * (Speed - 200)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if position.y >= -Globals.ScreenSize.y/4.0:
		if body.Team != Team:
			body.Health -= Damage
			body.Damaged()
			var newObj = ExplosionParticles.instantiate()
			newObj.position = position
			get_parent().add_child(newObj)
			
			var UI = get_parent().get_node("CanvasLayer").get_node("GameUI")
			UI.add_score(100)
			
			if Globals.PowerUp != "Laser":
				queue_free()
			elif Globals.PowerUp == "Laser":
				if position.y > Globals.ScreenSize.y/2 or position.y < -Globals.ScreenSize.y/2:
					queue_free()
	else:
		queue_free()


func BulletAreaEntered(body: Node2D) -> void:
	if body.Team != Team and currentTarget == null:
		currentTarget = body
