extends "res://scripts/chess/ChessPiece.gd"
class_name Queen

# Pieza de Reina para MonaChess
# Versión 0.3.0

# Constantes específicas de la reina
const WHITE_QUEEN_SPRITE = preload("res://assets/pieces/default/white_queen.png")
const BLACK_QUEEN_SPRITE = preload("res://assets/pieces/default/black_queen.png")

# Constructor
func _init(color: int, position: String):
	# Llamar al constructor de la superclase
	init(PieceType.QUEEN, color, position)

# Método llamado cuando el nodo entra al árbol de escenas
func _ready():
	# Cargar el sprite correcto según el color
	if piece_color == PieceColor.WHITE:
		sprite.texture = WHITE_QUEEN_SPRITE
	else:
		sprite.texture = BLACK_QUEEN_SPRITE
	
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
	
	# La reina se mueve como combinación de torre y alfil:
	# - En línea recta horizontal o vertical (como torre)
	# - En diagonal (como alfil)
	
	# Verificar movimiento horizontal (misma fila)
	if current_pos.y == target_pos.y:
		return true
	
	# Verificar movimiento vertical (misma columna)
	if current_pos.x == target_pos.x:
		return true
	
	# Verificar movimiento diagonal
	var x_diff = abs(target_pos.x - current_pos.x)
	var y_diff = abs(target_pos.y - current_pos.y)
	
	if x_diff == y_diff:
		return true
	
	# Si no cumple ninguna condición, el movimiento no es válido
	return false

# Obtener lista de movimientos posibles desde la posición actual
func get_valid_moves(board_matrix = null) -> Array:
	var moves = []
	
	# Obtener coordenadas actuales
	var current_pos = get_board_position(board_position)
	
	# Combinamos los movimientos de la torre y el alfil
	
	# 1. Movimientos horizontales (izquierda y derecha) - Como Torre
	for x in range(8):
		if x != current_pos.x:
			var horizontal_move = get_chess_notation(x, current_pos.y)
			moves.append(horizontal_move)
	
	# 2. Movimientos verticales (arriba y abajo) - Como Torre
	for y in range(8):
		if y != current_pos.y:
			var vertical_move = get_chess_notation(current_pos.x, y)
			moves.append(vertical_move)
	
	# 3. Diagonales - Como Alfil
	# Diagonal superior derecha (↗)
	for i in range(1, 8):
		var new_x = current_pos.x + i
		var new_y = current_pos.y - i
		if new_x < 8 and new_y >= 0:
			moves.append(get_chess_notation(new_x, new_y))
		else:
			break
	
	# Diagonal superior izquierda (↖)
	for i in range(1, 8):
		var new_x = current_pos.x - i
		var new_y = current_pos.y - i
		if new_x >= 0 and new_y >= 0:
			moves.append(get_chess_notation(new_x, new_y))
		else:
			break
	
	# Diagonal inferior derecha (↘)
	for i in range(1, 8):
		var new_x = current_pos.x + i
		var new_y = current_pos.y + i
		if new_x < 8 and new_y < 8:
			moves.append(get_chess_notation(new_x, new_y))
		else:
			break
	
	# Diagonal inferior izquierda (↙)
	for i in range(1, 8):
		var new_x = current_pos.x - i
		var new_y = current_pos.y + i
		if new_x >= 0 and new_y < 8:
			moves.append(get_chess_notation(new_x, new_y))
		else:
			break
	
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
