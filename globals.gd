extends Node
var PlayerSpeed = 100
var CameraZoom = 2.0
var ScreenSize = DisplayServer.window_get_size()
var PlanetType = "Alive"
# Alive, Dead, Mixed
var Biome = "Continental"
# Continental, Arctic, Desert

var PowerUp : String = "None"

var HighScore = 0

var levels = [preload("res://MainGame.tscn")]
var currentLevel = 0

func LoadLevel():
	get_tree().change_scene_to_packed(levels[currentLevel])
