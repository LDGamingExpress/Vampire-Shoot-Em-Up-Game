extends Node2D

const PATH := "user://player_data.cfg"
var time = 0.0
var saveTime = 30.0

func _ready() -> void:
	LoadData()

func SaveData():
	var config = ConfigFile.new()
	
	config.set_value("Player", "HScore", Globals.HighScore)
	
	config.save(PATH)

func LoadData():
	var config = ConfigFile.new()
	
	config.load(PATH)
	
	Globals.HighScore = config.get_value("Player", "HScore", 0)

func _process(delta: float) -> void:
	time += delta
	
	if time > saveTime:
		print("Save")
		time = 0.0
		SaveData()
