extends CharacterBody2D
var Team = "Enemy"
# "Player", "Enemy", "Ally"
var Damage = 1
var Speed = Globals.PlayerSpeed + randi_range(0,50) + 20
var Frame = randi_range(0,6)
var ExplosionParticles = load("res://ExplosionParticles.tscn")
var Health = 1
var RotationSpeed = randf_range(-0.05,0.05)

func _ready() -> void:
	velocity = Vector2(Speed * cos(rotation),Speed * sin(rotation))
	$AnimatedSprite2D.frame = Frame
	$AnimatedSprite2D.rotation = randf_range(0,2*PI)
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	rotate(RotationSpeed)
	if position.y > Globals.ScreenSize.y/2:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.Team != "Enemy":
		body.Health -= Damage
		body.Damaged()
		var newObj = ExplosionParticles.instantiate()
		newObj.position = position
		get_parent().add_child(newObj)
		queue_free()

func Damaged():
	if Health <= 0:
		queue_free()
