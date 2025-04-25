extends Node2D

# Tablero de ajedrez para MonaChess
# Implementa un tablero 8x8 con coordenadas estándar (A1-H8)
# Versión 0.1.0

# Constantes de configuración del tablero
const BOARD_SIZE = 8
const SQUARE_SIZE = 67.5  # Tamaño de cada casilla en píxeles (540px / 8)

# Colores para las casillas del tablero
const DARK_SQUARE_COLOR = Color(0.25, 0.25, 0.35, 1.0)  # Azul oscuro
const LIGHT_SQUARE_COLOR = Color(0.85, 0.85, 0.95, 1.0) # Blanco azulado

# Matriz para representar el estado del tablero
# 0 = vacío, valores positivos = piezas blancas, valores negativos = piezas negras
# Se implementará el sistema de piezas en la versión 0.2.0
var board_matrix = []

# Nodos del tablero
@onready var board_grid = $BoardContainer/Board

# Función que se ejecuta cuando el nodo entra al árbol de escenas
func _ready():
	print("Inicializando tablero de ajedrez...")
	
	# Inicializar la matriz del tablero
	_initialize_board_matrix()
	
	# Crear representación visual del tablero
	_create_board_squares()
	
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

# Imprime el estado actual del tablero en la consola (para depuración)
func debug_print_board():
	print("Estado actual del tablero:")
	for row in range(BOARD_SIZE):
		var row_str = ""
		for col in range(BOARD_SIZE):
			row_str += str(board_matrix[row][col]) + " "
		print(row_str)
