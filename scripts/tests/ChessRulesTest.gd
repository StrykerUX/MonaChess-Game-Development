extends Node

# Script de prueba para las reglas de ajedrez implementadas en la versión 0.6.0
# Autor: Abraham Almazán
# Fecha: 28/04/2025

# Referencia al tablero de ajedrez
@onready var chess_board = $ChessBoard

# Escenarios de prueba para jaque y jaque mate
var jaque_simple_setup = [
	{"action": "move", "from": "e2", "to": "e4"},
	{"action": "move", "from": "e7", "to": "e5"},
	{"action": "move", "from": "d1", "to": "h5"}, # Blancas mueven reina para poner en jaque
	{"action": "report", "title": "Jaque Simple", "description": "La reina blanca pone en jaque al rey negro"}
]

var jaque_mate_scholar_setup = [
	# Scholar's Mate (Mate Pastor)
	{"action": "move", "from": "e2", "to": "e4"},
	{"action": "move", "from": "e7", "to": "e5"},
	{"action": "move", "from": "f1", "to": "c4"}, # Alfil blanco 
	{"action": "move", "from": "b8", "to": "c6"}, # Caballo negro
	{"action": "move", "from": "d1", "to": "h5"}, # Reina blanca
	{"action": "move", "from": "g8", "to": "f6"}, # Caballo negro
	{"action": "move", "from": "h5", "to": "f7"}, # Reina da jaque mate
	{"action": "report", "title": "Jaque Mate del Pastor", "description": "La reina blanca da jaque mate al rey negro"}
]

var jaque_escape_setup = [
	{"action": "move", "from": "e2", "to": "e4"},
	{"action": "move", "from": "e7", "to": "e5"},
	{"action": "move", "from": "d1", "to": "h5"}, # Reina blanca ataca
	{"action": "move", "from": "g7", "to": "g6"}, # Negro bloquea el jaque
	{"action": "report", "title": "Escape de Jaque", "description": "El peón negro ha bloqueado el jaque de la reina blanca"}
]

var movimiento_ilegal_jaque_setup = [
	{"action": "move", "from": "e2", "to": "e4"},
	{"action": "move", "from": "e7", "to": "e5"},
	{"action": "move", "from": "f1", "to": "c4"}, # Alfil blanco 
	{"action": "move", "from": "b8", "to": "c6"}, # Caballo negro
	{"action": "move", "from": "d1", "to": "h5"}, # Reina blanca amenaza
	{"action": "try_illegal", "from": "d7", "to": "d6", "description": "Este movimiento deja al rey negro en jaque y debería ser rechazado"}
]

# Escenario actual seleccionado
var current_scenario = []
var current_step = 0
var is_test_running = false

# Función llamada cuando se inicia la escena
func _ready():
	print("Escena de prueba de reglas iniciada")
	# Conectar señales del tablero
	if chess_board:
		chess_board.checkmate_detected.connect(_on_checkmate_detected)
		chess_board.check_detected.connect(_on_check_detected)
		chess_board.stalemate_detected.connect(_on_stalemate_detected)
	
	# Iniciar con un temporizador para que el tablero termine de cargarse
	await get_tree().create_timer(1.0).timeout
	
	# Menú de selección de prueba
	print("Seleccione una prueba:")
	print("1 - Jaque Simple")
	print("2 - Jaque Mate del Pastor (Scholar's Mate)")
	print("3 - Escape de Jaque")
	print("4 - Movimiento Ilegal en Jaque")

# Función para procesar entrada de selección
func _input(event):
	if event is InputEventKey and event.pressed:
		if not is_test_running:
			if event.keycode == KEY_1:
				start_test(jaque_simple_setup, "Jaque Simple")
			elif event.keycode == KEY_2:
				start_test(jaque_mate_scholar_setup, "Jaque Mate del Pastor")
			elif event.keycode == KEY_3:
				start_test(jaque_escape_setup, "Escape de Jaque")
			elif event.keycode == KEY_4:
				start_test(movimiento_ilegal_jaque_setup, "Movimiento Ilegal en Jaque")
		
		# Avanzar en la prueba con la tecla Enter
		if event.keycode == KEY_ENTER and is_test_running:
			execute_next_step()

# Inicia una prueba
func start_test(scenario, name):
	print("Iniciando prueba: " + name)
	current_scenario = scenario
	current_step = 0
	is_test_running = true
	
	# Resetear el tablero (recargar la escena sería mejor pero para esto es suficiente)
	chess_board._setup_initial_pieces()
	
	# Ejecutar el primer paso después de un pequeño retraso
	await get_tree().create_timer(0.5).timeout
	execute_next_step()

# Ejecuta el siguiente paso del escenario actual
func execute_next_step():
	if current_step >= current_scenario.size():
		print("Prueba completada")
		is_test_running = false
		return
	
	var step = current_scenario[current_step]
	current_step += 1
	
	if step.action == "move":
		print("Moviendo pieza de " + step.from + " a " + step.to)
		_perform_move(step.from, step.to)
	elif step.action == "report":
		print("🔍 REPORTE: " + step.title)
		print("📋 " + step.description)
	elif step.action == "try_illegal":
		print("Intentando movimiento ilegal de " + step.from + " a " + step.to)
		print("📋 " + step.description)
		_try_illegal_move(step.from, step.to)

# Realiza un movimiento en el tablero de ajedrez
func _perform_move(from_pos, to_pos):
	# Primero seleccionar la pieza
	chess_board.process_click(_get_click_position(from_pos))
	
	# Esperar un poco para simular un jugador real
	await get_tree().create_timer(0.3).timeout
	
	# Luego mover la pieza al destino
	chess_board.process_click(_get_click_position(to_pos))
	
	# Esperar para ver el resultado
	await get_tree().create_timer(1.0).timeout

# Intenta un movimiento ilegal para probar la validación
func _try_illegal_move(from_pos, to_pos):
	# Primero seleccionar la pieza
	chess_board.process_click(_get_click_position(from_pos))
	
	# Esperar un poco para simular un jugador real
	await get_tree().create_timer(0.3).timeout
	
	# Luego intentar mover la pieza al destino (debería fallar)
	chess_board.process_click(_get_click_position(to_pos))
	
	# Esperar para ver el resultado
	await get_tree().create_timer(1.0).timeout

# Convierte una posición de notación (e4, a1) a una posición de clic en el tablero
func _get_click_position(notation):
	var board_pos = chess_board.get_board_position(notation)
	var click_pos = Vector2(
		board_pos.x * chess_board.SQUARE_SIZE + chess_board.SQUARE_SIZE / 2,
		board_pos.y * chess_board.SQUARE_SIZE + chess_board.SQUARE_SIZE / 2
	) + chess_board.get_node("BoardContainer").position
	return click_pos + chess_board.global_position

# Callbacks para las señales del tablero
func _on_check_detected(color):
	var color_name = "blanco" if color == ChessPiece.PieceColor.WHITE else "negro"
	print("✓ JAQUE detectado al rey " + color_name)

func _on_checkmate_detected(winner_color):
	var winner = "blancas" if winner_color == ChessPiece.PieceColor.WHITE else "negras"
	print("✓✓ JAQUE MATE detectado. Ganan las " + winner)

func _on_stalemate_detected():
	print("✓✓ TABLAS por ahogado detectado.")
