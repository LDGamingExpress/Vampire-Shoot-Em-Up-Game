extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 2
var Speed = Globals.PlayerSpeed + randi_range(-5,5) + 50
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 1
var BulletObj = load("res://Bullet.tscn")
var Player = null

func _ready() -> void:
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	#$AnimatedSprite2D.rotation = randf_range(0,2*PI)
	await get_tree().create_timer(0.1).timeout
	$GPUParticles2D.emitting = true
	

func _physics_process(delta: float) -> void:
	#print(Player)
	if Player != null:
		var NewRotation = position.direction_to(Player.position).angle()
		#NewRotation = atan(NewRotation.y/NewRotation.x)
		var RotateBy = 0.1
		if NewRotation * rotation < 0:
			RotateBy = -0.1
		rotation = lerpf(rotation,NewRotation,RotateBy)
		#print(NewRotation)
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2:
		$GPUParticles2D.emitting = false
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.Team != "Enemy":
		body.Health -= Damage
		body.Damaged()
		var newObj = ExplosionParticles.instantiate()
		newObj.position = position
		get_parent().add_child(newObj)
		$GPUParticles2D.emitting = false
		queue_free()

func Damaged():
	if Health <= 0:
		$GPUParticles2D.emitting = false
		queue_free()

func FireBurst():
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = rotation
		newBullet.Team = "Enemy"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		get_parent().add_child(newBullet)
	await get_tree().create_timer(0.05).timeout
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = rotation
		newBullet.Team = "Enemy"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		get_parent().add_child(newBullet)
	await get_tree().create_timer(0.05).timeout
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = rotation
		newBullet.Team = "Enemy"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		get_parent().add_child(newBullet)

func _on_timer_timeout() -> void:
	if $VisibleOnScreenNotifier2D.is_on_screen():
		FireBurst()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
