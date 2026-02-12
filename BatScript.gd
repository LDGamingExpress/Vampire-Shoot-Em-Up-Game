extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = Globals.PlayerSpeed + randi_range(-5,5) + 100
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 1

var LabelText = load("res://ScoreLabel.tscn")

func _ready() -> void:
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	#$AnimatedSprite2D.rotation = randf_range(0,2*PI)
	await get_tree().create_timer(0.1).timeout
	$GPUParticles2D.emitting = true
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > Globals.ScreenSize.y/2:
		$GPUParticles2D.emitting = false
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.Team == "Player" or body.Team == "Ally":
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
		var newObj = LabelText.instantiate()
		newObj.position = global_position
		newObj.text = ("+" + str($PointValue.value))
		get_parent().add_child(newObj)
		queue_free()
