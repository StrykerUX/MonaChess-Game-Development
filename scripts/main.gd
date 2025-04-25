extends Node

# Escena principal del juego MonaChess
# Esta escena se carga al iniciar el juego y redirige al menú principal

# Ruta a la escena del menú principal
const MAIN_MENU_SCENE = "res://scenes/MainMenu.tscn"

# Función que se ejecuta cuando la escena está lista
func _ready():
	print("Iniciando MonaChess - Versión 0.0.0")
	
	# Verificar que los singletons estén cargados
	if not Engine.has_singleton("GameManager") or not Engine.has_singleton("SceneLoader"):
		push_error("Error: No se han cargado correctamente los singletons necesarios")
		get_tree().quit(1)
		return
	
	# El timer se encargará de cargar el menú principal después de un tiempo
	$InfoLabel.text = "Cargando estructuras básicas..."

# Función que se llama cuando termina el temporizador
func _on_init_timer_timeout():
	$InfoLabel.text = "Cargando menú principal..."
	
	# Precargar el menú principal para una transición más fluida
	if FileAccess.file_exists(MAIN_MENU_SCENE):
		SceneLoader.preload_scene(MAIN_MENU_SCENE)
		
		# Esperar un momento y cargar el menú principal
		await get_tree().create_timer(0.5).timeout
		SceneLoader.goto_scene(MAIN_MENU_SCENE, true)
	else:
		push_error("Error: No se encuentra la escena del menú principal")
		$InfoLabel.text = "Error: No se encuentra la escena del menú principal"
