extends Node
# Settings Manager para MonaChess
# Versión 0.7.0
# Gestión centralizada de ajustes y configuraciones del juego

# Ruta del archivo de configuración
const SETTINGS_FILE_PATH = "user://settings.cfg"

# Configuración por defecto
var default_settings = {
	"video": {
		"fullscreen": false,
		"resolution": Vector2(1280, 720),
		"vsync": true,
		"show_fps": false
	},
	"audio": {
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 0.9,
		"mute": false
	},
	"gameplay": {
		"show_legal_moves": true,
		"show_last_move": true,
		"show_check_indicator": true,
		"auto_queen_promotion": true,
		"animation_speed": 1.0
	},
	"accessibility": {
		"high_contrast": false,
		"large_ui": false,
		"text_size": 1.0,
		"screen_reader": false
	},
	"controls": {
		"drag_and_drop": true,
		"click_to_select": true,
		"keyboard_navigation": false
	},
	"language": "es_MX"  # Español de México por defecto
}

# Configuración actual
var current_settings = {}

# Señales
signal settings_changed(section, key, value)
signal settings_loaded()
signal settings_saved()

# Función que se ejecuta al iniciar
func _ready():
	# Cargar la configuración
	load_settings()
	
	# Aplicar la configuración inicial
	apply_all_settings()
	
	print("Settings Manager inicializado en la versión 0.7.0")

# Carga la configuración desde el archivo
func load_settings():
	# Inicializar con valores por defecto
	current_settings = default_settings.duplicate(true)
	
	# Intentar cargar desde el archivo
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE_PATH)
	
	if err == OK:
		# Cargar cada sección desde el archivo
		for section in config.get_sections():
			if !current_settings.has(section):
				current_settings[section] = {}
				
			for key in config.get_section_keys(section):
				current_settings[section][key] = config.get_value(section, key)
	
	emit_signal("settings_loaded")

# Guarda la configuración en el archivo
func save_settings():
	var config = ConfigFile.new()
	
	# Guardar cada sección en el archivo
	for section in current_settings.keys():
		for key in current_settings[section].keys():
			config.set_value(section, key, current_settings[section][key])
	
	# Guardar en el archivo
	config.save(SETTINGS_FILE_PATH)
	
	emit_signal("settings_saved")

# Obtiene un valor de configuración
func get_setting(section: String, key: String, default = null):
	if current_settings.has(section) and current_settings[section].has(key):
		return current_settings[section][key]
	return default

# Establece un valor de configuración
func set_setting(section: String, key: String, value):
	if !current_settings.has(section):
		current_settings[section] = {}
	
	# Actualizar el valor
	current_settings[section][key] = value
	
	# Aplicar el cambio inmediatamente
	_apply_setting(section, key, value)
	
	# Guardar la configuración
	save_settings()
	
	emit_signal("settings_changed", section, key, value)

# Restablece la configuración a los valores por defecto
func reset_to_defaults():
	current_settings = default_settings.duplicate(true)
	
	# Aplicar la configuración
	apply_all_settings()
	
	# Guardar la configuración
	save_settings()
	
	emit_signal("settings_changed", "all", "reset", null)

# Aplica todas las configuraciones
func apply_all_settings():
	# Video
	_apply_setting("video", "fullscreen", current_settings.video.fullscreen)
	_apply_setting("video", "resolution", current_settings.video.resolution)
	_apply_setting("video", "vsync", current_settings.video.vsync)
	
	# Audio
	_apply_setting("audio", "master_volume", current_settings.audio.master_volume)
	_apply_setting("audio", "music_volume", current_settings.audio.music_volume)
	_apply_setting("audio", "sfx_volume", current_settings.audio.sfx_volume)
	_apply_setting("audio", "mute", current_settings.audio.mute)
	
	# Otros ajustes...
	# Aquí irían aplicaciones específicas para cada sección

# Aplica un ajuste específico
func _apply_setting(section: String, key: String, value):
	match section:
		"video":
			_apply_video_setting(key, value)
		"audio":
			_apply_audio_setting(key, value)
		"gameplay":
			_apply_gameplay_setting(key, value)
		"accessibility":
			_apply_accessibility_setting(key, value)
		"controls":
			_apply_controls_setting(key, value)
		"language":
			_apply_language_setting(value)

# Aplica una configuración de video
func _apply_video_setting(key: String, value):
	match key:
		"fullscreen":
			if value:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		"resolution":
			if !current_settings.video.fullscreen:
				DisplayServer.window_set_size(Vector2i(value.x, value.y))
		"vsync":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if value else DisplayServer.VSYNC_DISABLED)

# Aplica una configuración de audio
func _apply_audio_setting(key: String, value):
	match key:
		"master_volume":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 
				linear_to_db(value))
		"music_volume":
			# Suponiendo que existe un bus de audio llamado "Music"
			var bus_idx = AudioServer.get_bus_index("Music")
			if bus_idx >= 0:
				AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
		"sfx_volume":
			# Suponiendo que existe un bus de audio llamado "SFX"
			var bus_idx = AudioServer.get_bus_index("SFX")
			if bus_idx >= 0:
				AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
		"mute":
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value)

# Aplica una configuración de gameplay
func _apply_gameplay_setting(key: String, value):
	# Aquí iría la lógica para aplicar ajustes de gameplay
	# Pueden ser flags o valores que se consulten desde otros scripts
	pass

# Aplica una configuración de accesibilidad
func _apply_accessibility_setting(key: String, value):
	# Aquí iría la lógica para aplicar ajustes de accesibilidad
	# Por ejemplo, cambiar tamaños de fuente, contraste, etc.
	pass

# Aplica una configuración de controles
func _apply_controls_setting(key: String, value):
	# Aquí iría la lógica para aplicar ajustes de controles
	pass

# Aplica una configuración de idioma
func _apply_language_setting(value: String):
	TranslationServer.set_locale(value)
