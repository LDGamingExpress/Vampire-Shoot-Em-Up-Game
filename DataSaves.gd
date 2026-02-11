extends Node2D

const PATH := "user://player_data.cfg"
var time = 0.0
var saveTime = 30.0

func _ready() -> void:
	LoadData()

func SaveData():
	var config = ConfigFile.new()
	
	config.set_value("Player", "HScores", Globals.HighScores)
	
	config.save(PATH)

func LoadData():
	var config = ConfigFile.new()
	
	config.load(PATH)
	
	Globals.HighScores = config.get_value("Player", "HScores", [0, 0, 0, 0, 0, 0, 0, 0])

func _process(delta: float) -> void:
	time += delta
	
	if time > saveTime:
		time = 0.0
		SaveData()
