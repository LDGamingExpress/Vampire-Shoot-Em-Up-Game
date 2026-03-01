extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = Globals.PlayerSpeed - 10
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 1
var BulletObj = load("res://Bullet.tscn")
var SegmentNumber = 0
var PreviousSegment = null
var PreviousSegmentX = null
var WiggleDir = 10
var WiggleCounter = 0.0

var LabelText = load("res://ScoreLabel.tscn")

func _ready() -> void:
	#print(SegmentNumber)
	#print(position)
	if SegmentNumber == 0:
		$AnimatedSprite2D.frame = 0
	else:
		$AnimatedSprite2D.frame = randi_range(1,2)
	if $AnimatedSprite2D.frame == 2:
		var NewT = load("res://Turret.tscn").instantiate()
		NewT.Type = 1
		$Turrets.add_child(NewT)
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	#$AnimatedSprite2D.rotation = randf_range(0,2*PI)
	if PreviousSegment != null:
		PreviousSegmentX = PreviousSegment.position.x
	if SegmentNumber < 5:
		#print("NewC")
		var newC = load("res://Centipede.tscn").instantiate()
		newC.position = position + Vector2(0,-32)
		newC.SegmentNumber = SegmentNumber + 1
		newC.PreviousSegment = self
		newC.rotation = rotation
		match(WiggleDir):
			10:
				newC.WiggleDir = 0
			0:
				if randi_range(0,100) > 50:
					newC.WiggleDir = 10
				else:
					newC.WiggleDir = -10
			-10:
				newC.WiggleDir = 0
		get_parent().add_child(newC)

func _physics_process(delta: float) -> void:
	if PreviousSegment != null:
	#	print(position.x)
		position.x += PreviousSegment.position.x - PreviousSegmentX
		PreviousSegmentX = PreviousSegment.position.x
	if WiggleDir == 10:
		position.x += delta * 10.0
		WiggleCounter += delta * 10.0
		if WiggleCounter >= 10.0:
			WiggleDir = -10
			WiggleCounter = 0.0
	else:
		position.x -= delta * 10.0
		WiggleCounter += delta * 10.0
		if WiggleCounter >= 10.0:
			WiggleDir = 10
			WiggleCounter = 0.0
	move_and_slide()
	
	if position.y > Globals.ScreenSize.y/2:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.Team == "Player" or body.Team == "Ally":
		body.Health -= Damage
		body.Damaged()
		var newObj = ExplosionParticles.instantiate()
		newObj.position = position
		get_parent().add_child(newObj)
		queue_free()

func Damaged():
	if Health <= 0:
		var newObj = LabelText.instantiate()
		newObj.position = global_position
		newObj.text = ("+" + str($PointValue.value))
		get_parent().add_child(newObj)
		queue_free()
