extends Node2D
var LevelStageEnemies = [["Pause",1,1,3.0],
["Bat",6,18,2.0],
["Fang",3,6,1.5],
["BatL",4,4,1.0],
["FangL",3,3,3.0],
["BatL",4,4,1.0],
["FangL",3,3,3.0],
["BatR",4,4,1.0],
["FangR",3,3,3.0],
["Eye",2,2,2.0],
["FangL",3,3,0.0],
["FangR",3,3,3.0],
["Bat",6,6,1.0],
["Eye",2,2,2.0],
["Fang",5,5,1.5],
["BatL",10,10,0.0],
["FangL",3,3,2.0],
["Eye",1,2,1.5],
["BatR",10,10,0.0],
["FangR",2,2,2.0],
["Bat",12,12,0.5],
["Fang",2,2,0.5],
["FangL",1,1,0.0],
["FangR",1,1,0.5],
["Eye",1,1,2.0],
["Bat",12,12,0.5],
["Fang",2,2,0.5],
["FangL",1,1,0.0],
["FangR",1,1,0.5],
["Eye",1,1,2.0],
["FangL",4,12,1.0],
["FangR",4,12,1.0],
["EyeL",2,2,1.0],
["EyeR",2,2,1.0],
["Bat",12,12,0.5],
["Fang",2,2,0.5],
["FangL",1,1,0.0],
["FangR",1,1,0.5],
["Eye",2,2,2.0],
["Bat",12,12,0.5],
["Fang",2,2,0.5],
["FangL",1,1,0.0],
["FangR",1,1,0.5],
["Eye",2,2,2.0],
["Bat",12,12,0.5],
["Fang",3,3,0.5],
["Bat",12,12,0.5],
["Fang",3,3,0.5],
["FangL",5,5,0.0],
["FangR",5,5,0.5],
["Eye",2,2,3.0],
["BatL",10,10,0.0],
["FangL",3,3,2.0],
["Eye",2,4,1.5],
["BatR",10,10,0.0],
["FangR",3,3,2.0],
["Bat",12,36,2.5],
["Fang",3,9,1.8],
["Eye",1,2,1.5],
["Fang",1,2,0.5],
["FangL",2,2,0.0],
["FangR",2,2,0.5],
["Bat",10,30,2.5],
["Eye",1,2,1.5],
["Skull",1,1,8.0],
["Bat",3,12,3.0],
["Fang",1,4,2.0],
["Bat",3,15,3.0]
]
# Format: ["Enemy Type", Enemies spawned in each wave, total enemies needed, time between waves]
var LevelBackground = ["Arctic"]
# Space, Continental, Arctic, Desert

var Dialog = [["HQ","Much of the planet has been decimated. Expect heavy resistance."],
["You","Understood, engaging hostiles."],
["Pause",60],
["Death","So, there is still some fight left in these weaklings."],
["Death","No matter. I'm sure even a single Skull Destroyer can anihilate such a paltry force."],
["You","Skull Destroyer? What kind of ship name is that?"],
["You","Oh..."],
["Pause",34],
["Death","It seems I was mistaken. You won't be so lucky next time, Pilot."],
["HQ","Excellent work! Reroute for the Rendalan Shipyards!"]
]

var DialogStage = 0

var CurrentEnemiesDone = 0
var Stage = 0
var Asteroid = load("res://Asteroid.tscn")
var Bat = load("res://Bat.tscn")
var Fang = load("res://FangFighter.tscn")
var FangMK2 = load("res://FangFighterMK2.tscn")
var Eye = load("res://SinfulEye.tscn")
var Skull = load("res://VengefulSkull.tscn")
var Zep = load("res://Zeppelin.tscn")
var Centipede = load("res://Centipede.tscn")

var powerUp = load("res://PowerUp.tscn")
var time := 0.0
var time2 := 0.0
var finishTime := 0.0
var finishTime2 := 10.0
var Health = load("res://HealthPickup.tscn")

var Music2Play = "res://Music/Darkness of Space.mp3"

func _ready() -> void:
	Globals.PlanetType = "Mixed"
	NextDialog()
	if LevelBackground[0] == "Space":
		$TileBackground.visible = false
		$TileBackground.queue_free()
	else:
		$BackgroundObjects.queue_free()
	Globals.Biome = LevelBackground[0]
	$TileBackground.GenerateNew()
	await get_tree().create_timer(LevelStageEnemies[0][3],false).timeout
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
				CurrentEnemiesDone += 1
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
			"Skull":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnSkull()
			"Zep":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnZep()
			"ZepL":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnZepL()
			"ZepR":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnZepR()
			"Centipede":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnCentipede()
			"FangMK2":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnFangFighterMK2()
			"FangMK2L":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnFangFighterMK2L()
			"FanMK2gR":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnFangFighterMK2R()
		await get_tree().create_timer(LevelStageEnemies[Stage][3],false).timeout
		EnemySpawner()
	elif $CanvasLayer/GameUI/CompleteLevel.visible == false:
		await get_tree().create_timer(20,false).timeout
		$CanvasLayer/GameUI.EndLevel()

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

func SpawnZep():
	var newObj = Zep.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func SpawnZepL():
	var newObj = Zep.instantiate()
	newObj.position = Vector2(-Globals.ScreenSize.x/3.0,-randf_range(0,Globals.ScreenSize.y/5.0))
	newObj.rotation = 0
	call_deferred("add_child",newObj)

func SpawnZepR():
	var newObj = Zep.instantiate()
	newObj.position = Vector2(Globals.ScreenSize.x/3.0,-randf_range(0,Globals.ScreenSize.y/5.0))
	newObj.rotation = PI
	call_deferred("add_child",newObj)

func SpawnCentipede():
	var newObj = Centipede.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func _process(delta: float) -> void:
	time += delta
	time2 += delta
	
	if time > finishTime:
		var newObj = powerUp.instantiate()
		newObj.position = Vector2(randf_range(-250, 250),-Globals.ScreenSize.y/2)
		call_deferred("add_child", newObj)
		
		time = 0.0
		finishTime = randf_range(20.0, 40.0)
	
	if time2 > finishTime2:
		var newObj = Health.instantiate()
		newObj.position = Vector2(randf_range(-250, 250),-Globals.ScreenSize.y/2)
		call_deferred("add_child", newObj)
		
		time2 = 0.0
		finishTime2 = randf_range(25.0, 32.0)

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

func SpawnFangFighterMK2():
	var newObj = FangMK2.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func SpawnFangFighterMK2L():
	var newObj = FangMK2.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/2.0,0),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/4
	call_deferred("add_child",newObj)

func SpawnFangFighterMK2R():
	var newObj = FangMK2.instantiate()
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

func SpawnSkull():
	var newObj = Skull.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func NextDialog():
	#print("Bloop")
	if DialogStage < len(Dialog):
		if Dialog[DialogStage][0] == "Pause":
			$CanvasLayer/GameUI/DialogPanel.visible = false
			await get_tree().create_timer(Dialog[DialogStage][1],false).timeout
			DialogStage += 1
			NextDialog()
		else:
			$CanvasLayer/GameUI.NewDialog(Dialog[DialogStage][0],Dialog[DialogStage][1])
			$CanvasLayer/GameUI/DialogPanel.visible = true
			DialogStage += 1


func _on_music_player_finished() -> void:
	$MusicPlayer.stream = load(Music2Play)
	$MusicPlayer.play()
