extends Node2D
var LevelStageEnemies = [["Pause",0,0,10.0],
["Asteroid",5,10,2.0],
["Asteroid",10,30,3.0],
["Bat",5,10,5.0],
["Eye",3,6,2.0],
["BatL",4,12,2.0],
["BatR",4,12,2.0],
["Asteroid",10,10,3.0],
["EyeL",3,3,1.0],
["EyeR",3,3,1.0],
["Fang",2,6,2.0],
["Asteroid",10,10,3.0],
["BatL",5,15,2.0],
["BatR",5,15,2.0],
["Bat",3,30,1.5],
["Fang",2,4,3.0],
["Asteroid",10,10,3.0],
["Fang",2,4,2.5],
["EyeL",3,6,3.0],
["EyeR",3,6,3.0],
]
# Format: ["Enemy Type", Enemies spawned in each wave, total enemies needed, time between waves]
var LevelBackground = ["Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space"]
# Space, Continental, Arctic, Desert

var Dialog = [["HQ","Welcome to the final fronteir."],
["HQ","The autopilot has been programmed to take you to the inner system."],
["HQ","Remember theres no help out here so stay safe and godspeed."],
["You","Copy."],
["Pause",85],
["HQ","Good you've made it. Now get down there and do what you do best."],
["You","Roger Roger."],
]
var movePlanet = false

var DialogStage = 0

var CurrentEnemiesDone = 0
var Stage = 0
var Asteroid = load("res://Asteroid.tscn")
var Bat = load("res://Bat.tscn")
var Fang = load("res://FangFighter.tscn")
var Eye = load("res://SinfulEye.tscn")
var Explosion = load("res://ExplosionParticles.tscn")

var powerUp = load("res://PowerUp.tscn")
var time := 0.0
var finishTime := 0.0

var Music2Play = "res://Music/On A Mission.mp3"

func _ready() -> void:
	Globals.PlanetType = "Alive"
	NextDialog()
	if LevelBackground[0] == "Space":
		$TileBackground.visible = false
		$TileBackground.queue_free()
	else:
		$BackgroundObjects.queue_free()
	Globals.Biome = LevelBackground[0]
	$TileBackground.GenerateNew()
	await get_tree().create_timer(LevelStageEnemies[0][3]).timeout
	EnemySpawner()

func EnemySpawner():
	if CurrentEnemiesDone >= LevelStageEnemies[Stage][2]:
		Stage += 1
		CurrentEnemiesDone = 0
		if len(LevelBackground) > Stage:
			Globals.Biome = LevelBackground[Stage]
	if Stage < len(LevelStageEnemies):
		match LevelStageEnemies[Stage][0]:
			"Pause":
				pass
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

func NextDialog():
	
	if DialogStage < len(Dialog):
		if Dialog[DialogStage][0] == "Pause":
			$CanvasLayer/GameUI/DialogPanel.visible = false
			await get_tree().create_timer(Dialog[DialogStage][1]).timeout
			DialogStage += 1
			NextDialog()
		else:
			$CanvasLayer/GameUI.NewDialog(Dialog[DialogStage][0],Dialog[DialogStage][1])
			$CanvasLayer/GameUI/DialogPanel.visible = true
			DialogStage += 1
	if DialogStage == 8:
		await get_tree().create_timer(3.5).timeout
		Music2Play = "res://Music/Invasion.mp3"
		Globals.PlanetType = "Dead"
		var tween = get_tree().create_tween()
		tween.tween_property($MusicPlayer, "volume_linear", 0.0, 0.8)
		await get_tree().create_timer(0.8).timeout
		_on_music_player_finished()
		var tween2 = get_tree().create_tween()
		tween2.tween_property($MusicPlayer, "volume_linear", 1.0, 0.8)
		await get_tree().create_timer(0.8).timeout
		Music2Play = "res://Music/Fallen Souls.mp3"
	elif DialogStage == Dialog.size() - 1:
		movePlanet = true
		await get_tree().create_timer(15).timeout
		$CanvasLayer/GameUI.EndLevel()
	
	
func _physics_process(delta: float) -> void:
	if movePlanet:
		$Mygeeto.position = $Mygeeto.position.lerp(Vector2(216, -110), .01)
		if$Mygeeto.position == Vector2(216, -110):
			movePlanet = false
	


func _on_music_player_finished() -> void:
	$MusicPlayer.stream = load(Music2Play)
	$MusicPlayer.play()
