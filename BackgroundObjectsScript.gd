extends Node2D
var BGObj = load("res://BackgroundObject.tscn")
var BGObjects = []

func _ready() -> void:
	for i in range(0,35):
		var newObj = BGObj.instantiate()
		newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/2.0,Globals.ScreenSize.x/2.0),randf_range(-Globals.ScreenSize.y,Globals.ScreenSize.y))
		newObj.frame = randi_range(0,7)
		newObj.rotation = randf_range(0,2*PI)
		var newScale = randf_range(1,1.5)
		newObj.scale = Vector2(newScale,newScale)
		add_child(newObj)
		BGObjects.append(newObj)

func _process(delta: float) -> void:
	for i in range(0,len(BGObjects)):
		var CurrentNode = BGObjects[i]
		CurrentNode.position.y += Globals.PlayerSpeed*delta
		if CurrentNode.position.y > Globals.ScreenSize.y/2:
			CurrentNode.position.y = -Globals.ScreenSize.y/2
