extends Node2D
var LevelStageEnemies = [["Asteroid",3,30,2.0],["Asteroid",10,100,3.0]]
# Format: ["Enemy Type", Enemies spawned in each wave, total enemies needed, time between waves]
var CurrentEnemiesDone = 0
var Stage = 0
var Asteroid = load("res://Asteroid.tscn")

func _ready() -> void:
	await get_tree().create_timer(LevelStageEnemies[0][3]).timeout
	EnemySpawner()

func EnemySpawner():
	if CurrentEnemiesDone >= LevelStageEnemies[Stage][2]:
		Stage += 1
	if Stage < len(LevelStageEnemies):
		match LevelStageEnemies[Stage][0]:
			"Asteroid":
				for i in range(0,LevelStageEnemies[Stage][1]):
					CurrentEnemiesDone += 1
					SpawnAsteroid()
		await get_tree().create_timer(LevelStageEnemies[Stage][3]).timeout
		EnemySpawner()

func SpawnAsteroid():
	var newObj = Asteroid.instantiate()
	newObj.position = Vector2(randf_range(-Globals.ScreenSize.x/2.0,Globals.ScreenSize.x/2.0),-Globals.ScreenSize.y/2)
	newObj.rotation = PI/2
	call_deferred("add_child",newObj)
