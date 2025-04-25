extends Node2D

# Tablero de ajedrez para MonaChess
# Implementa un tablero 8x8 con coordenadas estándar (A1-H8)
# Versión 0.2.0

# Constantes de configuración del tablero
const BOARD_SIZE = 8
const SQUARE_SIZE = 67.5  # Tamaño de cada casilla en píxeles (540px / 8)

# Colores para las casillas del tablero
const DARK_SQUARE_COLOR = Color(0.25, 0.25, 0.35, 1.0)  # Azul oscuro
const LIGHT_SQUARE_COLOR = Color(0.85, 0.85, 0.95, 1.0) # Blanco azulado

# Colores para resaltar casillas
const HIGHLIGHT_COLOR = Color(0.2, 0.8, 0.2, 0.4)  # Verde semi-transparente
const SELECTED_COLOR = Color(0.9, 0.9, 0.2, 0.4)   # Amarillo semi-transparente

# Precarga de escenas de piezas
const PAWN_SCENE = preload("res://scenes/board/pieces/Pawn.tscn")
const KING_SCENE = preload("res://scenes/board/pieces/King.tscn")

# Matriz para representar el estado del tablero
# 0 = vacío, valores positivos = piezas blancas, valores negativos = piezas negras
var board_matrix = []

# Diccionario para mantener referencias a las piezas en el tablero
var pieces = {}

# Variable para la pieza seleccionada actualmente
var selected_piece = null

# Nodos del tablero
@onready var board_grid = $BoardContainer/Board

# Función que se ejecuta cuando el nodo entra al árbol de escenas
func _ready():
	print("Inicializando tablero de ajedrez...")
	
	# Inicializar la matriz del tablero
	_initialize_board_matrix()
	
	# Crear representación visual del tablero
	_create_board_squares()
	
	# Configurar el inicio de las piezas
	_setup_initial_pieces()
	
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
	# En la versión 0.2.0, colocaremos solo algunos peones y reyes
	# como demostración de la funcionalidad
	
	# Crear peones blancos en segunda fila
	for file in "abcdefgh":
		var position = file + "2"
		_create_piece(PAWN_SCENE, ChessPiece.PieceColor.WHITE, position)
	
	# Crear un peón negro en posición e7
	_create_piece(PAWN_SCENE, ChessPiece.PieceColor.BLACK, "e7")
	
	# Crear rey blanco en e1
	_create_piece(KING_SCENE, ChessPiece.PieceColor.WHITE, "e1")
	
	# Crear rey negro en e8
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
		# Si ya hay una pieza seleccionada, deseleccionarla
		if selected_piece:
			selected_piece.set_selected(false)
		
		# Seleccionar la nueva pieza
		selected_piece = pieces[position]
		selected_piece.set_selected(true)
		
		# Resaltar la casilla de la pieza seleccionada
		_highlight_square(position, SELECTED_COLOR)
		
		# Resaltar movimientos posibles
		var valid_moves = selected_piece.get_valid_moves()
		for move in valid_moves:
			_highlight_square(move, HIGHLIGHT_COLOR)
		
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
	var notation = get_notation_from_position(click_position)
	if notation.is_empty():
		return
	
	# Si hay una pieza seleccionada, intentar moverla
	if selected_piece and selected_piece.is_valid_move(notation):
		move_piece(selected_piece.board_position, notation)
		_clear_highlights()
		selected_piece = null
	else:
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

# Imprime el estado actual del tablero en la consola (para depuración)
func debug_print_board():
	print("Estado actual del tablero:")
	for row in range(BOARD_SIZE):
		var row_str = ""
		for col in range(BOARD_SIZE):
			row_str += str(board_matrix[row][col]) + " "
		print(row_str)
