extends Node

# Script para la escena de prueba del tablero de ajedrez
# MonaChess v0.5.0

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
	else:
		push_error("No se encontró el nodo del tablero de ajedrez")

# Función que se ejecuta en cada frame
func _process(_delta):
	# Verificar si se hizo clic en el tablero
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MouseButton.LEFT):
		if chess_board:
			# Pasar la posición del clic al tablero
			chess_board.process_click(get_global_mouse_position())

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
		
		# Información de las piezas en el tablero
		_print_pieces_info()
	else:
		push_error("No se encontró el nodo del tablero de ajedrez")

# Imprime información sobre las piezas en el tablero
func _print_pieces_info():
	if chess_board and chess_board.pieces:
		print("Piezas en el tablero:")
		for position in chess_board.pieces:
			var piece = chess_board.pieces[position]
			print("- " + piece.get_info())
