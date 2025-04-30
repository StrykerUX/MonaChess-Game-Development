extends Node
# ObjectPoolManager.gd
# Sistema de pools de objetos para optimizar rendimiento
# Versión 0.8.0

# Diccionario que contiene pools por tipo de objeto
var pools = {}

# Crea un pool de objetos con una escena específica
func create_pool(pool_name: String, scene: PackedScene, initial_size: int = 5):
	if pools.has(pool_name):
		print("ObjectPoolManager: ADVERTENCIA - Pool '%s' ya existe, sobrescribiendo" % pool_name)
	
	pools[pool_name] = []
	
	# Crear objetos iniciales
	for i in range(initial_size):
		var object = scene.instantiate()
		object.visible = false
		add_child(object)
		pools[pool_name].append(object)
	
	print("ObjectPoolManager: Creado pool '%s' con %d objetos" % [pool_name, initial_size])

# Obtiene un objeto del pool, creando uno nuevo si es necesario
func get_object(pool_name: String, scene: PackedScene = null) -> Node:
	if not pools.has(pool_name):
		if scene == null:
			push_error("ObjectPoolManager: Pool '%s' no existe y no se proporcionó escena para crearlo" % pool_name)
			return null
		else:
			create_pool(pool_name, scene, 1)
	
	# Buscar un objeto disponible en el pool
	for object in pools[pool_name]:
		if not object.visible:
			object.visible = true
			return object
	
	# Si no hay objetos disponibles, crear uno nuevo
	if scene != null:
		var new_object = scene.instantiate()
		new_object.visible = true
		add_child(new_object)
		pools[pool_name].append(new_object)
		print("ObjectPoolManager: ADVERTENCIA - Pool '%s' expandido automáticamente" % pool_name)
		return new_object
	else:
		push_error("ObjectPoolManager: No hay objetos disponibles en el pool '%s' y no se proporcionó escena" % pool_name)
		return null

# Retorna un objeto al pool (lo marca como disponible)
func return_object(pool_name: String, object: Node):
	if not pools.has(pool_name):
		push_error("ObjectPoolManager: Pool '%s' no existe" % pool_name)
		return
	
	if not pools[pool_name].has(object):
		push_error("ObjectPoolManager: El objeto no es parte del pool '%s'" % pool_name)
		return
	
	# Restablecer objeto al estado inicial
	object.visible = false
	
	# Opcional: restablecer posición y rotación si es relevante
	if object is Node2D:
		object.position = Vector2.ZERO
		object.rotation = 0
		object.scale = Vector2.ONE
		object.modulate = Color.WHITE

# Verifica si existe un pool con ese nombre
func has_pool(pool_name: String) -> bool:
	return pools.has(pool_name)

# Obtiene la cantidad de objetos en un pool
func get_pool_size(pool_name: String) -> int:
	if not pools.has(pool_name):
		return 0
	return pools[pool_name].size()

# Limpia un pool específico
func clear_pool(pool_name: String):
	if not pools.has(pool_name):
		push_error("ObjectPoolManager: Pool '%s' no existe" % pool_name)
		return
	
	for object in pools[pool_name]:
		object.queue_free()
	
	pools[pool_name].clear()
	pools.erase(pool_name)
	print("ObjectPoolManager: Pool '%s' eliminado" % pool_name)

# Limpia todos los pools
func clear_all_pools():
	for pool_name in pools.keys():
		for object in pools[pool_name]:
			object.queue_free()
		pools[pool_name].clear()
	
	pools.clear()
	print("ObjectPoolManager: Todos los pools han sido eliminados")
