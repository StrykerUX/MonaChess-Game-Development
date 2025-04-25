extends Node

# Versión actual del juego
const VERSION = "0.2.0"

# Enumeración para los estados del juego
enum GameState {
	MAIN_MENU,
	GAME,
	PAUSED,
	GAME_OVER
}

# Estado actual del juego
var current_state: int = GameState.MAIN_MENU

# Modo de juego seleccionado
enum GameMode {
	STORY,
	QUICK_PLAY,
	LOCAL_MULTIPLAYER,
	TUTORIAL
}

var selected_game_mode: int = GameMode.QUICK_PLAY

# Temas visuales disponibles (para futuras versiones)
enum VisualTheme {
	MEDIEVAL,
	SAMURAI,
	CYBERPUNK,
	MEXICA
}

var current_theme: int = VisualTheme.MEDIEVAL

# Datos del jugador (para futuras versiones)
var player_score: int = 0
var unlocked_themes: Array = [VisualTheme.MEDIEVAL]  # Solo medieval desbloqueado inicialmente
var unlocked_skins: Dictionary = {}  # Para almacenar skins desbloqueadas por tipo de pieza

# Sistema para guardar/cargar (para futuras versiones)
var save_data: Dictionary = {}

# Función llamada cuando el nodo entra en el árbol de escena
func _ready():
	print("GameManager inicializado - Versión: ", VERSION)
	
	# Registramos señales para manejo de eventos de juego
	_register_signals()

# Función para registrar señales personalizadas
func _register_signals() -> void:
	# Estas señales se utilizarán en versiones futuras
	add_user_signal("game_started")
	add_user_signal("game_paused")
	add_user_signal("game_resumed")
	add_user_signal("game_over")
	add_user_signal("piece_moved")
	add_user_signal("piece_captured")
	add_user_signal("check_detected")
	add_user_signal("checkmate_detected")

# Cambia el estado del juego
func change_state(new_state: int) -> void:
	var old_state = current_state
	current_state = new_state
	print("Cambio de estado: ", _state_to_string(old_state), " -> ", _state_to_string(current_state))
	
	# Emitir señales apropiadas basadas en el cambio de estado
	match new_state:
		GameState.GAME:
			if old_state == GameState.PAUSED:
				emit_signal("game_resumed")
			else:
				emit_signal("game_started")
		GameState.PAUSED:
			emit_signal("game_paused")
		GameState.GAME_OVER:
			emit_signal("game_over")

# Convierte el enum de estado a string para depuración
func _state_to_string(state: int) -> String:
	match state:
		GameState.MAIN_MENU:
			return "MAIN_MENU"
		GameState.GAME:
			return "GAME"
		GameState.PAUSED:
			return "PAUSED"
		GameState.GAME_OVER:
			return "GAME_OVER"
		_:
			return "UNKNOWN"

# Cambia el modo de juego seleccionado
func set_game_mode(mode: int) -> void:
	selected_game_mode = mode
	print("Modo de juego seleccionado: ", _mode_to_string(mode))

# Convierte el enum de modo a string para depuración
func _mode_to_string(mode: int) -> String:
	match mode:
		GameMode.STORY:
			return "STORY"
		GameMode.QUICK_PLAY:
			return "QUICK_PLAY"
		GameMode.LOCAL_MULTIPLAYER:
			return "LOCAL_MULTIPLAYER"
		GameMode.TUTORIAL:
			return "TUTORIAL"
		_:
			return "UNKNOWN"

# Cambia el tema visual (para futuras versiones)
func set_visual_theme(theme: int) -> void:
	# Verifica si el tema está desbloqueado
	if theme in unlocked_themes:
		current_theme = theme
		print("Tema visual cambiado a: ", _theme_to_string(theme))
	else:
		print("Tema no desbloqueado: ", _theme_to_string(theme))

# Convierte el enum de tema a string para depuración
func _theme_to_string(theme: int) -> String:
	match theme:
		VisualTheme.MEDIEVAL:
			return "MEDIEVAL"
		VisualTheme.SAMURAI:
			return "SAMURAI"
		VisualTheme.CYBERPUNK:
			return "CYBERPUNK"
		VisualTheme.MEXICA:
			return "MEXICA"
		_:
			return "UNKNOWN"

# Funciones para guardar/cargar (estructura básica para futuras versiones)
func save_game() -> void:
	# Esta función se implementará en versiones futuras
	print("Funcionalidad de guardado pendiente para futuras versiones")

func load_game() -> void:
	# Esta función se implementará en versiones futuras
	print("Funcionalidad de carga pendiente para futuras versiones")
