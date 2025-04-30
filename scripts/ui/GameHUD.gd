extends Control
# Script para el HUD del juego de MonaChess
# Versión 0.7.0

# Referencias a nodos
@onready var move_history = $SidePanel/MoveHistoryPanel/ScrollContainer/MoveHistoryContainer
@onready var white_timer_label = $SidePanel/PlayersInfoPanel/WhitePlayerInfo/TimeLabel
@onready var black_timer_label = $SidePanel/PlayersInfoPanel/BlackPlayerInfo/TimeLabel
@onready var turn_indicator = $SidePanel/GameStatusPanel/TurnIndicator
@onready var status_label = $SidePanel/GameStatusPanel/StatusLabel
@onready var pause_button = $TopBar/PauseButton
@onready var settings_button = $TopBar/SettingsButton
@onready var restart_button = $TopBar/RestartButton

# Referencias al tablero
var chess_board

# Timers para los jugadores
var white_timer: float = 1800.0  # 30 minutos en segundos
var black_timer: float = 1800.0  # 30 minutos en segundos
var current_timer_active: int = ChessPiece.PieceColor.WHITE

# Variables para el historial de movimientos
var move_count: int = 1
var move_history_items = []

# Función que se ejecuta al iniciar
func _ready():
	# Conectar señales de botones
	pause_button.pressed.connect(_on_pause_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	
	# Buscar el tablero de ajedrez en la escena
	chess_board = get_parent().get_node_or_null("ChessBoard")
	
	if chess_board:
		# Conectar señales del tablero
		chess_board.turn_changed.connect(_on_turn_changed)
		chess_board.check_detected.connect(_on_check_detected)
		chess_board.checkmate_detected.connect(_on_checkmate_detected)
		chess_board.stalemate_detected.connect(_on_stalemate_detected)
	else:
		push_error("No se encontró el tablero de ajedrez en la escena")
	
	# Inicializar HUD
	_update_timers_display()
	_update_turn_indicator(ChessPiece.PieceColor.WHITE)
	status_label.text = "¡Partida iniciada!"

# Procesar cada fotograma
func _process(delta):
	# Actualizar el timer del jugador activo
	if chess_board and chess_board.is_game_active:
		if current_timer_active == ChessPiece.PieceColor.WHITE:
			white_timer -= delta
			if white_timer <= 0:
				white_timer = 0
				_on_player_timeout(ChessPiece.PieceColor.WHITE)
		else:
			black_timer -= delta
			if black_timer <= 0:
				black_timer = 0
				_on_player_timeout(ChessPiece.PieceColor.BLACK)
		
		# Actualizar la visualización de los timers
		_update_timers_display()

# Actualiza la visualización de los timers
func _update_timers_display():
	white_timer_label.text = _format_time(white_timer)
	black_timer_label.text = _format_time(black_timer)
	
	# Cambiar colores según el tiempo restante
	if white_timer < 300:  # Menos de 5 minutos
		white_timer_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	elif white_timer < 600:  # Menos de 10 minutos
		white_timer_label.add_theme_color_override("font_color", Color(1, 0.7, 0.3))
	else:
		white_timer_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	if black_timer < 300:  # Menos de 5 minutos
		black_timer_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	elif black_timer < 600:  # Menos de 10 minutos
		black_timer_label.add_theme_color_override("font_color", Color(1, 0.7, 0.3))
	else:
		black_timer_label.add_theme_color_override("font_color", Color(1, 1, 1))

# Formatea el tiempo en formato mm:ss
func _format_time(time_seconds: float) -> String:
	var minutes = floor(time_seconds / 60)
	var seconds = int(time_seconds) % 60
	return "%02d:%02d" % [minutes, seconds]

# Manejador para cuando se agota el tiempo de un jugador
func _on_player_timeout(player_color: int):
	if not chess_board:
		return
		
	# Determinar el ganador (el otro jugador)
	var winner = ChessPiece.PieceColor.BLACK if player_color == ChessPiece.PieceColor.WHITE else ChessPiece.PieceColor.WHITE
	
	# Mostrar mensaje
	var loser_color_name = "blancas" if player_color == ChessPiece.PieceColor.WHITE else "negras"
	status_label.text = "¡Tiempo agotado para las " + loser_color_name + "!"
	
	# Notificar al tablero
	if chess_board.has_method("end_game"):
		chess_board.end_game(winner, false)
	
	# Mostrar ventana de fin de juego
	UIManager.show_end_game_screen(winner)

# Manejador para cambio de turno
func _on_turn_changed(new_turn: int):
	# Actualizar indicador de turno
	_update_turn_indicator(new_turn)
	
	# Cambiar el timer activo
	current_timer_active = new_turn

# Actualiza el indicador visual de turno
func _update_turn_indicator(turn: int):
	var turn_text = "Turno: " + ("Blancas" if turn == ChessPiece.PieceColor.WHITE else "Negras")
	turn_indicator.text = turn_text
	
	# Cambiar color según el turno
	if turn == ChessPiece.PieceColor.WHITE:
		turn_indicator.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	else:
		turn_indicator.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))

# Añade un movimiento al historial
func add_move(from_pos: String, to_pos: String, piece_type: int, is_capture: bool = false, 
			is_check: bool = false, is_checkmate: bool = false):
	# Crear un nuevo ítem para el historial
	var move_text = ""
	
	# Añadir número de movimiento si es turno de blancas
	if current_timer_active == ChessPiece.PieceColor.WHITE:
		move_text = str(move_count) + ". "
	
	# Añadir símbolo de la pieza
	var piece_symbol = _get_piece_symbol(piece_type)
	move_text += piece_symbol
	
	# Añadir notación
	move_text += from_pos + "-" + to_pos
	
	# Añadir símbolo de captura
	if is_capture:
		move_text += "x"
	
	# Añadir símbolo de jaque o jaque mate
	if is_checkmate:
		move_text += "#"
	elif is_check:
		move_text += "+"
	
	# Crear una etiqueta para el movimiento
	var move_label = Label.new()
	move_label.text = move_text
	move_history.add_child(move_label)
	move_history_items.append(move_label)
	
	# Incrementar contador si es turno de negras
	if current_timer_active == ChessPiece.PieceColor.BLACK:
		move_count += 1

# Obtiene el símbolo unicode para una pieza
func _get_piece_symbol(piece_type: int) -> String:
	match piece_type:
		ChessPiece.PieceType.KING:
			return "♔"
		ChessPiece.PieceType.QUEEN:
			return "♕"
		ChessPiece.PieceType.ROOK:
			return "♖"
		ChessPiece.PieceType.BISHOP:
			return "♗"
		ChessPiece.PieceType.KNIGHT:
			return "♘"
		ChessPiece.PieceType.PAWN:
			return ""  # Los peones no tienen símbolo
		_:
			return "?"

# Manejador para detección de jaque
func _on_check_detected(color: int):
	var color_name = "blanco" if color == ChessPiece.PieceColor.WHITE else "negro"
	status_label.text = "¡JAQUE al rey " + color_name + "!"

# Manejador para detección de jaque mate
func _on_checkmate_detected(winner_color: int):
	var winner_name = "blancas" if winner_color == ChessPiece.PieceColor.WHITE else "negras"
	status_label.text = "¡JAQUE MATE! Ganan las " + winner_name
	
	# Desactivar los timers
	current_timer_active = -1

# Manejador para detección de tablas
func _on_stalemate_detected():
	status_label.text = "¡TABLAS! (Rey ahogado)"
	
	# Desactivar los timers
	current_timer_active = -1

# Manejador del botón de pausa
func _on_pause_button_pressed():
	UIManager.show_pause_menu()

# Manejador del botón de ajustes
func _on_settings_button_pressed():
	UIManager.show_settings_menu()

# Manejador del botón de reiniciar
func _on_restart_button_pressed():
	# Preguntar al usuario si desea reiniciar
	UIManager.show_notification("Partida reiniciada", "info")
	get_tree().reload_current_scene()
