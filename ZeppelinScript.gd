extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 2
var Speed = Globals.PlayerSpeed + randi_range(-5,5) - 60
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 2
var CanDamage = false

var LabelText = load("res://ScoreLabel.tscn")

func _ready() -> void:
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	#$AnimatedSprite2D.rotation = randf_range(0,2*PI)
	await get_tree().create_timer(0.1).timeout
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	#await get_tree().create_timer(2.5).timeout
	#Speed = Globals.PlayerSpeed + randi_range(-5,5) - 60
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	if $Turrets.get_child_count() == 0:
		CanDamage = true
	if position.y > Globals.ScreenSize.y/2 or (velocity.x > 0 and position.x > Globals.ScreenSize.x) or (velocity.x < 0 and position.x < -Globals.ScreenSize.x):
		$GPUParticles2D.emitting = false
		queue_free()

func Damaged():
	if Health <= 0:
		$GPUParticles2D.emitting = false
		var newObj = LabelText.instantiate()
		newObj.position = global_position
		newObj.text = ("+" + str($PointValue.value))
		get_parent().add_child(newObj)
		for i in range(0,3):
			var newE = ExplosionParticles.instantiate()
			newE.position = position + Vector2(randf_range(-64,64),randf_range(-32,32))
			get_parent().add_child(newE)
		queue_free()
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.25)
		await get_tree().create_timer(0.25).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)
