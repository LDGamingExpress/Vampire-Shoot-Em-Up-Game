extends Node2D
var LevelStageEnemies = [["Pause",0,0,5.0],
["Bat",8,16,3.0],
["BatL",4,12,2.0],
["Fang",10,20,5.0],
["Eye",5,10,3.0],
["Asteroid",10,10,1.0],
["Pause",0,0,10.0],
["EyeL",3,3,1.0],
["EyeR",3,3,1.0],
["Fang",10,20,5.0],
["Asteroid",10,10,1.0],
["Eye",5,10,3.0],
["BatL",5,10,2.0],
["BatR",5,10,2.0],
["Fang",5,10,2.5],
["EyeL",6,12,10.0],
["EyeR",6,12,10.0],
["Pause",0,0,10.0],
["Bat",10,40,1.5],
["Fang",6,18,3.0],
["Asteroid",10,10,1.0],
["Fang",6,18,2.5],
["EyeL",6,12,3.0],
["EyeR",6,12,3.0],
]
# Format: ["Enemy Type", Enemies spawned in each wave, total enemies needed, time between waves]
var LevelBackground = ["Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space","Space"]
# Space, Continental, Arctic, Desert

var Dialog = [["HQ","You're coming up to the command ship."],
["HQ","Be careful there are bound to be many enemies in this area."],
["You","Copy that guns ready."],
["Pause",30],
["HQ","There it is! Get the r..."],
["Boss","We've taken over your communications surrender now or die."],
["You","Never."],
["Pause",20],
["Boss","You won't make it past this."],
["Pause",30],
["Boss","DIE ALREADY!"],
["Pause",15],
["HQ","Communications back online sir. Great, ready the railgun"],
["HQ","Now pilot take out the command ship"],
["You","Copy"],
]

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
		await get_tree().create_timer(15).timeout
		$CanvasLayer/GameUI.EndLevel()
	
	

func _on_music_player_finished() -> void:
	$MusicPlayer.stream = load(Music2Play)
	$MusicPlayer.play()
