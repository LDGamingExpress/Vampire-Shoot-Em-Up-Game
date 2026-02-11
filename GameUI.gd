extends Control
var score = 0
var paused = false

func _ready() -> void:
	$ScorePanel/HighScore.text = "High Score: " + str(Globals.HighScore)
	
	$PauseMenu/QuitButton.pressed.connect(menu_button_click.bind("Quit"))
	$PauseMenu/ResumeButton.pressed.connect(menu_button_click.bind("Resume"))
	$PauseMenu/RestartButton.pressed.connect(menu_button_click.bind("Restart"))
	$PauseMenu/MenuButton.pressed.connect(menu_button_click.bind("Menu"))

func add_score(scoreToAdd : int):
	score += scoreToAdd
	$ScorePanel/Score.text = "Score: " + str(score)
	
	if score > Globals.HighScore:
		Globals.HighScore = score
		$ScorePanel/HighScore.text = "High Score: " + str(score)

func _input(event: InputEvent) -> void:
	if InputEvent and event.is_action_pressed("Pause"):
		paused = !paused
		toggle_pause()

func toggle_pause():
	$PauseMenu.visible = paused
	get_tree().paused = paused

func menu_button_click(button : String):
	if button == "Resume":
		paused = false
		toggle_pause()
	elif button == "Quit":
		get_parent().get_parent().get_node("SaveSystem").SaveData()
		get_tree().quit()
	elif button == "Restart":
		paused = false
		toggle_pause()
		get_tree().change_scene_to_file("res://MainGame.tscn")
	elif button == "Menu":
		print("Menu")
		paused = false
		toggle_pause()

func control_slider_toggle(toggled_on: bool) -> void:
	print("Toggled")

func audio_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value - 80.0)

func NewDialog(Speaker,Text):
	if Speaker == "You":
		$DialogPanel/DialogContainer/TextureRect.texture = load("res://Textures/PilotPortrait.png")
	elif Speaker == "HQ":
		$DialogPanel/DialogContainer/TextureRect.texture = load("res://Textures/HQPortrait.png")
	elif Speaker == "Civil Defence":
		$DialogPanel/DialogContainer/TextureRect.texture = load("res://Textures/CivilDefencePortrait.png")
	elif Speaker == "Death":
		$DialogPanel/DialogContainer/TextureRect.texture = load("res://Textures/DeathPortrait.png")
	$DialogPanel/DialogContainer/TextContainer/DialogBox.text = Text
	$DialogPanel/DialogContainer/TextContainer/NameBox.text = Speaker
	$DialogPanel/DialogContainer/TextContainer/DialogBox.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property($DialogPanel/DialogContainer/TextContainer/DialogBox,"visible_ratio",1.0,float(len(Text)) * 0.075)
	#tween.tween_callback(get_parent().get_parent().NextDialog())
	#print(float(len(Text)) * 0.2)
	await get_tree().create_timer(float(len(Text)) * 0.2).timeout
	#print("Bloop2")
	get_parent().get_parent().NextDialog()
