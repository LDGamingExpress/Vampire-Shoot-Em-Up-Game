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
	if Team == "Player" and Globals.PowerUp == "Gauss":
		Speed *= 2
	elif Team == "Boss":
		Speed *= 2
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	$AnimatedSprite2D.frame = Frame
	$AnimatedSprite2D/PointLight2D.color = $AnimatedSprite2D.modulate
	var newSFX = SFXObj.instantiate()
	newSFX.stream = load("res://SFX/LaserSoundEffect.mp3")
	newSFX.position = position
	
	if Team == "Player" and Globals.PowerUp == "Gauss":
		newSFX.pitch_scale = randf_range(0.60, 0.90)
		$Area2D/CollisionShape2D.scale = Vector2(1.5,1.5)
	elif Team == "Boss":
		newSFX.pitch_scale = randf_range(0.60, 0.90)
	else:
		newSFX.pitch_scale = randf_range(0.95,1.05)
	get_parent().call_deferred("add_child",newSFX)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2 or position.y < -Globals.ScreenSize.y/2:
		queue_free()
	
	if currentTarget != null:
		var dir = (currentTarget.global_position - position).normalized()
		rotation = dir.angle()
		velocity = dir * (Speed - 200)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if position.y >= -Globals.ScreenSize.y/4.0:
		if body.Team != Team:
			if !body.is_in_group("Skull"):
				body.Health -= Damage
				body.Damaged()
				var newObj = ExplosionParticles.instantiate()
				newObj.position = position
				get_parent().add_child(newObj)
				
				var UI = get_parent().get_node("CanvasLayer").get_node("GameUI")
				
				if Team == "Player" and body.Team != "Boss":
					UI.add_score(body.get_node("PointValue").value)
				
				if Globals.PowerUp != "Gauss":
					queue_free()
				elif Globals.PowerUp == "Gauss":
					if position.y > Globals.ScreenSize.y/2 or position.y < -Globals.ScreenSize.y/2:
						queue_free()
			elif body.is_in_group("Skull"):
				if body.CanDamage:
					body.Health -= Damage
					body.Damaged()
					var newObj = ExplosionParticles.instantiate()
					newObj.position = position
					get_parent().add_child(newObj)
					
					var UI = get_parent().get_node("CanvasLayer").get_node("GameUI")
					
					if Team == "Player":
						UI.add_score(body.get_node("PointValue").value)
					
					if Globals.PowerUp != "Gauss":
						queue_free()
					elif Globals.PowerUp == "Gauss":
						if position.y > Globals.ScreenSize.y/2 or position.y < -Globals.ScreenSize.y/2:
							queue_free()
	else:
		queue_free()


func BulletAreaEntered(body: Node2D) -> void:
	if body.Team != Team and currentTarget == null:
		if !body.is_in_group("Skull"):
			currentTarget = body
		else:
			if body.CanDamage:
				currentTarget = body
