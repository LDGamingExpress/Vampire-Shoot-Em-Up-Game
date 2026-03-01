extends CharacterBody2D
var MousePos = Vector2(0,0)
var BulletObj = load("res://Bullet.tscn")
var CanShoot = true
var Health = 10
var Team = "Player"
var ExplosionParticles = load("res://ExplosionParticles.tscn")

var gunPoint = load("res://GunPoint.tscn")

#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(_delta: float) -> void:
	MousePos = get_global_mouse_position()
	
	var posDif = sqrt(pow(MousePos.x - position.x,2) + pow(MousePos.y - position.y,2))
	if posDif < 50:
		position = MousePos
	else:
		position = Vector2(lerp(position.x,MousePos.x,50/posDif),lerp(position.y,MousePos.y,50/posDif))
	
	if Globals.PowerUp == "Laser":
		$LaserCast.enabled = true
		$LaserLine.visible = true
		$LaserParticles.emitting = true
	else:
		$LaserCast.enabled = false
		$LaserLine.visible = false
		$LaserParticles.emitting = false
	
	if $LaserCast.is_colliding():
		if $LaserCast.get_collider() != null:
			var body = $LaserCast.get_collider()
			if body.Team != Team:
				if !body.is_in_group("Skull"):
					body.Health -= 0.1
					body.Damaged()
					var newObj = ExplosionParticles.instantiate()
					newObj.position = body.global_position
					get_parent().add_child(newObj)
					
					var UI = get_parent().get_node("CanvasLayer").get_node("GameUI")
					
					if Team == "Player" and body.Team != "Boss":
						UI.add_score(body.get_node("PointValue").value)
				elif body.is_in_group("Skull"):
					if body.CanDamage:
						body.Health -= 0.1
						body.Damaged()
						var newObj = ExplosionParticles.instantiate()
						newObj.position = body.global_position
						get_parent().add_child(newObj)
						
						var UI = get_parent().get_node("CanvasLayer").get_node("GameUI")
						
						if Team == "Player":
							UI.add_score(body.get_node("PointValue").value)
					else:
						$LaserCast.add_exception(body)
	
	if Input.is_action_pressed("Shoot") and CanShoot and Globals.PowerUp != "Railgun":
		CanShoot = false
		for i in range(0,$Fighter/GunPoints.get_child_count()):
			var newBullet = BulletObj.instantiate()
			newBullet.position = $Fighter/GunPoints.get_child(i).global_position
			newBullet.Frame = 0
			newBullet.rotation = $Fighter/GunPoints.get_child(i).rotation
			newBullet.Team = "Player"
			newBullet.modulate = Color(0.0, 0.0, 1.0, 0.725)
			
			if Globals.PowerUp == "Missile":
				newBullet.get_node("EnemyDetection").monitoring = true
				newBullet.get_node("AnimatedSprite2D").scale = Vector2(.8, .8)
				newBullet.Frame = 1
			if Globals.PowerUp == "Spread":
				newBullet.Frame = 2
			if Globals.PowerUp == "Gauss":
				newBullet.modulate = Color(0.102, 0.878, 1.0, 0.725)
				newBullet.get_node("AnimatedSprite2D").scale = Vector2(3.0, 0.8)
			get_parent().add_child(newBullet)
		
		if Globals.PowerUp == "Gauss" or Globals.PowerUp == "Missile":
			Reload(0.8)
		elif Globals.PowerUp == "Spread":
			Reload(0.2)
		else:
			Reload(0.5)
	elif Input.is_action_pressed("Shoot") and CanShoot and Globals.PowerUp == "Railgun":
		CanShoot = false
		var newBullet = BulletObj.instantiate()
		newBullet.position = global_position
		newBullet.Frame = 1
		newBullet.get_node("AnimatedSprite2D").scale = Vector2(2, 2)
		newBullet.Speed = 1000
		newBullet.rotation = rotation
		newBullet.Team = "Player"
		newBullet.Damage = 10000
		newBullet.modulate = Color(0.365, 0.0, 0.352, 1.0)
		get_parent().add_child(newBullet)
		Reload(20)

func Reload(time : float):
	await get_tree().create_timer(time,false).timeout
	CanShoot = true

func Damaged():
	if Globals.PowerUp == "Shield":
		Health += 1
	if Health <= 0:
		get_parent().get_node("CanvasLayer").get_node("GameUI").Dead()
	
	get_parent().get_node("CanvasLayer").get_node("GameUI").get_node("HealthPanel").get_node("HealthBox").get_node("HealthBar").value = Health

func Heal():
	Health += 5
	if Health > 10:
		Health = 10
	get_parent().get_node("CanvasLayer").get_node("GameUI").get_node("HealthPanel").get_node("HealthBox").get_node("HealthBar").value = Health

func Upgrade(type : String):
	if type == "None":
		if Globals.PowerUp == "Spread":
			$Fighter/GunPoints.get_child(2).queue_free()
			$Fighter/GunPoints.get_child(3).queue_free()
		if Globals.PowerUp == "Shield":
			$Fighter.modulate = Color(1, 1, 1, 1)
	
	if Globals.PowerUp != "Railgun":
		Globals.PowerUp = type
	
	if type == "Spread":	
		var P1 = gunPoint.instantiate()
		var P2 = gunPoint.instantiate()
		
		get_node("Fighter").get_node("GunPoints").add_child.call_deferred(P1)
		get_node("Fighter").get_node("GunPoints").add_child.call_deferred(P2)
		
		P1.position = Vector2(2.0, -10.5)
		P2.position = Vector2(2.0, 10.5)
		
		P1.rotation = $Fighter/GunPoints.get_child(0).rotation - .5
		P2.rotation = $Fighter/GunPoints.get_child(1).rotation + .5
	elif type == "Shield":
		$Fighter.modulate = Color(0, 0.89, 0.9, 1)
	
