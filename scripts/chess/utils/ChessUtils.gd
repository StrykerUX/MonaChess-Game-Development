extends Object
class_name ChessUtils

# Utilidades para el sistema de ajedrez de MonaChess
# Versión 0.6.0

# Constantes
const BOARD_SIZE = 8

# Convertir notación algebraica a coordenadas de matriz
static func algebraic_to_coords(notation: String) -> Vector2:
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

# Convertir coordenadas de matriz a notación algebraica
static func coords_to_algebraic(coords: Vector2) -> String:
	if coords.x < 0 or coords.x >= BOARD_SIZE or coords.y < 0 or coords.y >= BOARD_SIZE:
		push_error("Coordenadas fuera de rango: " + str(coords))
		return ""
	
	var file = char(97 + int(coords.x))  # 97 = 'a', 98 = 'b', etc.
	var rank = 8 - int(coords.y)  # En ajedrez, el rango 8 está arriba y el 1 abajo
	
	return file + str(rank)

# Verifica si una coordenada está dentro del tablero
static func is_inside_board(coords: Vector2) -> bool:
	return coords.x >= 0 and coords.x < BOARD_SIZE and coords.y >= 0 and coords.y < BOARD_SIZE

# Obtiene la posición del rey de un color específico en el tablero
static func find_king_position(board_matrix: Array, king_color: int) -> String:
	var king_value = ChessPiece.PieceType.KING
	if king_color == ChessPiece.PieceColor.BLACK:
		king_value = -king_value
	
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			if board_matrix[row][col] == king_value:
				return coords_to_algebraic(Vector2(col, row))
	
	# Si no se encuentra el rey (no debería ocurrir en un juego normal)
	push_error("No se encontró el rey de color " + str(king_color))
	return ""

# Convierte un valor de pieza a su tipo y color
static func get_piece_info(piece_value: int) -> Dictionary:
	if piece_value == 0:
		return {"type": -1, "color": -1}  # Casilla vacía
	
	var piece_color = ChessPiece.PieceColor.WHITE if piece_value > 0 else ChessPiece.PieceColor.BLACK
	var piece_type = abs(piece_value)
	
	return {"type": piece_type, "color": piece_color}

# Convierte tipo y color de pieza a su valor en la matriz
static func get_piece_value(piece_type: int, piece_color: int) -> int:
	var value = piece_type
	if piece_color == ChessPiece.PieceColor.BLACK:
		value = -value
	return value