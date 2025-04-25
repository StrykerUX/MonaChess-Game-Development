extends "res://scripts/chess/ChessPiece.gd"
class_name Knight

# Pieza de Caballo para MonaChess
# Versión 0.3.0

# Constantes específicas del caballo
const WHITE_KNIGHT_SPRITE = preload("res://assets/pieces/default/white_knight.png")
const BLACK_KNIGHT_SPRITE = preload("res://assets/pieces/default/black_knight.png")

# Posibles movimientos del caballo (en forma de L)
const KNIGHT_MOVES = [
	Vector2(1, 2),
	Vector2(2, 1),
	Vector2(2, -1),
	Vector2(1, -2),
	Vector2(-1, -2),
	Vector2(-2, -1),
	Vector2(-2, 1),
	Vector2(-1, 2)
]

# Constructor
func _init(color: int, position: String):
	# Llamar al constructor de la superclase
	init(PieceType.KNIGHT, color, position)

# Método llamado cuando el nodo entra al árbol de escenas
func _ready():
	# Cargar el sprite correcto según el color
	if piece_color == PieceColor.WHITE:
		sprite.texture = WHITE_KNIGHT_SPRITE
	else:
		sprite.texture = BLACK_KNIGHT_SPRITE
	
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
	
	# El caballo se mueve en forma de L: 2 casillas en una dirección
	# y luego 1 casilla en perpendicular
	var diff = target_pos - current_pos
	
	# Verificar si el movimiento está en la lista de movimientos posibles del caballo
	for move in KNIGHT_MOVES:
		if diff == move:
			return true
	
	return false

# Obtener lista de movimientos posibles desde la posición actual
func get_valid_moves(board_matrix = null) -> Array:
	var moves = []
	
	# Obtener coordenadas actuales
	var current_pos = get_board_position(board_position)
	
	# Verificar cada uno de los posibles movimientos del caballo
	for move in KNIGHT_MOVES:
		var new_x = current_pos.x + move.x
		var new_y = current_pos.y + move.y
		
		# Verificar que las nuevas coordenadas estén dentro del tablero
		if new_x >= 0 and new_x < 8 and new_y >= 0 and new_y < 8:
			moves.append(get_chess_notation(new_x, new_y))
	
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
