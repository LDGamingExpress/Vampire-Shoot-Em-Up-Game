extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 5
var Speed = Globals.PlayerSpeed + randi_range(-5,5)
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 5
var BulletObj = load("res://Bullet.tscn")
var CanDamage = false
var XPosWant = 400.0
var SignTimesRotation = 1

var LabelText = load("res://ScoreLabel.tscn")

func _ready() -> void:
	if randi_range(0,100) > 50:
		XPosWant = 400.0
		SignTimesRotation = 1
	else:
		XPosWant = -400.0
		SignTimesRotation = -1
	velocity = Vector2(Speed * cos(rotation - (PI/2.5 * SignTimesRotation)),Speed * sin(rotation - (PI/2.5 * SignTimesRotation)))
	#$AnimatedSprite2D.rotation = randf_range(0,2*PI)
	await get_tree().create_timer(0.1).timeout
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(2.5).timeout
	Speed = Globals.PlayerSpeed + randi_range(-5,5) - 60
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	if XPosWant > 0 and position.x >= XPosWant:
		XPosWant = -400
		SignTimesRotation = -1
		velocity = Vector2(Speed * cos(rotation - (PI/2.5 * SignTimesRotation)),Speed * sin(rotation - PI/2.5 * SignTimesRotation))
	elif XPosWant < 0 and position.x <= XPosWant:
		XPosWant = 400
		SignTimesRotation = 1
		velocity = Vector2(Speed * cos(rotation - (PI/2.5 * SignTimesRotation)),Speed * sin(rotation - PI/2.5 * SignTimesRotation))
	if $Turrets.get_child_count() == 0:
		CanDamage = true
	if position.y > Globals.ScreenSize.y/2:
		$GPUParticles2D.emitting = false
		queue_free()

func Damaged():
	if Health <= 0:
		$GPUParticles2D.emitting = false
		var newObj = LabelText.instantiate()
		newObj.position = global_position
		newObj.text = ("+" + str($PointValue.value))
		get_parent().add_child(newObj)
		queue_free()
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.25)
		await get_tree().create_timer(0.25).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)
