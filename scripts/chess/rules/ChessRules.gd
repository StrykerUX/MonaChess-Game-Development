extends Object
class_name ChessRules

# Reglas básicas de ajedrez para MonaChess
# Implementa verificación de jaque y jaque mate
# Versión 0.8.0

# Constantes
const BOARD_SIZE = 8

# Verifica si un rey está en jaque
# Recibe la matriz del tablero, la posición del rey, y su color
static func is_in_check(board_matrix: Array, king_position: String, king_color: int) -> bool:
	# Convertir la posición del rey a coordenadas matriciales
	var king_pos = ChessUtils.algebraic_to_coords(king_position)
	if king_pos.x < 0 or king_pos.y < 0:
		push_error("Posición inválida del rey: " + king_position)
		return false
	
	# 1. Verificar ataques de peones
	var pawn_direction = 1 if king_color == ChessPiece.PieceColor.WHITE else -1
	for offset in [Vector2(-1, pawn_direction), Vector2(1, pawn_direction)]:
		var check_x = king_pos.x + offset.x
		var check_y = king_pos.y + offset.y
		
		if check_x >= 0 and check_x < BOARD_SIZE and check_y >= 0 and check_y < BOARD_SIZE:
			var piece_value = board_matrix[check_y][check_x]
			
			# Verificar si hay un peón enemigo
			if (king_color == ChessPiece.PieceColor.WHITE and piece_value == -ChessPiece.PieceType.PAWN) or \
			   (king_color == ChessPiece.PieceColor.BLACK and piece_value == ChessPiece.PieceType.PAWN):
				return true
	
	# 2. Verificar ataques de caballos
	var knight_offsets = [
		Vector2(1, 2), Vector2(2, 1), Vector2(2, -1), Vector2(1, -2),
		Vector2(-1, -2), Vector2(-2, -1), Vector2(-2, 1), Vector2(-1, 2)
	]
	
	for offset in knight_offsets:
		var check_x = king_pos.x + offset.x
		var check_y = king_pos.y + offset.y
		
		if check_x >= 0 and check_x < BOARD_SIZE and check_y >= 0 and check_y < BOARD_SIZE:
			var piece_value = board_matrix[check_y][check_x]
			var piece_type = abs(piece_value)
			var piece_color = ChessPiece.PieceColor.WHITE if piece_value > 0 else ChessPiece.PieceColor.BLACK
			
			# Verificar si hay un caballo enemigo
			if piece_type == ChessPiece.PieceType.KNIGHT and piece_color != king_color:
				return true
	
	# 3. Verificar ataques de rey
	var king_offsets = [
		Vector2(0, 1), Vector2(1, 1), Vector2(1, 0), Vector2(1, -1),
		Vector2(0, -1), Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1)
	]
	
	for offset in king_offsets:
		var check_x = king_pos.x + offset.x
		var check_y = king_pos.y + offset.y
		
		if check_x >= 0 and check_x < BOARD_SIZE and check_y >= 0 and check_y < BOARD_SIZE:
			var piece_value = board_matrix[check_y][check_x]
			var piece_type = abs(piece_value)
			var piece_color = ChessPiece.PieceColor.WHITE if piece_value > 0 else ChessPiece.PieceColor.BLACK
			
			# Verificar si hay un rey enemigo
			if piece_type == ChessPiece.PieceType.KING and piece_color != king_color:
				return true
	
	# 4. Verificar ataques de torres y reinas (horizontal y vertical)
	var rook_directions = [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]
	
	for direction in rook_directions:
		var check_x = king_pos.x
		var check_y = king_pos.y
		
		while true:
			check_x += direction.x
			check_y += direction.y
			
			# Si sale del tablero, romper el ciclo
			if check_x < 0 or check_x >= BOARD_SIZE or check_y < 0 or check_y >= BOARD_SIZE:
				break
			
			var piece_value = board_matrix[check_y][check_x]
			
			# Si hay una pieza en el camino
			if piece_value != 0:
				var piece_type = abs(piece_value)
				var piece_color = ChessPiece.PieceColor.WHITE if piece_value > 0 else ChessPiece.PieceColor.BLACK
				
				# Si es una torre o reina enemiga, está en jaque
				if (piece_type == ChessPiece.PieceType.ROOK or piece_type == ChessPiece.PieceType.QUEEN) and \
				   piece_color != king_color:
					return true
				
				# Si es otra pieza, bloquea la línea
				break
	
	# 5. Verificar ataques de alfiles y reinas (diagonal)
	var bishop_directions = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, -1), Vector2(-1, 1)]
	
	for direction in bishop_directions:
		var check_x = king_pos.x
		var check_y = king_pos.y
		
		while true:
			check_x += direction.x
			check_y += direction.y
			
			# Si sale del tablero, romper el ciclo
			if check_x < 0 or check_x >= BOARD_SIZE or check_y < 0 or check_y >= BOARD_SIZE:
				break
			
			var piece_value = board_matrix[check_y][check_x]
			
			# Si hay una pieza en el camino
			if piece_value != 0:
				var piece_type = abs(piece_value)
				var piece_color = ChessPiece.PieceColor.WHITE if piece_value > 0 else ChessPiece.PieceColor.BLACK
				
				# Si es un alfil o reina enemiga, está en jaque
				if (piece_type == ChessPiece.PieceType.BISHOP or piece_type == ChessPiece.PieceType.QUEEN) and \
				   piece_color != king_color:
					return true
				
				# Si es otra pieza, bloquea la línea
				break
	
	# Si ninguna pieza puede atacar al rey, no está en jaque
	return false

# Verifica si un rey está en jaque mate
static func is_checkmate(board_matrix: Array, king_position: String, king_color: int, pieces: Dictionary) -> bool:
	# Primero verificar si el rey está en jaque (usar la función optimizada)
	if !is_in_check(board_matrix, king_position, king_color):
		return false
	
	# Para cada pieza del mismo color que el rey, verificar si puede realizar un movimiento que saque al rey del jaque
	for position in pieces:
		var piece = pieces[position]
		if piece.piece_color != king_color:
			continue
		
		# Obtener todos los movimientos válidos de la pieza
		var valid_moves = piece.get_valid_moves(board_matrix)
		
		# Para cada movimiento válido, verificar si saca al rey del jaque
		for move in valid_moves:
			# Simular el movimiento
			var temp_board = _copy_board_matrix(board_matrix)
			var piece_value = _get_piece_value(temp_board, position)
			
			# Realizar el movimiento en el tablero temporal
			_set_piece_value(temp_board, position, 0)
			_set_piece_value(temp_board, move, piece_value)
			
			# Si la pieza movida es el rey, actualizar su posición para la verificación
			var king_pos_check = move if position == king_position else king_position
			
			# Verificar si el rey sigue en jaque después del movimiento
			if !is_in_check(temp_board, king_pos_check, king_color):
				return false  # Si hay al menos un movimiento que saque al rey del jaque, no es jaque mate
	
	# Si no se encontró ningún movimiento que saque al rey del jaque, es jaque mate
	return true

# Verifica si hay un ahogado (stalemate)
static func is_stalemate(board_matrix: Array, king_position: String, king_color: int, pieces: Dictionary) -> bool:
	# Verificar que el rey no está en jaque
	if is_in_check(board_matrix, king_position, king_color):
		return false
	
	# Para cada pieza del mismo color que el rey, verificar si puede realizar algún movimiento legal
	for position in pieces:
		var piece = pieces[position]
		if piece.piece_color != king_color:
			continue
		
		# Obtener todos los movimientos válidos de la pieza
		var valid_moves = piece.get_valid_moves(board_matrix)
		
		# Para cada movimiento válido, verificar si deja al rey en jaque
		for move in valid_moves:
			# Simular el movimiento
			var temp_board = _copy_board_matrix(board_matrix)
			var piece_value = _get_piece_value(temp_board, position)
			
			# Realizar el movimiento en el tablero temporal
			_set_piece_value(temp_board, position, 0)
			_set_piece_value(temp_board, move, piece_value)
			
			# Si la pieza movida es el rey, actualizar su posición para la verificación
			var king_pos_check = move if position == king_position else king_position
			
			# Verificar si el rey no está en jaque después del movimiento
			if !is_in_check(temp_board, king_pos_check, king_color):
				return false  # Si hay al menos un movimiento legal, no es ahogado
	
	# Si no se encontró ningún movimiento legal, es ahogado
	return true

# Verifica si un movimiento deja al rey en jaque
static func would_move_cause_check(board_matrix: Array, from_position: String, to_position: String, king_position: String, king_color: int) -> bool:
	# Simular el movimiento
	var temp_board = _copy_board_matrix(board_matrix)
	var piece_value = _get_piece_value(temp_board, from_position)
	
	# Realizar el movimiento en el tablero temporal
	_set_piece_value(temp_board, from_position, 0)
	_set_piece_value(temp_board, to_position, piece_value)
	
	# Si la pieza movida es el rey, actualizar su posición para la verificación
	var king_pos_check = to_position if from_position == king_position else king_position
	
	# Verificar si el rey está en jaque después del movimiento
	return is_in_check(temp_board, king_pos_check, king_color)

# Funciones auxiliares para verificar ataques de piezas específicas

# Verifica si un peón puede atacar una posición específica
static func _can_pawn_attack(board_matrix: Array, pawn_position: String, target_position: String, pawn_color: int) -> bool:
	var pawn_pos = ChessUtils.algebraic_to_coords(pawn_position)
	var target_pos = ChessUtils.algebraic_to_coords(target_position)
	
	# Dirección de movimiento según el color del peón
	var direction = -1 if pawn_color == ChessPiece.PieceColor.WHITE else 1
	
	# Para un peón, solo puede capturar en diagonal
	var x_diff = abs(target_pos.x - pawn_pos.x)
	var y_diff = target_pos.y - pawn_pos.y
	
	# Verificar si puede capturar (diagonal hacia adelante)
	if x_diff == 1 and y_diff == direction:
		return true
	
	return false

# Verifica si un caballo puede atacar una posición específica
static func _can_knight_attack(board_matrix: Array, knight_position: String, target_position: String) -> bool:
	var knight_pos = ChessUtils.algebraic_to_coords(knight_position)
	var target_pos = ChessUtils.algebraic_to_coords(target_position)
	
	# El caballo se mueve en forma de L
	var x_diff = abs(target_pos.x - knight_pos.x)
	var y_diff = abs(target_pos.y - knight_pos.y)
	
	# Verificar patrón de movimiento en L (2-1 o 1-2)
	if (x_diff == 2 and y_diff == 1) or (x_diff == 1 and y_diff == 2):
		return true
	
	return false

# Verifica si un alfil puede atacar una posición específica
static func _can_bishop_attack(board_matrix: Array, bishop_position: String, target_position: String) -> bool:
	var bishop_pos = ChessUtils.algebraic_to_coords(bishop_position)
	var target_pos = ChessUtils.algebraic_to_coords(target_position)
	
	# El alfil se mueve en diagonal
	var x_diff = abs(target_pos.x - bishop_pos.x)
	var y_diff = abs(target_pos.y - bishop_pos.y)
	
	# Si no es movimiento diagonal, no puede atacar
	if x_diff != y_diff:
		return false
	
	# Determinar la dirección de movimiento
	var x_step = 1 if target_pos.x > bishop_pos.x else -1
	var y_step = 1 if target_pos.y > bishop_pos.y else -1
	
	# Verificar si hay piezas en el camino
	var curr_x = bishop_pos.x + x_step
	var curr_y = bishop_pos.y + y_step
	
	# CORRECCIÓN: En diagonal x e y avanzan igual, por lo que basta verificar x
	while curr_x != target_pos.x:
		if board_matrix[curr_y][curr_x] != 0:
			return false  # Hay una pieza en el camino
		curr_x += x_step
		curr_y += y_step
	
	return true

# Verifica si una torre puede atacar una posición específica
static func _can_rook_attack(board_matrix: Array, rook_position: String, target_position: String) -> bool:
	var rook_pos = ChessUtils.algebraic_to_coords(rook_position)
	var target_pos = ChessUtils.algebraic_to_coords(target_position)
	
	# La torre se mueve en línea recta (horizontal o vertical)
	var x_diff = target_pos.x - rook_pos.x
	var y_diff = target_pos.y - rook_pos.y
	
	# Si no es movimiento en línea recta, no puede atacar
	if x_diff != 0 and y_diff != 0:
		return false
	
	# Determinar la dirección de movimiento
	var x_step = 0
	var y_step = 0
	
	if x_diff != 0:
		x_step = 1 if x_diff > 0 else -1
	
	if y_diff != 0:
		y_step = 1 if y_diff > 0 else -1
	
	# Verificar si hay piezas en el camino
	var curr_x = rook_pos.x + x_step
	var curr_y = rook_pos.y + y_step
	
	while curr_x != target_pos.x or curr_y != target_pos.y:
		if board_matrix[curr_y][curr_x] != 0:
			return false  # Hay una pieza en el camino
		curr_x += x_step
		curr_y += y_step
	
	return true

# Verifica si una reina puede atacar una posición específica
static func _can_queen_attack(board_matrix: Array, queen_position: String, target_position: String) -> bool:
	# La reina combina los movimientos de la torre y el alfil
	return _can_rook_attack(board_matrix, queen_position, target_position) or _can_bishop_attack(board_matrix, queen_position, target_position)

# Verifica si un rey puede atacar una posición específica
static func _can_king_attack(board_matrix: Array, king_position: String, target_position: String) -> bool:
	var king_pos = ChessUtils.algebraic_to_coords(king_position)
	var target_pos = ChessUtils.algebraic_to_coords(target_position)
	
	# El rey solo puede moverse una casilla en cualquier dirección
	var x_diff = abs(target_pos.x - king_pos.x)
	var y_diff = abs(target_pos.y - king_pos.y)
	
	# Si está a más de una casilla de distancia, no puede atacar
	if x_diff <= 1 and y_diff <= 1:
		return true
	
	return false

# Crea una copia de la matriz del tablero
static func _copy_board_matrix(board_matrix: Array) -> Array:
	var new_board = []
	for row in board_matrix:
		var new_row = row.duplicate()
		new_board.append(new_row)
	return new_board

# Obtiene el valor de una pieza en la matriz del tablero
static func _get_piece_value(board_matrix: Array, position: String) -> int:
	var pos = ChessUtils.algebraic_to_coords(position)
	if pos.x < 0 or pos.y < 0 or pos.x >= BOARD_SIZE or pos.y >= BOARD_SIZE:
		return 0
	return board_matrix[pos.y][pos.x]

# Establece el valor de una pieza en la matriz del tablero
static func _set_piece_value(board_matrix: Array, position: String, value: int) -> void:
	var pos = ChessUtils.algebraic_to_coords(position)
	if pos.x < 0 or pos.y < 0 or pos.x >= BOARD_SIZE or pos.y >= BOARD_SIZE:
		return
	board_matrix[pos.y][pos.x] = value
