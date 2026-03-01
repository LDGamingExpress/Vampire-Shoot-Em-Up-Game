extends Node2D
var LevelStageEnemies = [["Pause",0,0,50.0],
["Asteroid",3,6,2.0],
["Asteroid",3,30,3.0],
["Asteroid",10,10,20.0],
["Bat",5,10,5.0],
["BatL",5,5,2.0],
["BatR",5,5,10.0],
["Bat",8,24,6.0],
["Fang",2,8,5.0],
["BatL",5,5,1.0],
["FangL",2,4,5.0],
["BatR",5,5,1.0],
["FangR",2,4,5.0],
["Fang",6,12,3.0],
["FangL",2,4,1.0],
["Bat",5,5,1.0],
["FangR",2,4,1.0],
["Bat",15,15,1.0],
["BatL",6,6,2.0],
["BatR",6,6,10.0],
["Eye",1,2,2.0],
["Fang",6,6,2.0],
["BatL",10,10,1.0],
["BatR",10,10,5.0],
["Eye",2,4,2.0],
["EyeL",1,1,1.0],
["EyeR",1,1,1.0],
["Bat",12,12,2.0],
["Fang",8,8,2.0],
["FangL",2,4,1.0],
["Bat",5,5,1.0],
["FangR",2,4,1.0],
["Eye",3,3,2.0],
["Fang",12,12,1.0],
["FangL",3,6,1.5],
["FangR",3,6,1.5],
["Bat",15,15,1.0],
["Fang",3,3,1.0],
["Bat",15,15,1.0],
["Fang",3,3,1.0],
["EyeL",1,2,2.0],
["Bat",5,10,1.0],
["Bat",12,12,2.0],
["Fang",5,5,2.0],
["FangL",3,6,1.0],
["Bat",5,5,1.0],
["FangR",2,4,1.0],
["Eye",2,4,2.0],
["Fang",10,20,2.0],
["Bat",5,10,2.0],
["Fang",2,6,2.0],
["Eye",1,1,2.0],
["Bat",10,20,3.0],
["Fang",2,6,2.0],
["BatL",5,15,2.0],
["BatR",5,15,2.0],
["Bat",3,30,1.5],
["Fang",2,4,3.0],
["Bat",5,30,1.5],
["Bat",2,10,2.0],
["Fang",2,6,2.5],
]
# Format: ["Enemy Type", Enemies spawned in each wave, total enemies needed, time between waves]
var LevelBackground = ["Arctic","Arctic","Arctic","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Continental","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert","Desert"]
# Space, Continental, Arctic, Desert

var Dialog = [["HQ","Welcome to the Slice, pilot! This is the only settled Tidally Locked Planet in the Colonies."],
["HQ","Only a small portion of the planet can support life, but its still our home."],
["HQ","Some asteroids seem to be entering the atmosphere, so try using them for some target practice."],
["You","Roger that, charging lasers."],
["Pause",30],
["HQ","You should be passing over Nova Poltava - home to plenty of cities and - "],
["You","What the hell?"],
["Civil Defence","INCOMING, INCOMING, INCOMING! Unknown aircraft have started attacking Nova Poltava!"],
["You","HQ, come in! Please respond!"],
["Pause",10],
["Civil Defence","They're getting in-        -are dead. They were torn to pieces and not a drop of blood was left! Please someone help us!"],
["Pause",85],
["HQ","Pilot, are you still out there?"],
["You","Affirmative, HQ. What's attacking us and how is it even night on this side of planet?"],
["HQ","A race of hemovores, or 'Vampires,' has launched a surprise attack throughout the Colonies."],
["HQ","They have a starship that appears to be blotting out the Sun to leave us in darkness."],
["You","How is that even - Nevermind, what's the plan?"],
["HQ","Once you finish up these last stragglers here on the Slice, we need you to lead a counter attack starting from the inner colony of Bounty."],
["HQ","With each planet retaken, you'll be one step closer to the center of the system and destroying their flagship."],
["You","Understood, HQ. This should be the last of them. I'll head out for Bounty now."]
]

var DialogStage = 0

var CurrentEnemiesDone = 0
var Stage = 0
var Asteroid = load("res://Asteroid.tscn")
var Bat = load("res://Bat.tscn")
var Fang = load("res://FangFighter.tscn")
var Eye = load("res://SinfulEye.tscn")
var Explosion = load("res://ExplosionParticles.tscn")
var Skull = load("res://VengefulSkull.tscn")

var powerUp = load("res://PowerUp.tscn")
var time := 0.0
var time2 := 0.0
var finishTime := 0.0
var finishTime2 := 10.0
var Health = load("res://HealthPickup.tscn")

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
			"Skull":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnSkull()
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
		finishTime2 = randf_range(60.0, 100.0)

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

func SpawnSkull():
	var newObj = Skull.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.5,Globals.ScreenSize.x/4.5),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)

func NextDialog():
	
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
	if DialogStage == 6:
		await get_tree().create_timer(5.1,false).timeout
		MusicChange()
		for i in range(0,35):
			var NewObj = Explosion.instantiate()
			NewObj.position = Vector2(randf_range(-Globals.ScreenSize.x/4.0,Globals.ScreenSize.x/4.0),randf_range(-Globals.ScreenSize.y/4.0,Globals.ScreenSize.y/4.0))
			add_child(NewObj)
			await get_tree().create_timer(randf_range(0.1,0.5)).timeout

func MusicChange():
	await get_tree().create_timer(0.5,false).timeout
	Music2Play = "res://Music/Invasion.mp3"
	Globals.PlanetType = "Dead"
	var tween = get_tree().create_tween()
	tween.tween_property($MusicPlayer, "volume_linear", 0.0, 0.8)
	await get_tree().create_timer(0.8,false).timeout
	_on_music_player_finished()
	var tween2 = get_tree().create_tween()
	tween2.tween_property($MusicPlayer, "volume_linear", 1.0, 0.8)
	await get_tree().create_timer(0.8,false).timeout
	Music2Play = "res://Music/Fallen Souls.mp3"

func _on_music_player_finished() -> void:
	$MusicPlayer.stream = load(Music2Play)
	$MusicPlayer.play()
