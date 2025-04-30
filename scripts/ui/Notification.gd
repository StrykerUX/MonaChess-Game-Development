extends Control
class_name Notification

# Sistema de notificaciones mejorado para MonaChess
# Versión 0.8.0

# Tipos de notificación
enum NotificationType {
	INFO,
	SUCCESS,
	WARNING,
	ERROR
}

# Propiedades
@export var auto_hide = true
@export var display_time = 3.0

# Nodos de la UI
@onready var label = $Container/Label
@onready var icon = $Container/Icon
@onready var background = $Background
@onready var container = $Container

# Colores para los diferentes tipos
const COLORS = {
	NotificationType.INFO: Color(0.2, 0.4, 0.8, 0.9),
	NotificationType.SUCCESS: Color(0.2, 0.7, 0.3, 0.9),
	NotificationType.WARNING: Color(0.9, 0.6, 0.1, 0.9),
	NotificationType.ERROR: Color(0.8, 0.2, 0.2, 0.9)
}

# Función ready
func _ready():
	# Inicialmente oculto
	visible = false
	
	# Verificar que tenemos todos los nodos necesarios
	if not label or not background or not container:
		push_error("Notification: Faltan nodos necesarios en la escena")

# Función para mostrar una notificación
func show_notification(message: String, type: int = NotificationType.INFO) -> void:
	# Configura el mensaje
	if label:
		label.text = message
	
	# Configura el color según el tipo
	if background:
		var color = COLORS[type] if COLORS.has(type) else COLORS[NotificationType.INFO]
		background.color = color
	
	# Configura el ícono si existe
	if icon:
		# Aquí podríamos cargar íconos diferentes según el tipo
		# Para esta versión, solo ajustamos visibilidad y color
		icon.visible = true
		
		# Color del ícono según el tipo (ícono más claro que el fondo)
		var icon_color = Color.WHITE
		if type == NotificationType.WARNING:
			icon_color = Color(1.0, 0.9, 0.3)
		elif type == NotificationType.ERROR:
			icon_color = Color(1.0, 0.5, 0.5)
		elif type == NotificationType.SUCCESS:
			icon_color = Color(0.5, 1.0, 0.5)
		
		icon.modulate = icon_color
	
	# Muestra la notificación con una animación
	modulate.a = 0
	visible = true
	
	# Animación de entrada con rebote
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(container, "scale", Vector2(1.05, 1.05), 0.2)
	tween.tween_property(container, "scale", Vector2(1.0, 1.0), 0.1)
	
	# Ocultar automáticamente después de un tiempo si está configurado
	if auto_hide:
		var hide_timer = get_tree().create_timer(display_time)
		await hide_timer.timeout
		hide_notification()

# Función para ocultar la notificación
func hide_notification() -> void:
	# Animación de salida
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(container, "position:y", container.position.y - 10, 0.3)
	tween.tween_callback(func(): visible = false)
	tween.tween_callback(func(): container.position.y += 10)

# Mostrar notificación de tipo información
func show_info(message: String) -> void:
	show_notification(message, NotificationType.INFO)

# Mostrar notificación de tipo éxito
func show_success(message: String) -> void:
	show_notification(message, NotificationType.SUCCESS)

# Mostrar notificación de tipo advertencia
func show_warning(message: String) -> void:
	show_notification(message, NotificationType.WARNING)

# Mostrar notificación de tipo error
func show_error(message: String) -> void:
	show_notification(message, NotificationType.ERROR)
