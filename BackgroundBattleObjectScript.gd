extends CharacterBody2D
var SPEED = Globals.PlayerSpeed + randf_range(30.0,80.0)

func _ready() -> void:
	scale.x = randf_range(0.5,1.5)
	scale.y = scale.x
	$AnimatedSprite2D.frame = randi_range(0,8)
	rotation = randf_range(0,2*PI)
	position = Vector2(Globals.ScreenSize.x/2 * cos(rotation + PI),Globals.ScreenSize.x/2 * sin(rotation + PI))
	velocity = Vector2(SPEED * cos(rotation),SPEED * sin(rotation))

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
