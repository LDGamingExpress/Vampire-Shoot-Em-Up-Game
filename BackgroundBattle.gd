extends Node2D
var Obj = load("res://BackgroundBattleObject.tscn")
var EObj = load("res://BackgroundExplosion.tscn")

func _ready() -> void:
	for i in range(0,randi_range(10,15)):
		var NewObj = Obj.instantiate()
		NewObj.position = Vector2(randf_range(-Globals.ScreenSize.x/5,Globals.ScreenSize.x/5),randf_range(-Globals.ScreenSize.y/5,Globals.ScreenSize.y/5))
		call_deferred("add_child",NewObj)


func _on_ship_timer_timeout() -> void:
	$ShipTimer.wait_time = randf_range(3.0,6.0)
	for i in range(0,randi_range(5,8)):
		var NewObj = Obj.instantiate()
		NewObj.position = Vector2(randf_range(-Globals.ScreenSize.x/5,Globals.ScreenSize.x/5),randf_range(-Globals.ScreenSize.y/5,Globals.ScreenSize.y/5))
		call_deferred("add_child",NewObj)


func _on_explosion_timer_timeout() -> void:
	$ExplosionTimer.wait_time = randf_range(1.0,3.0)
	for i in range(0,randi_range(5,8)):
		var NewObjE = EObj.instantiate()
		NewObjE.global_position = Vector2(randf_range(-Globals.ScreenSize.x/4,Globals.ScreenSize.x/4),randf_range(-Globals.ScreenSize.y/4,Globals.ScreenSize.y/4))
		call_deferred("add_child",NewObjE)
		await get_tree().create_timer(0.1,false).timeout
