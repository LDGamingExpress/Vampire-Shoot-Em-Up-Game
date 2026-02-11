extends CharacterBody2D
var BulletObj = load("res://Bullet.tscn")

func FireBurst():
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = rotation
		newBullet.Team = "Enemy"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		get_parent().add_child(newBullet)
	await get_tree().create_timer(0.2).timeout
	for i in range(0,$GunPoints.get_child_count()):
		var newBullet = BulletObj.instantiate()
		newBullet.position = $GunPoints.get_child(i).global_position
		newBullet.Frame = 0
		newBullet.rotation = rotation
		newBullet.Team = "Enemy"
		newBullet.modulate = Color(1.0, 0.0, 0.102, 0.725)
		get_parent().add_child(newBullet)

func _on_timer_timeout() -> void:
	FireBurst()
