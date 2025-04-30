extends Node
# SaveManager.gd
# Sistema de guardado y carga de partidas
# Versión 0.8.0

# Constantes
const SAVE_DIR = "user://saves/"
const SAVE_FILE_EXTENSION = ".chess"
const META_FILENAME = "save_meta.json"
const MAX_SAVES = 5

# Variables
var current_save_name = ""
var save_metadata = {}

# Señales
signal game_saved(save_name)
signal game_loaded(save_name)
signal save_error(message)
signal load_error(message)

# Inicialización
func _ready():
	_initialize_save_system()

# Crear directorio de guardado si no existe
func _initialize_save_system():
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists(SAVE_DIR.trim_suffix("/")):
		dir.make_dir(SAVE_DIR.trim_suffix("/"))
		print("SaveManager: Directorio de guardado creado")
	
	_load_metadata()

# Cargar metadatos de los archivos de guardado
func _load_metadata():
	if FileAccess.file_exists(SAVE_DIR + META_FILENAME):
		var file = FileAccess.open(SAVE_DIR + META_FILENAME, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			save_metadata = json.get_data()
			print("SaveManager: Metadatos cargados, %d guardados encontrados" % save_metadata.size())
		else:
			push_error("SaveManager: Error al parsear metadatos: " + json.get_error_message())
			save_metadata = {}
	else:
		save_metadata = {}
		print("SaveManager: No se encontraron metadatos, inicializando archivo")
		_save_metadata()

# Guardar metadatos
func _save_metadata():
	var file = FileAccess.open(SAVE_DIR + META_FILENAME, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_metadata, "  "))
	file.close()
	print("SaveManager: Metadatos guardados")

# Guardar una partida
func save_game(board_data: Dictionary, save_name: String = "") -> bool:
	# Si no se proporciona nombre, crear uno automático
	if save_name.is_empty():
		save_name = "partida_" + Time.get_datetime_string_from_system().replace(":", "-").replace(" ", "_")
	
	# Añadir fecha y hora al diccionario
	var save_data = board_data.duplicate()
	var datetime = Time.get_datetime_dict_from_system()
	save_data["save_date"] = {
		"year": datetime.year,
		"month": datetime.month,
		"day": datetime.day,
		"hour": datetime.hour,
		"minute": datetime.minute,
		"second": datetime.second
	}
	save_data["save_name"] = save_name
	
	# Guardar el archivo
	var path = SAVE_DIR + save_name + SAVE_FILE_EXTENSION
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("SaveManager: Error al crear archivo de guardado")
		emit_signal("save_error", "Error al crear archivo de guardado")
		return false
	
	file.store_string(JSON.stringify(save_data, "  "))
	file.close()
	
	# Actualizar metadatos
	save_metadata[save_name] = {
		"date": save_data.save_date,
		"file": save_name + SAVE_FILE_EXTENSION,
		"timestamp": Time.get_unix_time_from_system()
	}
	_save_metadata()
	
	current_save_name = save_name
	print("SaveManager: Juego guardado como '%s'" % save_name)
	emit_signal("game_saved", save_name)
	return true

# Cargar una partida
func load_game(save_name: String) -> Dictionary:
	var path = SAVE_DIR + save_name + SAVE_FILE_EXTENSION
	
	if not FileAccess.file_exists(path):
		push_error("SaveManager: Archivo de guardado no encontrado: " + path)
		emit_signal("load_error", "Archivo de guardado no encontrado")
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("SaveManager: Error al abrir archivo de guardado")
		emit_signal("load_error", "Error al abrir archivo de guardado")
		return {}
	
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		push_error("SaveManager: Error al parsear archivo de guardado: " + json.get_error_message())
		emit_signal("load_error", "Formato de archivo inválido")
		return {}
	
	var save_data = json.get_data()
	current_save_name = save_name
	print("SaveManager: Juego cargado: '%s'" % save_name)
	emit_signal("game_loaded", save_name)
	return save_data

# Eliminar un guardado
func delete_save(save_name: String) -> bool:
	var path = SAVE_DIR + save_name + SAVE_FILE_EXTENSION
	
	if FileAccess.file_exists(path):
		var err = DirAccess.remove_absolute(path)
		if err != OK:
			push_error("SaveManager: Error al eliminar archivo de guardado: %s" % err)
			return false
		
		# Actualizar metadatos
		if save_metadata.has(save_name):
			save_metadata.erase(save_name)
			_save_metadata()
		
		print("SaveManager: Guardado '%s' eliminado" % save_name)
		return true
	
	push_error("SaveManager: No se puede eliminar, el archivo no existe: " + path)
	return false

# Obtener lista de guardados disponibles
func get_save_list() -> Array:
	var saves = []
	
	for save_name in save_metadata:
		var meta = save_metadata[save_name]
		
		# Verificar que el archivo existe
		if not FileAccess.file_exists(SAVE_DIR + meta.file):
			continue
		
		# Añadir a la lista
		saves.append({
			"name": save_name,
			"date": meta.date,
			"timestamp": meta.timestamp
		})
	
	# Ordenar por fecha más reciente
	saves.sort_custom(func(a, b): return a.timestamp > b.timestamp)
	
	return saves

# Verificar si existe un guardado con ese nombre
func save_exists(save_name: String) -> bool:
	return FileAccess.file_exists(SAVE_DIR + save_name + SAVE_FILE_EXTENSION)

# Obtener un guardado rápido automático
func quick_save(board_data: Dictionary) -> bool:
	return save_game(board_data, "quicksave")

# Cargar un guardado rápido
func quick_load() -> Dictionary:
	if save_exists("quicksave"):
		return load_game("quicksave")
	else:
		emit_signal("load_error", "No existe un guardado rápido")
		return {}
