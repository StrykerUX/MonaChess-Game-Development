extends Control
# Script para el Menú Principal de MonaChess
# Versión 0.7.0

# Referencias a nodos
@onready var play_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/PlayButton
@onready var tutorial_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/TutorialButton
@onready var settings_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/SettingsButton
@onready var exit_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ExitButton
@onready var version_label = $VersionLabel
@onready var animation_player = $AnimationPlayer

# Constantes
const GAME_SCENE = "res://scenes/BoardTest.tscn"
const TUTORIAL_SCENE = "res://scenes/tutorial/TutorialIntro.tscn"

# Variables
var is_animating = false

# Función que se ejecuta al iniciar
func _ready():
	# Conectar señales de botones
	play_button.pressed.connect(_on_play_button_pressed)
	tutorial_button.pressed.connect(_on_tutorial_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	# Establecer versión
	version_label.text = "MonaChess v0.7.0"
	
	# Reproducir animación de entrada
	animation_player.play("menu_intro")

# Procesar entrada
func _input(event):
	# Habilitar navegación con teclas
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_UP:
				_navigate_up()
			KEY_DOWN:
				_navigate_down()
			KEY_RETURN, KEY_ENTER, KEY_SPACE:
				_activate_focused_button()

# Navegar hacia arriba en los botones
func _navigate_up():
	if play_button.has_focus():
		exit_button.grab_focus()
	elif tutorial_button.has_focus():
		play_button.grab_focus()
	elif settings_button.has_focus():
		tutorial_button.grab_focus()
	elif exit_button.has_focus():
		settings_button.grab_focus()
	else:
		play_button.grab_focus()

# Navegar hacia abajo en los botones
func _navigate_down():
	if play_button.has_focus():
		tutorial_button.grab_focus()
	elif tutorial_button.has_focus():
		settings_button.grab_focus()
	elif settings_button.has_focus():
		exit_button.grab_focus()
	elif exit_button.has_focus():
		play_button.grab_focus()
	else:
		play_button.grab_focus()

# Activar el botón que tiene el foco
func _activate_focused_button():
	if play_button.has_focus():
		_on_play_button_pressed()
	elif tutorial_button.has_focus():
		_on_tutorial_button_pressed()
	elif settings_button.has_focus():
		_on_settings_button_pressed()
	elif exit_button.has_focus():
		_on_exit_button_pressed()

# Manejador del botón de jugar
func _on_play_button_pressed():
	if is_animating:
		return
		
	is_animating = true
	
	# Reproducir animación de salida
	animation_player.play("menu_exit")
	
	# Esperar a que termine la animación
	await animation_player.animation_finished
	
	# Ir a la escena del juego
	UIManager.transition_to_scene(GAME_SCENE)
	is_animating = false

# Manejador del botón de tutorial
func _on_tutorial_button_pressed():
	if is_animating:
		return
		
	# Para la versión 0.7.0, mostrar un mensaje de "Próximamente"
	UIManager.show_notification("Tutorial disponible próximamente", "info", 3.0)

# Manejador del botón de ajustes
func _on_settings_button_pressed():
	if is_animating:
		return
		
	# Mostrar el menú de ajustes
	UIManager.show_settings_menu()

# Manejador del botón de salir
func _on_exit_button_pressed():
	if is_animating:
		return
		
	is_animating = true
	
	# Reproducir animación de salida
	animation_player.play("menu_exit")
	
	# Esperar a que termine la animación
	await animation_player.animation_finished
	
	# Salir del juego
	get_tree().quit()
