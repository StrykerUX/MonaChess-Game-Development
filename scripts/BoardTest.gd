extends Node

# Script para la escena de prueba del tablero de ajedrez
# MonaChess v0.1.0

@onready var chess_board = $ChessBoard
@onready var back_button = $BackButton
@onready var debug_button = $DebugButton

# Ruta a la escena del menú principal
const MAIN_MENU_SCENE = "res://scenes/MainMenu.tscn"

func _ready():
	print("Escena de prueba del tablero iniciada")
	
	# Conectar señales de botones
	back_button.pressed.connect(_on_back_button_pressed)
	debug_button.pressed.connect(_on_debug_button_pressed)
	
	# Configuración inicial del tablero
	if chess_board:
		print("Tablero de ajedrez encontrado")
		
		# Prueba: establecer algunos valores en el tablero para demostrar funcionalidad
		_setup_test_values()
	else:
		push_error("No se encontró el nodo del tablero de ajedrez")

# Configura algunos valores de prueba en el tablero
func _setup_test_values():
	# En esta versión solo establecemos valores numéricos para demostrar la matriz
	# En versiones futuras, serán reemplazados por instancias reales de piezas
	
	# Establecer algunas posiciones de ejemplo
	chess_board.set_square_value("e4", 1)  # Por ejemplo, 1 podría representar un peón blanco
	chess_board.set_square_value("e5", -1) # -1 podría representar un peón negro
	chess_board.set_square_value("d4", 2)  # 2 podría ser una reina blanca
	chess_board.set_square_value("f5", -3) # -3 podría ser un alfil negro

# Función que se ejecuta al presionar el botón de regresar
func _on_back_button_pressed():
	print("Volviendo al menú principal...")
	
	# Verificar que el SceneLoader esté disponible
	if not Engine.has_singleton("SceneLoader"):
		push_error("Error: El SceneLoader no está disponible")
		return
	
	# Verificar que la escena del menú principal exista
	if FileAccess.file_exists(MAIN_MENU_SCENE):
		SceneLoader.goto_scene(MAIN_MENU_SCENE)
	else:
		push_error("Error: No se encuentra la escena del menú principal")

# Función que se ejecuta al presionar el botón de depuración
func _on_debug_button_pressed():
	print("Depurando estado del tablero...")
	
	if chess_board:
		# Imprimir el estado actual del tablero en la consola
		chess_board.debug_print_board()
		
		# Probar algunas conversiones de notación
		_test_chess_notation()
	else:
		push_error("No se encontró el nodo del tablero de ajedrez")

# Prueba algunas conversiones de notación de ajedrez
func _test_chess_notation():
	var test_positions = ["a1", "h8", "e4", "b7", "f2"]
	
	print("Prueba de conversión de notación de ajedrez:")
	for pos in test_positions:
		var board_pos = chess_board.get_board_position(pos)
		var value = chess_board.get_square_value(pos)
		print("Posición " + pos + " -> (" + str(board_pos.x) + ", " + str(board_pos.y) + ") = " + str(value))
