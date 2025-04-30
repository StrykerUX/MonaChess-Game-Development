extends Node
# ResourceManager.gd
# Gestor centralizado de recursos para MonaChess
# Versión 0.8.0

# Diccionarios para almacenar recursos precargados
var textures = {}
var audio = {}
var animations = {}

# Bandera para rastrear el estado de carga
var loading_completed = false

# Cargar recursos al iniciar
func _ready():
	print("ResourceManager: Iniciando precarga de recursos...")
	preload_resources()

# Método principal para precargar todos los recursos
func preload_resources():
	_preload_textures()
	_preload_audio()
	_preload_animations()
	
	loading_completed = true
	print("ResourceManager: Precarga completada")

# Precargar texturas de piezas y UI
func _preload_textures():
	# Piezas blancas
	textures["white_pawn"] = load("res://assets/pieces/default/white_pawn.png")
	textures["white_knight"] = _safe_load("res://assets/pieces/default/white_knight.png")
	textures["white_bishop"] = _safe_load("res://assets/pieces/default/white_bishop.png")
	textures["white_rook"] = _safe_load("res://assets/pieces/default/white_rook.png")
	textures["white_queen"] = _safe_load("res://assets/pieces/default/white_queen.png")
	textures["white_king"] = _safe_load("res://assets/pieces/default/white_king.png")
	
	# Piezas negras
	textures["black_pawn"] = _safe_load("res://assets/pieces/default/black_pawn.png")
	textures["black_knight"] = _safe_load("res://assets/pieces/default/black_knight.png")
	textures["black_bishop"] = _safe_load("res://assets/pieces/default/black_bishop.png")
	textures["black_rook"] = _safe_load("res://assets/pieces/default/black_rook.png")
	textures["black_queen"] = _safe_load("res://assets/pieces/default/black_queen.png")
	textures["black_king"] = _safe_load("res://assets/pieces/default/black_king.png")
	
	# UI y efectos
	textures["check_effect"] = _safe_load("res://assets/effects/check_effect.png")
	textures["capture_effect"] = _safe_load("res://assets/effects/capture_effect.png")
	textures["highlight"] = _safe_load("res://assets/ui/highlight.png")
	
	print("ResourceManager: Texturas precargadas: ", textures.size())

# Precargar recursos de audio
func _preload_audio():
	# Efectos de sonido
	audio["move"] = _safe_load("res://assets/audio/move.wav")
	audio["capture"] = _safe_load("res://assets/audio/capture.wav")
	audio["check"] = _safe_load("res://assets/audio/check.wav")
	audio["checkmate"] = _safe_load("res://assets/audio/checkmate.wav")
	audio["menu_select"] = _safe_load("res://assets/audio/menu_select.wav")
	audio["menu_hover"] = _safe_load("res://assets/audio/menu_hover.wav")
	
	print("ResourceManager: Audio precargado: ", audio.size())

# Precargar animaciones
func _preload_animations():
	# Animaciones
	animations["check_anim"] = _safe_load("res://resources/animations/check_animation.tres")
	animations["capture_anim"] = _safe_load("res://resources/animations/capture_animation.tres")
	animations["checkmate_anim"] = _safe_load("res://resources/animations/checkmate_animation.tres")
	
	print("ResourceManager: Animaciones precargadas: ", animations.size())

# Función helper para cargar un recurso de forma segura
func _safe_load(path):
	if ResourceLoader.exists(path):
		return load(path)
	else:
		push_warning("ResourceManager: No se pudo encontrar el recurso: " + path)
		return null

# Obtener una textura precargada
func get_texture(name: String) -> Texture2D:
	if textures.has(name):
		return textures[name]
	else:
		push_warning("ResourceManager: Textura no precargada: " + name)
		return null

# Obtener un audio precargado
func get_audio(name: String) -> AudioStream:
	if audio.has(name):
		return audio[name]
	else:
		push_warning("ResourceManager: Audio no precargado: " + name)
		return null

# Obtener una animación precargada
func get_animation(name: String) -> Animation:
	if animations.has(name):
		return animations[name]
	else:
		push_warning("ResourceManager: Animación no precargada: " + name)
		return null

# Función para precargar un recurso adicional en tiempo de ejecución
func preload_resource(path: String, type: String, name: String) -> bool:
	var resource = _safe_load(path)
	if resource == null:
		return false
	
	match type:
		"texture":
			textures[name] = resource
		"audio":
			audio[name] = resource
		"animation":
			animations[name] = resource
		_:
			push_warning("ResourceManager: Tipo de recurso no soportado: " + type)
			return false
	
	return true
