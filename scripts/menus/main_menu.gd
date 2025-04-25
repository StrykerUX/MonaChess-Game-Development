extends Control

# Script para el menú principal del juego MonaChess

# Constantes para las escenas (en versiones futuras)
const STORY_MODE_SCENE = "res://scenes/game/story_mode.tscn"
const QUICK_PLAY_SCENE = "res://scenes/game/quick_play.tscn"
const MULTIPLAYER_SCENE = "res://scenes/game/multiplayer.tscn"
const TUTORIAL_SCENE = "res://scenes/game/tutorial.tscn"
const SETTINGS_SCENE = "res://scenes/menus/settings.tscn"

# Función llamada cuando la escena está lista
func _ready():
	print("Cargando menú principal - Versión 0.0.0")
	
	# En la versión 0.0.0, la mayoría de los botones están deshabilitados
	# ya que sólo estamos configurando la estructura base
	
	# Cambiamos el estado del juego a MAIN_MENU
	GameManager.change_state(GameManager.GameState.MAIN_MENU)
	
	# Actualizamos la etiqueta de versión para asegurarnos que muestre la versión correcta
	$TitleContainer/Version.text = "Versión " + GameManager.VERSION
	
	# Conectamos las señales de los botones
	_connect_signals()

# Función para conectar todas las señales de botones
func _connect_signals():
	# Los botones deshabilitados también reciben la conexión para futuras versiones
	$MenuContainer/StoryModeButton.connect("pressed", _on_story_mode_button_pressed)
	$MenuContainer/QuickPlayButton.connect("pressed", _on_quick_play_button_pressed)
	$MenuContainer/MultiplayerButton.connect("pressed", _on_multiplayer_button_pressed)
	$MenuContainer/TutorialButton.connect("pressed", _on_tutorial_button_pressed)
	$MenuContainer/SettingsButton.connect("pressed", _on_settings_button_pressed)
	# La señal para ExitButton ya está conectada en el editor

# MANEJADORES DE SEÑALES (preparados para versiones futuras)

func _on_story_mode_button_pressed():
	print("Modo Historia seleccionado (no implementado en versión 0.0.0)")
	# Este código se habilitará en versiones futuras
	# GameManager.set_game_mode(GameManager.GameMode.STORY)
	# SceneLoader.goto_scene(STORY_MODE_SCENE)

func _on_quick_play_button_pressed():
	print("Partida Rápida seleccionada (no implementado en versión 0.0.0)")
	# Este código se habilitará en versiones futuras
	# GameManager.set_game_mode(GameManager.GameMode.QUICK_PLAY)
	# SceneLoader.goto_scene(QUICK_PLAY_SCENE)

func _on_multiplayer_button_pressed():
	print("Multijugador seleccionado (no implementado en versión 0.0.0)")
	# Este código se habilitará en versiones futuras
	# GameManager.set_game_mode(GameManager.GameMode.LOCAL_MULTIPLAYER)
	# SceneLoader.goto_scene(MULTIPLAYER_SCENE)

func _on_tutorial_button_pressed():
	print("Tutorial seleccionado (no implementado en versión 0.0.0)")
	# Este código se habilitará en versiones futuras
	# GameManager.set_game_mode(GameManager.GameMode.TUTORIAL)
	# SceneLoader.goto_scene(TUTORIAL_SCENE)

func _on_settings_button_pressed():
	print("Ajustes seleccionado (no implementado en versión 0.0.0)")
	# Este código se habilitará en versiones futuras
	# SceneLoader.goto_scene(SETTINGS_SCENE)

func _on_exit_button_pressed():
	print("Saliendo del juego")
	get_tree().quit()

# Sistema de entrada para teclas adicionales
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			_on_exit_button_pressed()
