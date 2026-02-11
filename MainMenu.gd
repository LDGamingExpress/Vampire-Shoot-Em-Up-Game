extends Control

func _ready() -> void:
	$MainButtons/PlayButton.pressed.connect(menu_button_click.bind("Play"))
	$MainButtons/LevelsButton.pressed.connect(menu_button_click.bind("Levels"))
	$MainButtons/SettingsButton.pressed.connect(menu_button_click.bind("Settings"))
	$MainButtons/QuitButton.pressed.connect(menu_button_click.bind("Quit"))
	
	$LevelsPanel/Level1.pressed.connect(select_level.bind(0))
	$LevelsPanel/Level2.pressed.connect(select_level.bind(1))
	$LevelsPanel/Level3.pressed.connect(select_level.bind(2))
	$LevelsPanel/Level4.pressed.connect(select_level.bind(3))
	$LevelsPanel/Level5.pressed.connect(select_level.bind(4))
	$LevelsPanel/Level6.pressed.connect(select_level.bind(5))
	$LevelsPanel/Level7.pressed.connect(select_level.bind(6))
	$LevelsPanel/Level8.pressed.connect(select_level.bind(7))
	
	$SettingsPanel/AudioSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$SettingsPanel/ControlsSlider.button_pressed = false
	

func select_level(level : int):
	Globals.currentLevel = level
	Globals.LoadLevel()


func menu_button_click(button : String):
	if button == "Quit":
		get_tree().quit()
	elif button == "Play":
		Globals.LoadLevel()
	elif button == "Levels":
		$LevelsPanel.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if InputEvent and event.is_action_pressed("Pause") and $LevelsPanel.visible:
		$LevelsPanel.visible = false

func control_slider_toggle(toggled_on: bool) -> void:
	print("Toggled")

func volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value - 80.0)
