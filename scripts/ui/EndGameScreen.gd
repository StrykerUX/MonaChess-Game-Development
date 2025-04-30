extends Control
# Script para la Pantalla de Fin de Juego de MonaChess
# Versión 0.7.0

# Referencias a nodos
@onready var result_label = $PanelContainer/MarginContainer/VBoxContainer/ResultLabel
@onready var play_again_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/PlayAgainButton
@onready var show_summary_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ShowSummaryButton
@onready var main_menu_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/MainMenuButton
@onready var exit_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ExitButton
@onready var animation_player = $AnimationPlayer

# Constantes
const MAIN_MENU_SCENE = "res://scenes/MainMenu.tscn"

# Variables
var is_animating = false
var winner_color = -1
var is_draw = false

# Función que se ejecuta al iniciar
func _ready():
	# Conectar señales de botones
	play_again_button.pressed.connect(_on_play_again_button_pressed)
	show_summary_button.pressed.connect(_on_show_summary_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	# Reproducir animación de entrada
	animation_player.play("result_in")
	
	# Actualizar el texto de resultado
	_update_result_text()
	
	# Establecer el foco en el botón de jugar de nuevo
	play_again_button.grab_focus()

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
	if play_again_button.has_focus():
		exit_button.grab_focus()
	elif show_summary_button.has_focus():
		play_again_button.grab_focus()
	elif main_menu_button.has_focus():
		show_summary_button.grab_focus()
	elif exit_button.has_focus():
		main_menu_button.grab_focus()
	else:
		play_again_button.grab_focus()

# Navegar hacia abajo en los botones
func _navigate_down():
	if play_again_button.has_focus():
		show_summary_button.grab_focus()
	elif show_summary_button.has_focus():
		main_menu_button.grab_focus()
	elif main_menu_button.has_focus():
		exit_button.grab_focus()
	elif exit_button.has_focus():
		play_again_button.grab_focus()
	else:
		play_again_button.grab_focus()

# Activar el botón que tiene el foco
func _activate_focused_button():
	if play_again_button.has_focus():
		_on_play_again_button_pressed()
	elif show_summary_button.has_focus():
		_on_show_summary_button_pressed()
	elif main_menu_button.has_focus():
		_on_main_menu_button_pressed()
	elif exit_button.has_focus():
		_on_exit_button_pressed()

# Establece el resultado como tablas
func set_result_draw():
	is_draw = true
	winner_color = -1
	_update_result_text()

# Establece el resultado como victoria de un jugador
func set_result_winner(color: int):
	is_draw = false
	winner_color = color
	_update_result_text()

# Actualiza el texto de resultado
func _update_result_text():
	if is_draw:
		result_label.text = "¡TABLAS!"
	else:
		var winner_name = "Blancas" if winner_color == ChessPiece.PieceColor.WHITE else "Negras"
		result_label.text = "¡VICTORIA DE LAS " + winner_name.to_upper() + "!"

# Manejador del botón de jugar de nuevo
func _on_play_again_button_pressed():
	if is_animating:
		return
		
	is_animating = true
	
	# Reproducir animación de salida
	animation_player.play("result_out")
	
	# Esperar a que termine la animación
	await animation_player.animation_finished
	
	# Reiniciar la escena actual
	get_tree().reload_current_scene()
	is_animating = false

# Manejador del botón de mostrar resumen
func _on_show_summary_button_pressed():
	if is_animating:
		return
		
	# Para la versión 0.7.0, mostrar un mensaje de "Próximamente"
	UIManager.show_notification("Resumen de partida disponible próximamente", "info", 3.0)

# Manejador del botón de menú principal
func _on_main_menu_button_pressed():
	if is_animating:
		return
		
	is_animating = true
	
	# Reproducir animación de salida
	animation_player.play("result_out")
	
	# Esperar a que termine la animación
	await animation_player.animation_finished
	
	# Ir al menú principal
	UIManager.transition_to_scene(MAIN_MENU_SCENE)
	is_animating = false

# Manejador del botón de salir
func _on_exit_button_pressed():
	if is_animating:
		return
		
	is_animating = true
	
	# Reproducir animación de salida
	animation_player.play("result_out")
	
	# Esperar a que termine la animación
	await animation_player.animation_finished
	
	# Salir del juego
	get_tree().quit()
