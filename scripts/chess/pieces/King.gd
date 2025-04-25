extends "res://scripts/chess/ChessPiece.gd"
class_name King

# Pieza de Rey para MonaChess
# Versión 0.2.0

# Constantes específicas del rey
const WHITE_KING_SPRITE = preload("res://assets/pieces/default/white_king.png")
const BLACK_KING_SPRITE = preload("res://assets/pieces/default/black_king.png")

# Constructor
func _init(color: int, position: String):
	# Llamar al constructor de la superclase
	init(PieceType.KING, color, position)

# Método llamado cuando el nodo entra al árbol de escenas
func _ready():
	# Cargar el sprite correcto según el color
	if piece_color == PieceColor.WHITE:
		sprite.texture = WHITE_KING_SPRITE
	else:
		sprite.texture = BLACK_KING_SPRITE
	
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
	
	# El rey puede moverse una casilla en cualquier dirección
	var x_diff = abs(target_pos.x - current_pos.x)
	var y_diff = abs(target_pos.y - current_pos.y)
	
	# Movimiento válido si la diferencia en x e y es como máximo 1
	return x_diff <= 1 && y_diff <= 1
	
	# Nota: En versión 0.2.0 no implementamos el enroque, 
	# será implementado en una versión futura

# Obtener lista de movimientos posibles desde la posición actual
func get_valid_moves() -> Array:
	var moves = []
	
	# Obtener coordenadas actuales
	var current_pos = get_board_position(board_position)
	
	# El rey puede moverse una casilla en cualquier dirección
	# Iteramos por las 8 casillas adyacentes
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			# Saltar la posición actual
			if dx == 0 && dy == 0:
				continue
				
			var new_x = current_pos.x + dx
			var new_y = current_pos.y + dy
			
			# Verificar que las coordenadas sean válidas
			if new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8:
				var new_pos = get_chess_notation(new_x, new_y)
				moves.append(new_pos)
	
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
