extends Node
# UI Manager para MonaChess
# Versión 0.7.0
# Control centralizado de interfaces y menús

# Modos de UI
enum UIMode {
	MAIN_MENU,
	GAME_PLAY,
	PAUSE_MENU,
	SETTINGS,
	END_GAME,
	TUTORIAL
}

# Estado actual de la UI
var current_mode: int = UIMode.MAIN_MENU

# Señales para notificación de cambios de UI
signal ui_mode_changed(new_mode)
signal notification_requested(message, type)
signal scene_transition_requested(scene_path, transition_type)

# Referencia a los nodos de la interfaz
var main_menu_scene: PackedScene = preload("res://scenes/ui/MainMenu.tscn")
var pause_menu_scene: PackedScene = preload("res://scenes/ui/PauseMenu.tscn")
var settings_menu_scene: PackedScene = preload("res://scenes/ui/SettingsMenu.tscn")
var game_hud_scene: PackedScene = preload("res://scenes/ui/GameHUD.tscn")
var end_game_scene: PackedScene = preload("res://scenes/ui/EndGameScreen.tscn")
var notification_scene: PackedScene = preload("res://scenes/ui/Notification.tscn")

# Nodos activos actuales
var current_menu_instance = null
var current_hud_instance = null
var notification_container = null

# Precarga de transiciones
var transition_fade_scene: PackedScene = preload("res://scenes/ui/transitions/FadeTransition.tscn")

# Función que se ejecuta al iniciar
func _ready():
	# Crear el contenedor de notificaciones
	notification_container = Control.new()
	notification_container.name = "NotificationContainer"
	notification_container.anchors_preset = Control.PRESET_FULL_RECT
	add_child(notification_container)
	
	# Iniciar con el menú principal
	show_main_menu()
	
	print("UI Manager inicializado en la versión 0.7.0")

# Función para manejar la entrada global
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key by default
		match current_mode:
			UIMode.GAME_PLAY:
				show_pause_menu()
			UIMode.PAUSE_MENU:
				hide_pause_menu()
			UIMode.SETTINGS:
				if current_menu_instance and current_menu_instance.has_method("handle_back"):
					current_menu_instance.handle_back()

# Muestra el menú principal
func show_main_menu():
	_clear_current_ui()
	current_mode = UIMode.MAIN_MENU
	
	current_menu_instance = main_menu_scene.instantiate()
	add_child(current_menu_instance)
	
	emit_signal("ui_mode_changed", current_mode)

# Muestra el HUD del juego
func show_game_hud():
	if current_hud_instance:
		current_hud_instance.queue_free()
	
	current_mode = UIMode.GAME_PLAY
	
	current_hud_instance = game_hud_scene.instantiate()
	add_child(current_hud_instance)
	
	emit_signal("ui_mode_changed", current_mode)

# Muestra el menú de pausa
func show_pause_menu():
	if current_mode != UIMode.GAME_PLAY:
		return
	
	current_mode = UIMode.PAUSE_MENU
	
	current_menu_instance = pause_menu_scene.instantiate()
	add_child(current_menu_instance)
	
	# Aplicar efecto de desenfoque o oscurecimiento al juego
	_apply_pause_effect(true)
	
	emit_signal("ui_mode_changed", current_mode)

# Oculta el menú de pausa
func hide_pause_menu():
	if current_mode != UIMode.PAUSE_MENU:
		return
		
	if current_menu_instance:
		current_menu_instance.queue_free()
		current_menu_instance = null
	
	current_mode = UIMode.GAME_PLAY
	
	# Quitar efecto de desenfoque o oscurecimiento
	_apply_pause_effect(false)
	
	emit_signal("ui_mode_changed", current_mode)

# Muestra el menú de ajustes
func show_settings_menu():
	var previous_mode = current_mode
	
	current_mode = UIMode.SETTINGS
	
	if current_menu_instance:
		current_menu_instance.queue_free()
	
	current_menu_instance = settings_menu_scene.instantiate()
	current_menu_instance.previous_mode = previous_mode
	add_child(current_menu_instance)
	
	emit_signal("ui_mode_changed", current_mode)

# Muestra la pantalla de fin de juego
func show_end_game_screen(winner_color = -1, is_draw = false):
	if current_mode != UIMode.GAME_PLAY:
		return
	
	current_mode = UIMode.END_GAME
	
	if current_menu_instance:
		current_menu_instance.queue_free()
	
	current_menu_instance = end_game_scene.instantiate()
	
	# Configurar el estado de la pantalla de fin de juego
	if is_draw:
		current_menu_instance.set_result_draw()
	else:
		current_menu_instance.set_result_winner(winner_color)
	
	add_child(current_menu_instance)
	
	emit_signal("ui_mode_changed", current_mode)

# Mostrar una notificación
func show_notification(message: String, type: String = "info", duration: float = 3.0):
	var notification = notification_scene.instantiate()
	notification_container.add_child(notification)
	notification.show_message(message, type, duration)
	
	emit_signal("notification_requested", message, type)

# Realiza una transición entre escenas
func transition_to_scene(scene_path: String, transition_type: String = "fade"):
	var transition = transition_fade_scene.instantiate()
	add_child(transition)
	
	# Conectar señal de transición completada
	transition.transition_finished.connect(_on_transition_finished.bind(scene_path))
	
	# Iniciar transición
	transition.start_transition()
	
	emit_signal("scene_transition_requested", scene_path, transition_type)

# Callback para cuando se completa una transición
func _on_transition_finished(scene_path: String):
	# Cambiar a la escena solicitada
	if scene_path:
		SceneLoader.goto_scene(scene_path)

# Aplicar efecto visual cuando se pausa el juego
func _apply_pause_effect(is_paused: bool):
	# Aplicar desenfoque o oscurecimiento al juego cuando está pausado
	if is_paused:
		# Crear un overlay semi-transparente
		var overlay = ColorRect.new()
		overlay.name = "PauseOverlay"
		overlay.anchors_preset = Control.PRESET_FULL_RECT
		overlay.color = Color(0, 0, 0, 0.5)  # Negro semi-transparente
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(overlay)
		
		# Mover overlay atrás del menú pero encima del juego
		move_child(overlay, 0)
	else:
		# Remover el overlay
		var overlay = get_node_or_null("PauseOverlay")
		if overlay:
			overlay.queue_free()

# Limpiar toda la UI actual
func _clear_current_ui():
	if current_menu_instance:
		current_menu_instance.queue_free()
		current_menu_instance = null
	
	if current_hud_instance:
		current_hud_instance.queue_free()
		current_hud_instance = null
	
	# Remover cualquier overlay o efecto
	var overlay = get_node_or_null("PauseOverlay")
	if overlay:
		overlay.queue_free()
