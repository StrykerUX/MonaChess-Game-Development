extends "res://scripts/chess/ChessPiece.gd"
class_name Rook

# Pieza de Torre para MonaChess
# Versión 0.3.0

# Constantes específicas de la torre
const WHITE_ROOK_SPRITE = preload("res://assets/pieces/default/white_rook.png")
const BLACK_ROOK_SPRITE = preload("res://assets/pieces/default/black_rook.png")

# Constructor
func _init(color: int, position: String):
	# Llamar al constructor de la superclase
	init(PieceType.ROOK, color, position)

# Método llamado cuando el nodo entra al árbol de escenas
func _ready():
	# Cargar el sprite correcto según el color
	if piece_color == PieceColor.WHITE:
		sprite.texture = WHITE_ROOK_SPRITE
	else:
		sprite.texture = BLACK_ROOK_SPRITE
	
	# Nombrar el nodo para fácil identificación
	name = get_color_name() + get_piece_type_name() + board_position

# Verificar si el movimiento a la posición objetivo es válido
func is_valid_move(target_position: String, board_matrix = null) -> bool:
	# 1. Verificar que la posición objetivo sea diferente a la actual
	if target_position == board_position:
		return false
	
	# 2. Obtener coordenadas de matriz para las posiciones
	var current_pos = get_board_position(board_position)
	var target_pos = get_board_position(target_position)
	
	# 3. Verificar que las coordenadas sean válidas
	if current_pos.x < 0 or current_pos.y < 0 or target_pos.x < 0 or target_pos.y < 0:
		return false
	
	# La torre se mueve en línea recta (misma fila o misma columna)
	# pero no puede saltar otras piezas
	
	# Verificar movimiento horizontal (misma fila)
	if current_pos.y == target_pos.y:
		return true
	
	# Verificar movimiento vertical (misma columna)
	if current_pos.x == target_pos.x:
		return true
	
	# Si no cumple ninguna condición, el movimiento no es válido
	return false

# Obtener lista de movimientos posibles desde la posición actual
func get_valid_moves(board_matrix = null) -> Array:
	var moves = []
	
	# Obtener coordenadas actuales
	var current_pos = get_board_position(board_position)
	
	# Movimientos horizontales (izquierda y derecha)
	for x in range(8):
		if x != current_pos.x:
			var horizontal_move = get_chess_notation(x, current_pos.y)
			moves.append(horizontal_move)
	
	# Movimientos verticales (arriba y abajo)
	for y in range(8):
		if y != current_pos.y:
			var vertical_move = get_chess_notation(current_pos.x, y)
			moves.append(vertical_move)
	
	return moves

# Convierte coordenadas de matriz (0-7, 0-7) a notación de ajedrez (a1-h8)
func get_chess_notation(col, row) -> String:
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
