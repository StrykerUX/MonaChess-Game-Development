extends Control
class_name PauseMenu

# Menú de pausa mejorado para MonaChess
# Versión 0.8.0

# Señales
signal resume_game
signal restart_game
signal exit_to_menu
signal open_settings
signal save_game
signal load_game

# Nodos
@onready var resume_button = $Container/ResumeButton
@onready var restart_button = $Container/RestartButton
@onready var settings_button = $Container/SettingsButton
@onready var save_button = $Container/SaveButton
@onready var load_button = $Container/LoadButton
@onready var exit_button = $Container/ExitButton
@onready var blur_effect = $BlurBackground

# Inicialización
func _ready():
	# Conectar botones a funciones
	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	
	if save_button:
		save_button.pressed.connect(_on_save_pressed)
	
	if load_button:
		load_button.pressed.connect(_on_load_pressed)
	
	if exit_button:
		exit_button.pressed.connect(_on_exit_pressed)
	
	# Inicialmente oculto
	visible = false
	
	# Configurar la animación de botones
	for button in [resume_button, restart_button, settings_button, save_button, load_button, exit_button]:
		if button:
			button.mouse_entered.connect(func(): _on_button_hover(button))
			button.mouse_exited.connect(func(): _on_button_exit(button))
			button.modulate.a = 0.9  # Transparencia inicial

# Mostrar el menú de pausa con animación
func show_pause_menu():
	# Mostrar el menú
	visible = true
	
	# Animar el efecto de blur si existe
	if blur_effect:
		var blur_material = blur_effect.material
		if blur_material:
			var tween = create_tween()
			blur_material.set_shader_parameter("blur_amount", 0.0)
			tween.tween_method(
				func(value): blur_material.set_shader_parameter("blur_amount", value),
				0.0, 2.0, 0.3
			)
	
	# Animar la aparición de los botones
	var buttons = [resume_button, restart_button, settings_button, save_button, load_button, exit_button]
	for i in range(len(buttons)):
		var button = buttons[i]
		if button:
			button.modulate.a = 0
			var initial_y = button.position.y
			button.position.y += 20
			
			var button_tween = create_tween()
			button_tween.tween_property(button, "modulate:a", 0.9, 0.2).set_delay(i * 0.05)
			button_tween.parallel().tween_property(button, "position:y", initial_y, 0.2).set_delay(i * 0.05)
	
	# Dar foco al botón de reanudar
	if resume_button:
		resume_button.grab_focus()

# Ocultar el menú de pausa con animación
func hide_pause_menu():
	# Animar la desaparición del blur
	if blur_effect:
		var blur_material = blur_effect.material
		if blur_material:
			var tween = create_tween()
			tween.tween_method(
				func(value): blur_material.set_shader_parameter("blur_amount", value),
				2.0, 0.0, 0.3
			)
	
	# Animar la desaparición de los botones
	var buttons = [resume_button, restart_button, settings_button, save_button, load_button, exit_button]
	for i in range(len(buttons)):
		var button = buttons[len(buttons) - 1 - i]  # Orden inverso para efecto cascada
		if button:
			var button_tween = create_tween()
			button_tween.tween_property(button, "modulate:a", 0.0, 0.2).set_delay(i * 0.05)
			button_tween.parallel().tween_property(button, "position:y", button.position.y + 20, 0.2).set_delay(i * 0.05)
	
	# Esperar a la animación más larga y ocultar el menú
	await get_tree().create_timer(0.5).timeout
	visible = false

# Efecto al pasar el mouse sobre un botón
func _on_button_hover(button):
	var tween = create_tween()
	tween.tween_property(button, "modulate:a", 1.0, 0.1)
	tween.parallel().tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)

# Efecto al salir el mouse de un botón
func _on_button_exit(button):
	var tween = create_tween()
	tween.tween_property(button, "modulate:a", 0.9, 0.1)
	tween.parallel().tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

# Función para reanudar el juego
func _on_resume_pressed():
	hide_pause_menu()
	emit_signal("resume_game")

# Función para reiniciar el juego
func _on_restart_pressed():
	hide_pause_menu()
	emit_signal("restart_game")

# Función para abrir los ajustes
func _on_settings_pressed():
	emit_signal("open_settings")

# Función para guardar la partida
func _on_save_pressed():
	emit_signal("save_game")

# Función para cargar la partida
func _on_load_pressed():
	emit_signal("load_game")

# Función para volver al menú principal
func _on_exit_pressed():
	hide_pause_menu()
	emit_signal("exit_to_menu")
