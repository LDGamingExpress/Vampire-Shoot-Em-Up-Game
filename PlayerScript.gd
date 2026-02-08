extends CharacterBody2D
var MousePos = Vector2(0,0)
var BulletObj = load("res://Bullet.tscn")
var CanShoot = true
var Health = 10
var Team = "Player"

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
	
	if Input.is_action_pressed("Shoot") and CanShoot:
		CanShoot = false
		for i in range(0,$Fighter/GunPoints.get_child_count()):
			var newBullet = BulletObj.instantiate()
			newBullet.position = $Fighter/GunPoints.get_child(i).global_position
			newBullet.Frame = 0
			newBullet.rotation = $Fighter/GunPoints.get_child(i).rotation
			newBullet.Team = "Player"
			newBullet.modulate = Color(0.0, 0.0, 1.0, 0.725)
			get_parent().add_child(newBullet)
		
		if Globals.PowerUp != "Laser":
			Reload(0.2)
		else:
			Reload(1.0)

func Reload(time : float):
	await get_tree().create_timer(time).timeout
	CanShoot = true

func Damaged():
	if Health <= 0:
		print("You Died!")


func Upgrade(type : String):
	if type == "None":
		if Globals.PowerUp == "Spread":
			$Fighter/GunPoints.get_child(2).queue_free()
			$Fighter/GunPoints.get_child(3).queue_free()
	
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
	
	
