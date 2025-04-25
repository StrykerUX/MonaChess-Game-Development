extends "res://scripts/chess/ChessPiece.gd"
class_name Pawn

# Pieza de Peón para MonaChess
# Versión 0.2.0

# Constantes específicas del peón
const WHITE_PAWN_SPRITE = preload("res://assets/pieces/default/white_pawn.png")
const BLACK_PAWN_SPRITE = preload("res://assets/pieces/default/black_pawn.png")

# Direcciones de movimiento del peón (filas)
# Los peones blancos suben (-1), los negros bajan (+1)
var move_direction: int

# Constructor
func _init(color: int, position: String):
	# Llamar al constructor de la superclase
	init(PieceType.PAWN, color, position)
	
	# Inicializar dirección de movimiento
	move_direction = -1 if color == PieceColor.WHITE else 1

# Método llamado cuando el nodo entra al árbol de escenas
func _ready():
	# Cargar el sprite correcto según el color
	if piece_color == PieceColor.WHITE:
		sprite.texture = WHITE_PAWN_SPRITE
	else:
		sprite.texture = BLACK_PAWN_SPRITE
	
	# Nombrar el nodo para fácil identificación
	name = get_color_name() + get_piece_type_name() + board_position

# Verificar si el movimiento a la posición objetivo es válido
func is_valid_move(target_position: String) -> bool:
	# En la versión 0.2.0 implementamos validación simple
	# Una implementación completa se realizará en versiones futuras
	
	# 1. Verificar que la posición objetivo sea diferente a la actual
	if target_position == board_position:
		return false
	
	# 2. Obtener coordenadas de matriz para las posiciones
	var current_pos = get_board_position(board_position)
	var target_pos = get_board_position(target_position)
	
	# 3. Verificar que las coordenadas sean válidas
	if current_pos.x < 0 or current_pos.y < 0 or target_pos.x < 0 or target_pos.y < 0:
		return false
	
	# En esta versión solo verificamos que el movimiento sea en la dirección correcta
	# y que sea a lo sumo de 2 casillas (en caso de primer movimiento)
	
	# Mismo archivo (columna)
	if current_pos.x == target_pos.x:
		# Primer movimiento: puede avanzar 1 o 2 casillas
		if not has_moved && target_pos.y == current_pos.y + move_direction * 2:
			return true
		
		# Movimiento regular: solo 1 casilla
		if target_pos.y == current_pos.y + move_direction:
			return true
	
	# Movimiento diagonal (captura)
	# En versión 0.2.0 no implementamos esto completamente porque no tenemos
	# información sobre piezas en el tablero, solo validación básica
	
	return false

# Obtener lista de movimientos posibles desde la posición actual
func get_valid_moves() -> Array:
	var moves = []
	
	# Obtener coordenadas actuales
	var current_pos = get_board_position(board_position)
	
	# Verificar movimiento hacia adelante
	var forward_y = current_pos.y + move_direction
	if forward_y >= 0 && forward_y < 8:
		var forward_pos = get_chess_notation(current_pos.x, forward_y)
		moves.append(forward_pos)
	
	# Si es el primer movimiento, verificar dos casillas adelante
	if !has_moved:
		var forward_2y = current_pos.y + 2 * move_direction
		if forward_2y >= 0 && forward_2y < 8:
			var forward_2_pos = get_chess_notation(current_pos.x, forward_2y)
			moves.append(forward_2_pos)
	
	# En la versión 0.2.0 no incluimos capturas diagonales
	# porque no tenemos información de piezas en el tablero aún
	
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
