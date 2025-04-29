extends Node2D

# Tablero de ajedrez para MonaChess
# Implementa un tablero 8x8 con coordenadas estándar (A1-H8)
# Versión 0.6.0
# Incluye detección de jaque y jaque mate

# Constantes de configuración del tablero
const BOARD_SIZE = 8
const SQUARE_SIZE = 67.5  # Tamaño de cada casilla en píxeles (540px / 8)

# Colores para las casillas del tablero
const DARK_SQUARE_COLOR = Color(0.25, 0.25, 0.35, 1.0)  # Azul oscuro
const LIGHT_SQUARE_COLOR = Color(0.85, 0.85, 0.95, 1.0) # Blanco azulado

# Colores para resaltar casillas
const HIGHLIGHT_COLOR = Color(0.2, 0.8, 0.2, 0.4)  # Verde semi-transparente
const SELECTED_COLOR = Color(0.9, 0.9, 0.2, 0.4)   # Amarillo semi-transparente
const CAPTURE_COLOR = Color(0.9, 0.2, 0.2, 0.4)    # Rojo semi-transparente
const CHECK_COLOR = Color(1.0, 0.0, 0.0, 0.3)      # Rojo para destacar jaque

# Valores de las piezas para cálculos y efectos
const PIECE_VALUES = {
	ChessPiece.PieceType.PAWN: 1,
	ChessPiece.PieceType.KNIGHT: 3,
	ChessPiece.PieceType.BISHOP: 3,
	ChessPiece.PieceType.ROOK: 5,
	ChessPiece.PieceType.QUEEN: 9,
	ChessPiece.PieceType.KING: 100
}

# Precarga de escenas de piezas
const PAWN_SCENE = preload("res://scenes/board/pieces/Pawn.tscn")
const KNIGHT_SCENE = preload("res://scenes/board/pieces/Knight.tscn")
const BISHOP_SCENE = preload("res://scenes/board/pieces/Bishop.tscn")
const ROOK_SCENE = preload("res://scenes/board/pieces/Rook.tscn")
const QUEEN_SCENE = preload("res://scenes/board/pieces/Queen.tscn")
const KING_SCENE = preload("res://scenes/board/pieces/King.tscn")

# Matriz para representar el estado del tablero
# 0 = vacío, valores positivos = piezas blancas, valores negativos = piezas negras
var board_matrix = []

# Diccionario para mantener referencias a las piezas en el tablero
var pieces = {}

# Listas para piezas capturadas
var white_captured_pieces = []
var black_captured_pieces = []

# Variable para la pieza seleccionada actualmente
var selected_piece = null

# Turno actual (blancas=0, negras=1)
var current_turn = ChessPiece.PieceColor.WHITE

# Estado del juego
var is_game_active = true
var is_white_in_check = false
var is_black_in_check = false
var white_king_position = "e1"
var black_king_position = "e8"

# Señales emitidas por el tablero
signal turn_changed(new_turn)
signal check_detected(color)
signal checkmate_detected(winner_color)
signal stalemate_detected

# Nodos del tablero
@onready var board_grid = $BoardContainer/Board
@onready var turn_indicator = $TurnIndicator
@onready var turn_label = $TurnIndicator/TurnLabel
@onready var turn_background = $TurnIndicator/TurnBackground
@onready var white_captured_grid = $CapturedPiecesContainers/WhiteCapturedPanel/CapturedGrid
@onready var black_captured_grid = $CapturedPiecesContainers/BlackCapturedPanel/CapturedGrid
@onready var capture_effects_container = $CaptureEffectsContainer
@onready var check_label = $GameStatusContainer/CheckLabel
@onready var game_status_container = $GameStatusContainer

# Función que se ejecuta cuando el nodo entra al árbol de escenas
func _ready():
	print("Inicializando tablero de ajedrez...")
	
	# Inicializar la matriz del tablero
	_initialize_board_matrix()
	
	# Crear representación visual del tablero
	_create_board_squares()
	
	# Configurar el inicio de las piezas
	_setup_initial_pieces()
	
	# Inicializar etiqueta de turno
	_update_turn_label()
	
	# Inicializar etiqueta de jaque
	if check_label:
		check_label.visible = false
	
	print("Tablero de ajedrez inicializado correctamente")

# Inicializa la matriz del tablero con valores iniciales (todos 0 por ahora)
func _initialize_board_matrix():
	# Crear matriz 8x8 vacía
	board_matrix = []
	for _i in range(BOARD_SIZE):
		var row = []
		for _j in range(BOARD_SIZE):
			row.append(0)  # 0 representa una casilla vacía
		board_matrix.append(row)
	
	print("Matriz del tablero inicializada")

# Crea las casillas visuales del tablero
func _create_board_squares():
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			# Crear casilla
			var square = ColorRect.new()
			square.size_flags_horizontal = Control.SIZE_FILL_EXPAND
			square.size_flags_vertical = Control.SIZE_FILL_EXPAND
			square.custom_minimum_size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
			
			# Determinar color de la casilla (alternancia de claro y oscuro)
			var is_dark = (row + col) % 2 == 1
			square.color = DARK_SQUARE_COLOR if is_dark else LIGHT_SQUARE_COLOR
			
			# Asignar nombre para identificar la casilla (ej: "e4", "a1")
			var coord = _get_chess_notation(col, row)
			square.name = coord
			
			# Añadir la casilla al grid
			board_grid.add_child(square)
	
	print("Casillas del tablero creadas")

# Convierte coordenadas de matriz (0-7, 0-7) a notación de ajedrez (a1-h8)
func _get_chess_notation(col, row) -> String:
	var file = char(97 + col)  # 97 = 'a', 98 = 'b', etc.
	var rank = 8 - row  # En ajedrez, el rango 8 está arriba y el 1 abajo
	return file + str(rank)

# Convierte notación de ajedrez (a1-h8) a coordenadas de matriz (0-7, 0-7)
func get_board_position(notation: String) -> Vector2:
	if notation.length() != 2:
		push_error("Notación inválida: " + notation)
		return Vector2(-1, -1)
	
	var file = notation[0].to_lower()
	var rank = notation[1]
	
	if file < 'a' or file > 'h' or rank < '1' or rank > '8':
		push_error("Coordenadas fuera de rango: " + notation)
		return Vector2(-1, -1)
	
	var col = file.unicode_at(0) - 97  # 'a' es 0, 'b' es 1, etc.
	var row = 8 - int(rank)  # En ajedrez, el rango 8 está arriba y el 1 abajo
	
	return Vector2(col, row)

# Convierte coordenadas del mundo a notación de ajedrez
func get_notation_from_position(position: Vector2) -> String:
	var local_pos = $BoardContainer.global_position - global_position
	
	# Calcular la casilla del tablero en la que se hizo clic
	var board_pos = (position - local_pos) / SQUARE_SIZE
	var col = int(board_pos.x)
	var row = int(board_pos.y)
	
	# Verificar que las coordenadas son válidas
	if col < 0 || col >= 8 || row < 0 || row >= 8:
		return ""
	
	return _get_chess_notation(col, row)

# Obtiene el valor de una casilla en la matriz del tablero
func get_square_value(notation: String) -> int:
	var pos = get_board_position(notation)
	if pos.x < 0 or pos.y < 0:
		return 0  # Posición inválida
	
	return board_matrix[pos.y][pos.x]

# Establece un valor en una casilla de la matriz del tablero
func set_square_value(notation: String, value: int) -> bool:
	var pos = get_board_position(notation)
	if pos.x < 0 or pos.y < 0:
		return false  # Posición inválida
	
	board_matrix[pos.y][pos.x] = value
	return true

# Configura las piezas en su posición inicial
func _setup_initial_pieces():
	# Limpiar piezas existentes
	for position in pieces:
		if pieces[position] != null:
			pieces[position].queue_free()
	pieces.clear()
	
	# Crear peones blancos en segunda fila
	for file in "abcdefgh":
		var position = file + "2"
		_create_piece(PAWN_SCENE, ChessPiece.PieceColor.WHITE, position)
	
	# Crear peones negros en séptima fila
	for file in "abcdefgh":
		var position = file + "7"
		_create_piece(PAWN_SCENE, ChessPiece.PieceColor.BLACK, position)
	
	# Crear torres
	_create_piece(ROOK_SCENE, ChessPiece.PieceColor.WHITE, "a1")
	_create_piece(ROOK_SCENE, ChessPiece.PieceColor.WHITE, "h1")
	_create_piece(ROOK_SCENE, ChessPiece.PieceColor.BLACK, "a8")
	_create_piece(ROOK_SCENE, ChessPiece.PieceColor.BLACK, "h8")
	
	# Crear caballos
	_create_piece(KNIGHT_SCENE, ChessPiece.PieceColor.WHITE, "b1")
	_create_piece(KNIGHT_SCENE, ChessPiece.PieceColor.WHITE, "g1")
	_create_piece(KNIGHT_SCENE, ChessPiece.PieceColor.BLACK, "b8")
	_create_piece(KNIGHT_SCENE, ChessPiece.PieceColor.BLACK, "g8")
	
	# Crear alfiles
	_create_piece(BISHOP_SCENE, ChessPiece.PieceColor.WHITE, "c1")
	_create_piece(BISHOP_SCENE, ChessPiece.PieceColor.WHITE, "f1")
	_create_piece(BISHOP_SCENE, ChessPiece.PieceColor.BLACK, "c8")
	_create_piece(BISHOP_SCENE, ChessPiece.PieceColor.BLACK, "f8")
	
	# Crear reinas
	_create_piece(QUEEN_SCENE, ChessPiece.PieceColor.WHITE, "d1")
	_create_piece(QUEEN_SCENE, ChessPiece.PieceColor.BLACK, "d8")
	
	# Crear reyes
	_create_piece(KING_SCENE, ChessPiece.PieceColor.WHITE, "e1")
	_create_piece(KING_SCENE, ChessPiece.PieceColor.BLACK, "e8")
	
	print("Piezas iniciales colocadas en el tablero")

# Crea una nueva pieza de ajedrez del tipo especificado
func _create_piece(scene, color, position):
	# Instanciar la escena de la pieza
	var piece = scene.instantiate()
	
	# Inicializar la pieza con su color y posición
	piece._init(color, position)
	
	# Posicionar la pieza visualmente en el tablero
	var board_pos = get_board_position(position)
	piece.position = Vector2(
		board_pos.x * SQUARE_SIZE + SQUARE_SIZE / 2,
		board_pos.y * SQUARE_SIZE + SQUARE_SIZE / 2
	)
	
	# Guardar referencia a la pieza en el diccionario de piezas
	pieces[position] = piece
	
	# Actualizar la matriz del tablero
	var value = piece.get_value()
	if color == ChessPiece.PieceColor.BLACK:
		value = -value
	set_square_value(position, value)
	
	# Añadir la pieza al tablero
	add_child(piece)
	
	return piece

# Selecciona una pieza en la posición especificada
func select_piece(position: String) -> bool:
	# Verificar si hay una pieza en la posición
	if position in pieces:
		var piece = pieces[position]
		
		# Verificar que la pieza corresponde al turno actual
		if piece.piece_color != current_turn:
			return false
		
		# Si ya hay una pieza seleccionada, deseleccionarla
		if selected_piece:
			selected_piece.set_selected(false)
		
		# Seleccionar la nueva pieza
		selected_piece = piece
		selected_piece.set_selected(true)
		
		# Resaltar la casilla de la pieza seleccionada
		_highlight_square(position, SELECTED_COLOR)
		
		# Resaltar movimientos posibles
		var valid_moves = selected_piece.get_valid_moves(board_matrix)
		var king_position = white_king_position if current_turn == ChessPiece.PieceColor.WHITE else black_king_position
		
		# Filtrar movimientos que dejarían al rey en jaque
		var legal_moves = []
		for move in valid_moves:
			# Si la pieza que se mueve es el rey, actualizar la posición para la verificación
			var check_king_position = move if piece.piece_type == ChessPiece.PieceType.KING else king_position
			
			if !ChessRules.would_move_cause_check(board_matrix, position, move, check_king_position, current_turn):
				legal_moves.append(move)
				# Si hay una pieza en la casilla destino, resaltar como captura
				if move in pieces:
					var target_piece = pieces[move]
					# Solo resaltar capturas de piezas enemigas
					if target_piece.piece_color != piece.piece_color:
						_highlight_square(move, CAPTURE_COLOR)
				else:
					_highlight_square(move, HIGHLIGHT_COLOR)
		
		# Si no hay movimientos legales, mostrar un mensaje temporal
		if legal_moves.empty() and valid_moves.size() > 0:
			_show_temporary_message("Esta pieza no tiene movimientos legales disponibles")
		
		return true
	else:
		# Si no hay pieza, deseleccionar la pieza actual si existe
		if selected_piece:
			selected_piece.set_selected(false)
			selected_piece = null
			_clear_highlights()
		return false

# Resalta una casilla con el color especificado
func _highlight_square(position: String, color: Color):
	var square = board_grid.get_node_or_null(position)
	if square:
		# Crear un nodo ColorRect para el resaltado
		var highlight = ColorRect.new()
		highlight.name = "Highlight"
		highlight.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
		highlight.color = color
		highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# Eliminar resaltado existente si lo hay
		var existing_highlight = square.get_node_or_null("Highlight")
		if existing_highlight:
			existing_highlight.queue_free()
		
		# Añadir el nuevo resaltado
		square.add_child(highlight)

# Limpia todos los resaltados del tablero
func _clear_highlights():
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			var position = _get_chess_notation(col, row)
			var square = board_grid.get_node_or_null(position)
			if square:
				var highlight = square.get_node_or_null("Highlight")
				if highlight:
					highlight.queue_free()

# Procesa un clic en el tablero
func process_click(click_position: Vector2):
	# Si el juego ya terminó, no procesar más clics
	if !is_game_active:
		return
	
	var notation = get_notation_from_position(click_position)
	if notation.is_empty():
		return
	
	# Si hay una pieza seleccionada, intentar moverla
	if selected_piece:
		var target_piece = pieces.get(notation)
		
		# Si hay una pieza en la posición de destino y es del mismo color, seleccionarla
		if target_piece and target_piece.piece_color == current_turn:
			select_piece(notation)
			return
		
		# Verificar que la pieza seleccionada corresponde al turno actual
		if selected_piece.piece_color != current_turn:
			print("Error: No es el turno de esta pieza")
			selected_piece.set_selected(false)
			selected_piece = null
			_clear_highlights()
			return
		
		# Intentar mover la pieza
		if selected_piece.is_valid_move(notation, board_matrix):
			# Verificar si el movimiento dejaría al rey en jaque
			var king_position = white_king_position if current_turn == ChessPiece.PieceColor.WHITE else black_king_position
			
			# Si la pieza que se mueve es el rey, actualizar la posición para la verificación
			if selected_piece.piece_type == ChessPiece.PieceType.KING:
				king_position = notation
			
			if ChessRules.would_move_cause_check(board_matrix, selected_piece.board_position, notation, king_position, current_turn):
				# Mostrar mensaje de advertencia
				print("Movimiento ilegal: dejaría al rey en jaque")
				_show_temporary_message("¡El rey quedaría en jaque!")
				return
			
			# Verificar si la casilla tiene una pieza para capturar
			if notation in pieces and pieces[notation] != null:
				var piece_to_capture = pieces[notation]
				# Solo capturar piezas del otro color
				if piece_to_capture.piece_color != selected_piece.piece_color:
					capture_piece(notation)
				else:
					return  # No se puede capturar una pieza propia
			
			# Mover la pieza
			move_piece(selected_piece.board_position, notation)
			
			# Si la pieza movida es un rey, actualizar su posición
			if selected_piece.piece_type == ChessPiece.PieceType.KING:
				if selected_piece.piece_color == ChessPiece.PieceColor.WHITE:
					white_king_position = notation
				else:
					black_king_position = notation
			
			# Verificar estado del juego (jaque, jaque mate, etc.)
			_check_game_status()
			
			# Cambiar el turno solo si el juego sigue activo
			if is_game_active:
				_change_turn()
			
			# Limpiar selección
			selected_piece = null
			_clear_highlights()
		else:
			# Si el movimiento no es válido, deseleccionar la pieza
			selected_piece.set_selected(false)
			selected_piece = null
			_clear_highlights()
	else:
		# Intentar seleccionar la pieza en la posición del clic
		if notation in pieces:
			var piece = pieces[notation]
			
			# Verificar que la pieza corresponde al turno actual
			if piece.piece_color != current_turn:
				print("No es tu turno: " + ("Esperando blancas" if current_turn == ChessPiece.PieceColor.WHITE else "Esperando negras"))
				return
		
		# Seleccionar la pieza en la posición del clic
		select_piece(notation)

# Mueve una pieza de una posición a otra
func move_piece(from_position: String, to_position: String) -> bool:
	# Verificar que hay una pieza en la posición de origen
	if from_position not in pieces:
		return false
	
	var piece = pieces[from_position]
	
	# Actualizar la posición en la matriz del tablero
	var value = get_square_value(from_position)
	set_square_value(from_position, 0)  # Vaciar la posición original
	set_square_value(to_position, value)  # Establecer el valor en la nueva posición
	
	# Actualizar la posición de la pieza en el diccionario
	pieces.erase(from_position)
	pieces[to_position] = piece
	
	# Actualizar la posición de la pieza
	piece.move_to(to_position)
	
	# Actualizar la posición visual
	var board_pos = get_board_position(to_position)
	piece.position = Vector2(
		board_pos.x * SQUARE_SIZE + SQUARE_SIZE / 2,
		board_pos.y * SQUARE_SIZE + SQUARE_SIZE / 2
	)
	
	return true

# Captura una pieza en la posición especificada
func capture_piece(position: String) -> bool:
	# Verificar que hay una pieza para capturar
	if position not in pieces or pieces[position] == null:
		return false
	
	var piece_to_capture = pieces[position]
	
	# Determinar qué jugador capturó la pieza
	var captured_by_white = piece_to_capture.piece_color == ChessPiece.PieceColor.BLACK
	
	# Guardar referencia a la pieza capturada antes de eliminarla del tablero
	var captured_piece_type = piece_to_capture.piece_type
	var captured_piece_value = piece_to_capture.get_value()
	var captured_piece_color = piece_to_capture.piece_color
	var capture_position = position
	
	# Mostrar efecto de captura
	_show_capture_effect(position, captured_piece_type, captured_piece_color)
	
	# Actualizar la matriz del tablero
	set_square_value(position, 0)
	
	# Crear una copia visual para mostrar en el panel de capturas
	var captured_piece_sprite = Sprite2D.new()
	captured_piece_sprite.texture = piece_to_capture.get_node("Sprite2D").texture
	captured_piece_sprite.scale = Vector2(0.4, 0.4) # Reducir tamaño para el panel
	
	# Añadir la pieza capturada a la lista correspondiente
	if captured_by_white:
		white_captured_pieces.append({
			"type": captured_piece_type,
			"value": captured_piece_value,
			"position": capture_position,
			"sprite": captured_piece_sprite
		})
		white_captured_grid.add_child(captured_piece_sprite)
	else:
		black_captured_pieces.append({
			"type": captured_piece_type,
			"value": captured_piece_value,
			"position": capture_position,
			"sprite": captured_piece_sprite
		})
		black_captured_grid.add_child(captured_piece_sprite)
	
	# Remover la pieza original del tablero
	piece_to_capture.queue_free()
	
	# Actualizar el diccionario de piezas
	pieces.erase(position)
	
	# Actualizar visualmente los paneles de piezas capturadas
	_update_captured_panels()
	
	return true

# Cambia el turno actual
func _change_turn():
	current_turn = ChessPiece.PieceColor.BLACK if current_turn == ChessPiece.PieceColor.WHITE else ChessPiece.PieceColor.WHITE
	_update_turn_label()
	
	# Emitir señal de cambio de turno
	emit_signal("turn_changed", current_turn)
	
	# Efecto visual para indicar el cambio de turno
	_highlight_turn_change()
	
	# Verificar estado del juego para el nuevo turno
	_check_game_status()

# Actualiza la etiqueta de turno con animación
func _update_turn_label():
	if turn_label and turn_background:
		var turn_text = "Turno: " + ("Blancas" if current_turn == ChessPiece.PieceColor.WHITE else "Negras")
		turn_label.text = turn_text
		
		# Colores según el turno
		var bg_color = Color(0.9, 0.9, 0.9, 0.7) if current_turn == ChessPiece.PieceColor.WHITE else Color(0.2, 0.2, 0.2, 0.7)
		var text_color = Color(0.1, 0.1, 0.1) if current_turn == ChessPiece.PieceColor.WHITE else Color(0.9, 0.9, 0.9)
		
		# Animación de cambio de color
		var tween = create_tween()
		tween.tween_property(turn_background, "color", bg_color, 0.3)
		
		# Actualizar color de la etiqueta
		turn_label.add_theme_color_override("font_color", text_color)
		
		# Efecto de parpadeo para indicar cambio de turno
		tween.tween_property(turn_indicator, "modulate:a", 0.5, 0.2)
		tween.tween_property(turn_indicator, "modulate:a", 1.0, 0.2)

# Destaca visualmente el cambio de turno
func _highlight_turn_change():
	# Obtener todas las piezas del color del turno actual
	var current_color_pieces = []
	for position in pieces:
		var piece = pieces[position]
		if piece.piece_color == current_turn:
			current_color_pieces.append(piece)
	
	# Crear un efecto de resaltado temporal para las piezas del turno actual
	for piece in current_color_pieces:
		# Guardar modulación original
		var original_modulate = piece.modulate
		
		# Aplicar efecto de brillo
		piece.modulate = Color(1.3, 1.3, 1.3, 1.0) if current_turn == ChessPiece.PieceColor.WHITE else Color(0.7, 0.7, 0.9, 1.0)
		
		# Crear temporizador para restaurar el color original
		var timer = get_tree().create_timer(0.5)
		await timer.timeout
		piece.modulate = original_modulate

# Verificar el estado del juego (jaque, jaque mate, tablas)
func _check_game_status():
	# Verificar jaque para blancas
	is_white_in_check = ChessRules.is_in_check(board_matrix, white_king_position, ChessPiece.PieceColor.WHITE)
	
	# Verificar jaque para negras
	is_black_in_check = ChessRules.is_in_check(board_matrix, black_king_position, ChessPiece.PieceColor.BLACK)
	
	# Actualizar visualización de jaque
	_update_check_status()
	
	# Verificar jaque mate o ahogado según el turno actual
	if current_turn == ChessPiece.PieceColor.WHITE:
		if is_white_in_check:
			# Verificar jaque mate para blancas
			if ChessRules.is_checkmate(board_matrix, white_king_position, ChessPiece.PieceColor.WHITE, pieces):
				_show_checkmate(ChessPiece.PieceColor.BLACK)  # Las negras ganan
				return
		else:
			# Verificar ahogado para blancas
			if ChessRules.is_stalemate(board_matrix, white_king_position, ChessPiece.PieceColor.WHITE, pieces):
				_show_stalemate()
				return
	else:
		if is_black_in_check:
			# Verificar jaque mate para negras
			if ChessRules.is_checkmate(board_matrix, black_king_position, ChessPiece.PieceColor.BLACK, pieces):
				_show_checkmate(ChessPiece.PieceColor.WHITE)  # Las blancas ganan
				return
		else:
			# Verificar ahogado para negras
			if ChessRules.is_stalemate(board_matrix, black_king_position, ChessPiece.PieceColor.BLACK, pieces):
				_show_stalemate()
				return

# Actualiza la visualización del estado de jaque
func _update_check_status():
	# Actualizar estado visual para rey blanco
	if is_white_in_check:
		_highlight_square(white_king_position, CHECK_COLOR)
		_show_check_message(ChessPiece.PieceColor.WHITE)
	
	# Actualizar estado visual para rey negro
	if is_black_in_check:
		_highlight_square(black_king_position, CHECK_COLOR)
		_show_check_message(ChessPiece.PieceColor.BLACK)

# Muestra un mensaje de jaque
func _show_check_message(color: int):
	if check_label:
		check_label.text = "¡JAQUE al rey " + ("blanco" if color == ChessPiece.PieceColor.WHITE else "negro") + "!"
		check_label.visible = true
		
		# Animar la etiqueta de jaque
		var tween = create_tween()
		check_label.modulate = Color(1, 0, 0, 1)
		tween.tween_property(check_label, "modulate", Color(1, 1, 1, 1), 0.5)
		
		# Emitir señal de jaque detectado
		emit_signal("check_detected", color)

# Muestra un mensaje de jaque mate
func _show_checkmate(winner_color: int):
	is_game_active = false
	
	# Mostrar mensaje de jaque mate
	if check_label:
		check_label.text = "¡JAQUE MATE! Ganan las " + ("blancas" if winner_color == ChessPiece.PieceColor.WHITE else "negras")
		check_label.visible = true
		
		# Animar la etiqueta de jaque mate
		var tween = create_tween()
		check_label.modulate = Color(1, 0, 0, 1)
		tween.tween_property(check_label, "modulate", Color(1, 1, 1, 1), 0.5)
		tween.tween_property(check_label, "modulate", Color(1, 0, 0, 1), 0.5)
		tween.tween_property(check_label, "modulate", Color(1, 1, 1, 1), 0.5)
	
	# Aplicar efecto visual al rey perdedor
	var loser_king_position = black_king_position if winner_color == ChessPiece.PieceColor.WHITE else white_king_position
	_highlight_square(loser_king_position, CHECK_COLOR)
	
	# Emitir señal de jaque mate detectado
	emit_signal("checkmate_detected", winner_color)
	
	# Mostrar efecto visual de victoria
	_show_victory_effect(winner_color)

# Muestra un mensaje de tablas (ahogado)
func _show_stalemate():
	is_game_active = false
	
	# Mostrar mensaje de tablas
	if check_label:
		check_label.text = "¡TABLAS! (Rey ahogado)"
		check_label.visible = true
	
	# Emitir señal de tablas detectado
	emit_signal("stalemate_detected")

# Muestra un efecto de victoria para el color ganador
func _show_victory_effect(winner_color: int):
	# Aplicar efecto visual a todas las piezas del ganador
	for position in pieces:
		var piece = pieces[position]
		if piece.piece_color == winner_color:
			# Efecto de brillo para las piezas ganadoras
			var tween = create_tween()
			tween.tween_property(piece, "modulate", Color(1.5, 1.5, 0.5, 1), 0.5)
			tween.tween_property(piece, "modulate", Color(1, 1, 1, 1), 0.5)
			tween.set_loops(3)  # Repetir el efecto

# Muestra un mensaje temporal en el tablero
func _show_temporary_message(message: String):
	if check_label:
		# Guardar el texto y visibilidad originales
		var original_text = check_label.text
		var original_visible = check_label.visible
		
		# Mostrar el mensaje temporal
		check_label.text = message
		check_label.visible = true
		
		# Ocultar el mensaje después de un tiempo
		var timer = get_tree().create_timer(2.0)
		await timer.timeout
		
		# Restaurar el estado original solo si el juego sigue activo
		if is_game_active:
			check_label.text = original_text
			check_label.visible = original_visible

# Muestra un efecto visual de captura en la posición especificada
func _show_capture_effect(position: String, piece_type: int, piece_color: int):
	# Convertir la posición del tablero a coordenadas globales
	var board_pos = get_board_position(position)
	var effect_pos = Vector2(
		board_pos.x * SQUARE_SIZE + SQUARE_SIZE / 2,
		board_pos.y * SQUARE_SIZE + SQUARE_SIZE / 2
	) + $BoardContainer.position
	
	# Crear un nodo para el efecto
	var effect = Node2D.new()
	effect.position = effect_pos
	capture_effects_container.add_child(effect)
	
	# Efecto de partículas para la captura
	var particles = CPUParticles2D.new()
	particles.amount = 20
	particles.lifetime = 0.6
	particles.speed_scale = 2.0
	particles.explosiveness = 0.8
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_CIRCLE
	particles.emission_sphere_radius = 5.0
	particles.spread = 180.0
	particles.initial_velocity_min = 50.0
	particles.initial_velocity_max = 150.0
	particles.scale_amount_min = 3.0
	particles.scale_amount_max = 6.0
	
	# Cambiar el color según el tipo de pieza y su color
	var particle_color = Color(1.0, 0.3, 0.3) if piece_color == ChessPiece.PieceColor.BLACK else Color(0.3, 0.3, 1.0)
	
	# Ajustar intensidad del efecto según el valor de la pieza
	var piece_value = PIECE_VALUES[piece_type]
	if piece_value >= PIECE_VALUES[ChessPiece.PieceType.QUEEN]:
		# Efecto más intenso para piezas importantes
		particles.amount = 30
		particles.lifetime = 0.8
		particles.initial_velocity_max = 200.0
		
		# Añadir un segundo color para piezas importantes
		particles.color = particle_color
		particles.color_ramp = Gradient.new()
		particles.color_ramp.colors = [particle_color, Color(1.0, 1.0, 0.3)]
		particles.color_ramp.offsets = [0.0, 1.0]
	else:
		particles.color = particle_color
	
	effect.add_child(particles)
	
	# Efecto de texto "Captura!"
	var capture_label = Label.new()
	capture_label.text = "¡Captura!"
	capture_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	capture_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Estilo del texto
	capture_label.add_theme_font_size_override("font_size", 18)
	capture_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.2))
	
	# Posicionamiento del texto
	capture_label.position = Vector2(-60, -30)
	capture_label.size = Vector2(120, 40)
	effect.add_child(capture_label)
	
	# Animación de desvanecimiento
	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 1.0).set_delay(0.8)
	tween.tween_callback(effect.queue_free)
	
	# Iniciar partículas
	particles.emitting = true

# Actualiza visualmente los paneles de piezas capturadas
func _update_captured_panels():
	# Reorganizar las piezas capturadas blancas
	_arrange_captured_pieces(white_captured_pieces, white_captured_grid)
	
	# Reorganizar las piezas capturadas negras
	_arrange_captured_pieces(black_captured_pieces, black_captured_grid)

# Organiza las piezas capturadas en el grid correspondiente
func _arrange_captured_pieces(captured_list: Array, grid: GridContainer):
	# Ordenar primero por valor (más valioso primero)
	captured_list.sort_custom(func(a, b): return a.value > b.value)
	
	# Posicionar cada pieza en el grid
	for i in range(captured_list.size()):
		var piece_data = captured_list[i]
		var sprite = piece_data.sprite
		
		# Si el sprite ya tiene un padre, removerlo primero
		if sprite.get_parent():
			sprite.get_parent().remove_child(sprite)
		
		# Añadir al grid en la posición correcta
		grid.add_child(sprite)

# Imprime el estado actual del tablero en la consola (para depuración)
func debug_print_board():
	print("Estado actual del tablero:")
	for row in range(BOARD_SIZE):
		var row_str = ""
		for col in range(BOARD_SIZE):
			row_str += str(board_matrix[row][col]) + "\t"
		print(row_str)
	
	# Imprimir información adicional de estado
	print("Rey blanco en: " + white_king_position + " (En jaque: " + str(is_white_in_check) + ")")
	print("Rey negro en: " + black_king_position + " (En jaque: " + str(is_black_in_check) + ")")
	print("Turno actual: " + ("Blancas" if current_turn == ChessPiece.PieceColor.WHITE else "Negras"))
	print("Juego activo: " + str(is_game_active))
