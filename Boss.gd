extends CharacterBody2D
var Team = "Boss"
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = Globals.PlayerSpeed + randi_range(-5,5) + 80
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 1
var BulletObj = load("res://Bullet.tscn")
var Target
var TargetPos

func _ready() -> void:
	Target = get_parent().get_node("Player")
#	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
#	#$AnimatedSprite2D.rotation = randf_range(0,2*PI)
#	await get_tree().create_timer(0.1).timeout
#	$GPUParticles2D.emitting = true
	

func MoveGunPoints():
	if Target != null and TargetPos != null:
		for i in range(0,$GunPoints.get_child_count()):
			var dir = TargetPos - $GunPoints.get_child(i).global_position
			$GunPoints.get_child(i).rotation = dir.angle()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.Team == "Player" or body.Team == "Ally":
		body.Health -= Damage
		body.Damaged()
		var newObj = ExplosionParticles.instantiate()
		newObj.position = position
		get_parent().add_child(newObj)
		$GPUParticles2D.emitting = false
		#queue_free()

func Damaged():
	if Health <= 0:
		$GPUParticles2D.emitting = false
		queue_free()

func FireBurst():
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = $GunPoints.get_child(i).rotation
		newBullet.Team = "Boss"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		newBullet.get_node("AnimatedSprite2D").scale = Vector2(2.0, 2.0)
		newBullet.get_node("Area2D/CollisionShape2D").scale = Vector2(2.0, 2.0)
		get_parent().add_child(newBullet)

func _on_timer_timeout() -> void:
	TargetPos = Target.position
	MoveGunPoints()
	FireBurst()
