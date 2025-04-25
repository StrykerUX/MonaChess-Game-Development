extends Node

signal scene_loaded(scene_name)
signal scene_unloaded(scene_name)
signal transition_started(from_scene, to_scene)
signal transition_completed(from_scene, to_scene)

# Referencia a la escena actual
var current_scene = null
var current_scene_path = ""

# Variable para controlar si hay una transición en progreso
var is_transitioning = false

# Lista de escenas precargadas para acceso rápido
var preloaded_scenes = {}

# Función llamada cuando el nodo entra en el árbol de escena
func _ready():
	# Obtenemos la escena raíz actual
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	current_scene_path = current_scene.scene_file_path if current_scene.has_method("get_path") else "unknown"
	
	print("SceneLoader inicializado. Escena actual: ", current_scene_path)

# Cambia a una nueva escena
func goto_scene(path: String, transition: bool = false) -> void:
	# Verificamos que no estemos ya en una transición
	if is_transitioning:
		print("Error: Ya hay una transición en progreso")
		return
		
	print("Cambiando a escena: ", path)
	
	# Si la escena actual es la misma que la solicitada, no hacemos nada
	if path == current_scene_path:
		print("Ya estamos en esta escena")
		return
	
	# Obtenemos el nombre de la escena para las señales
	var scene_name = path.get_file().get_basename()
	var from_scene = current_scene_path.get_file().get_basename()
	
	if transition:
		is_transitioning = true
		emit_signal("transition_started", from_scene, scene_name)
		
		# En versiones futuras, aquí se implementará una animación de transición
		# Por ahora, simplemente hacemos una transición directa
		await get_tree().create_timer(0.1).timeout
	
	# Esta función cambiará la escena actual por una nueva
	# Llamamos a defer para asegurarnos de que se ejecuta cuando la escena esté lista
	call_deferred("_deferred_goto_scene", path, scene_name, from_scene, transition)

# Función para cambiar escena de forma diferida
func _deferred_goto_scene(path: String, scene_name: String, from_scene: String, with_transition: bool) -> void:
	# Emitimos señal de que la escena actual será descargada
	emit_signal("scene_unloaded", from_scene)
	
	# Liberamos la escena actual
	current_scene.free()
	
	# Cargamos la nueva escena
	var new_scene
	
	# Verificamos si la escena está precargada
	if path in preloaded_scenes:
		new_scene = preloaded_scenes[path]
	else:
		new_scene = load(path)
	
	# Instanciamos la nueva escena
	current_scene = new_scene.instantiate()
	current_scene_path = path
	
	# Añadimos la nueva escena al árbol
	get_tree().root.add_child(current_scene)
	
	# Hacemos que sea la escena activa
	get_tree().current_scene = current_scene
	
	# Emitimos señal de que la nueva escena ha sido cargada
	emit_signal("scene_loaded", scene_name)
	
	if with_transition:
		# Completamos la transición
		await get_tree().create_timer(0.1).timeout
		emit_signal("transition_completed", from_scene, scene_name)
		is_transitioning = false

# Precarga una escena para acceso rápido
func preload_scene(path: String) -> void:
	if path in preloaded_scenes:
		print("La escena ya está precargada: ", path)
		return
		
	print("Precargando escena: ", path)
	preloaded_scenes[path] = load(path)

# Libera una escena precargada
func unload_preloaded_scene(path: String) -> void:
	if path in preloaded_scenes:
		print("Liberando escena precargada: ", path)
		preloaded_scenes.erase(path)
	else:
		print("La escena no está precargada: ", path)

# Reinicia la escena actual
func reload_current_scene() -> void:
	goto_scene(current_scene_path)

# Obtiene el nombre de la escena actual
func get_current_scene_name() -> String:
	return current_scene_path.get_file().get_basename()
