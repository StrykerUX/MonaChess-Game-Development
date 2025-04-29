extends Node2D
class_name ChessPiece

# Clase base para todas las piezas de ajedrez en MonaChess
# Versión 0.5.0

# Enumeración para los tipos de piezas
enum PieceType {
	PAWN,
	KNIGHT,
	BISHOP,
	ROOK,
	QUEEN,
	KING
}

# Enumeración para los colores de las piezas
enum PieceColor {
	WHITE,
	BLACK
}

# Propiedades de la pieza
var piece_type: int
var piece_color: int
var board_position: String  # Coordenada de ajedrez (a1-h8)
var has_moved: bool = false
var selected: bool = false

# Valores de las piezas para la evaluación de la IA (futuras versiones)
# Convenciones estándar de ajedrez: peón=1, caballo=3, alfil=3, torre=5, reina=9, rey=∞
const PIECE_VALUES = {
	PieceType.PAWN: 1,
	PieceType.KNIGHT: 3,
	PieceType.BISHOP: 3,
	PieceType.ROOK: 5,
	PieceType.QUEEN: 9,
	PieceType.KING: 100  # Valor alto para el rey (no infinito por limitaciones prácticas)
}

# Sprites para las piezas (se asignarán en las subclases)
@onready var sprite = $Sprite2D

# Constructor (se llama desde las piezas específicas)
func init(type: int, color: int, position: String) -> ChessPiece:
	piece_type = type
	piece_color = color
	board_position = position
	return self

# Función para obtener el valor de la pieza
func get_value() -> int:
	return PIECE_VALUES[piece_type]

# Función para mover la pieza a una nueva posición
func move_to(new_position: String) -> void:
	board_position = new_position
	has_moved = true

# Función para marcar la pieza como seleccionada o deseleccionada
func set_selected(is_selected: bool) -> void:
	selected = is_selected
	if selected:
		modulate = Color(1.2, 1.2, 0.8)  # Tinte amarillo para piezas seleccionadas
	else:
		modulate = Color(1, 1, 1)  # Color normal

# Función para obtener el nombre del tipo de pieza como texto
func get_piece_type_name() -> String:
	match piece_type:
		PieceType.PAWN:
			return "Peón"
		PieceType.KNIGHT:
			return "Caballo"
		PieceType.BISHOP:
			return "Alfil"
		PieceType.ROOK:
			return "Torre"
		PieceType.QUEEN:
			return "Reina"
		PieceType.KING:
			return "Rey"
		_:
			return "Desconocido"

# Función para obtener el color de la pieza como texto
func get_color_name() -> String:
	match piece_color:
		PieceColor.WHITE:
			return "Blanca"
		PieceColor.BLACK:
			return "Negra"
		_:
			return "Desconocido"

# Función para obtener información de la pieza como texto
func get_info() -> String:
	return get_color_name() + " " + get_piece_type_name() + " en " + board_position

# Función virtual para validar si un movimiento es válido para esta pieza
# Será implementada por cada subclase de pieza
func is_valid_move(target_position: String) -> bool:
	# La validación específica de movimiento se implementará en las subclases
	push_error("Función is_valid_move debe ser implementada por subclases")
	return false

# Función virtual para obtener todas las posiciones válidas para esta pieza
func get_valid_moves() -> Array:
	# Implementación básica que será sobreescrita por las subclases
	return []
