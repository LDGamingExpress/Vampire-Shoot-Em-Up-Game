extends Node2D
var LevelStageEnemies = [["Asteroid",3,3,2.0],
["Eye",2,10,1.0],
["Bat",5,10,1.5],
["Fang",3,15,3.0],
["BatL",5,50,1.5],
["EyeR",2,10,1.0],
["FangL",3,15,2.0],
["BatR",5,50,1.5],
["EyeL",2,10,1.0],
["FangR",3,15,2.0],
["Asteroid",10,100,3.0]]
# Format: ["Enemy Type", Enemies spawned in each wave, total enemies needed, time between waves]
var LevelBackground = ["Continental","Arctic","Continental","Desert","Arctic","Arctic","Arctic","Arctic","Arctic","Arctic","Arctic","Arctic","Arctic"]
var CurrentEnemiesDone = 0
var Stage = 0
var Asteroid = load("res://Asteroid.tscn")
var Bat = load("res://Bat.tscn")
var Fang = load("res://FangFighter.tscn")
var Eye = load("res://SinfulEye.tscn")

var powerUp = load("res://PowerUp.tscn")
var time := 0.0
var finishTime := 0.0

func _ready() -> void:
	await get_tree().create_timer(LevelStageEnemies[0][3]).timeout
	EnemySpawner()
	if LevelBackground[0] == "Space":
		$TileBackground.visible = false
		$TileBackground.queue_free()
	else:
		$BackgroundObjects.queue_free()
	Globals.Biome = LevelBackground[0]

func EnemySpawner():
	if CurrentEnemiesDone >= LevelStageEnemies[Stage][2]:
		Stage += 1
		CurrentEnemiesDone = 0
		Globals.Biome = LevelBackground[Stage]
	if Stage < len(LevelStageEnemies):
		match LevelStageEnemies[Stage][0]:
			"Asteroid":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnAsteroid()
			"Bat":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnBat()
			"BatL":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnBatL()
			"BatR":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnBatR()
			"Fang":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnFangFighter()
			"FangL":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnFangFighterL()
			"FangR":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnFangFighterR()
			"Eye":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnEye()
			"EyeL":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnEyeL()
			"EyeR":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnEyeR()
		await get_tree().create_timer(LevelStageEnemies[Stage][3]).timeout
		EnemySpawner()

func SpawnAsteroid():
	var newObj = Asteroid.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func SpawnBat():
	var newObj = Bat.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func SpawnBatL():
	var newObj = Bat.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/2.0,0),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/4
	call_deferred("add_child",newObj)

func SpawnBatR():
	var newObj = Bat.instantiate()
	newObj.position = Vector2(randf_range(0,Globals.ScreenSize.x/2.0),-Globals.ScreenSize.y/2)
	newObj.rotation = 3*PI/4
	call_deferred("add_child",newObj)

func _process(delta: float) -> void:
	time += delta
	
	if time > finishTime:
		var newObj = powerUp.instantiate()
		newObj.position = Vector2(randf_range(-250, 250),-Globals.ScreenSize.y/2)
		call_deferred("add_child", newObj)
		
		time = 0.0
		finishTime = randf_range(20.0, 40.0)

func SpawnFangFighter():
	var newObj = Fang.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func SpawnFangFighterL():
	var newObj = Fang.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/2.0,0),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/4
	call_deferred("add_child",newObj)

func SpawnFangFighterR():
	var newObj = Fang.instantiate()
	newObj.position = Vector2(randf_range(0,Globals.ScreenSize.x/2.0),-Globals.ScreenSize.y/2)
	newObj.rotation = 3*PI/4
	call_deferred("add_child",newObj)

func SpawnEye():
	var newObj = Eye.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func SpawnEyeL():
	var newObj = Eye.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/2.0,0),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/4
	call_deferred("add_child",newObj)

func SpawnEyeR():
	var newObj = Eye.instantiate()
	newObj.position = Vector2(randf_range(0,Globals.ScreenSize.x/2.0),-Globals.ScreenSize.y/2)
	newObj.rotation = 3*PI/4
	call_deferred("add_child",newObj)
