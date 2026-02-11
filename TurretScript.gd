extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = Globals.PlayerSpeed + randi_range(-5,5) + 80
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 1
var BulletObj = load("res://Bullet.tscn")
@export var Type = 1
# 1 - small turret
#	- shoots standard lasers
# 2 - big turret with single barrel
#	- shoots homing bullets
# 3 - big turret with two barrels
#	- standard turret that fires lasers
# 4 - big turret with three barrels
#	- shoots orb-shaped bullets in small bursts and rotates side to side
var Player = null
var rotationDir = PI/4

func _ready() -> void:
	$AnimatedSprite2D.frame = Type - 1
	match Type:
		1:
			$Timer.wait_time = 0.8
			Health = 5
			$CollisionShape2D.shape.radius = 5.0
		2:
			$Timer.wait_time = 0.8
			Health = 10
			$CollisionShape2D.shape.radius = 11.0
		3:
			$Timer.wait_time = 1.2
			Health = 10
			$CollisionShape2D.shape.radius = 11.0
		4:
			$Timer.wait_time = 0.9
			Health = 10
			$CollisionShape2D.shape.radius = 11.0

func _physics_process(delta: float) -> void:
	match Type:
		1:
			if Player != null:
				var NewRotation = global_position.direction_to(Player.position).angle()
				#NewRotation = atan(NewRotation.y/NewRotation.x)
				var RotateBy = 0.1
				if NewRotation * global_rotation < 0:
					RotateBy = -0.1
				global_rotation = lerpf(global_rotation,NewRotation,RotateBy)
				#print(NewRotation)
		2:
			if Player != null:
				var NewRotation = global_position.direction_to(Player.position).angle()
				#NewRotation = atan(NewRotation.y/NewRotation.x)
				var RotateBy = 0.1
				if NewRotation * global_rotation < 0:
					RotateBy = -0.1
				global_rotation = lerpf(global_rotation,NewRotation,RotateBy)
				#print(NewRotation)
		3:
			if Player != null:
				var NewRotation = global_position.direction_to(Player.position).angle()
				#NewRotation = atan(NewRotation.y/NewRotation.x)
				var RotateBy = 0.1
				if NewRotation * global_rotation < 0:
					RotateBy = -0.1
				global_rotation = lerpf(global_rotation,NewRotation,RotateBy)
				#print(NewRotation)
		4:
			if global_rotation != rotationDir:
				var RotateBy = 0.1
				if rotationDir * global_rotation < 0:
					RotateBy = -0.1
				global_rotation = lerpf(global_rotation,rotationDir,RotateBy)
			else:
				rotationDir = rotationDir * -1
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2:
		queue_free()

func Damaged():
	if Health <= 0:
		queue_free()
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.25)
		await get_tree().create_timer(0.25).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)

func FireBurst():
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = global_rotation
		newBullet.Team = "Enemy"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		if Type == 4:
			newBullet.Frame = 4
		if Type == 2:
			newBullet.Damage = 3
		if Type == 3:
			newBullet.Damage = 2
		get_parent().get_parent().get_parent().add_child(newBullet)

func _on_timer_timeout() -> void:
	FireBurst()

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
