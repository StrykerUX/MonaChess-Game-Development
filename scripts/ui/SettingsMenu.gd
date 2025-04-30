extends Control
# Script para el Menú de Ajustes de MonaChess
# Versión 0.7.0

# Referencias a nodos de pestañas
@onready var tabs = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs
@onready var video_tab = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/VideoTab
@onready var audio_tab = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AudioTab
@onready var gameplay_tab = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/GameplayTab
@onready var accessibility_tab = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AccessibilityTab

# Referencias a controles específicos
# Video
@onready var fullscreen_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/VideoTab/VBoxContainer/FullscreenContainer/FullscreenCheckBox
@onready var resolution_option = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/VideoTab/VBoxContainer/ResolutionContainer/ResolutionOption
@onready var vsync_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/VideoTab/VBoxContainer/VsyncContainer/VsyncCheckBox

# Audio
@onready var master_volume_slider = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AudioTab/VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var music_volume_slider = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AudioTab/VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AudioTab/VBoxContainer/SfxVolumeContainer/SfxVolumeSlider
@onready var mute_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AudioTab/VBoxContainer/MuteContainer/MuteCheckBox

# Gameplay
@onready var show_legal_moves_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/GameplayTab/VBoxContainer/ShowLegalMovesContainer/ShowLegalMovesCheckBox
@onready var show_last_move_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/GameplayTab/VBoxContainer/ShowLastMoveContainer/ShowLastMoveCheckBox
@onready var show_check_indicator_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/GameplayTab/VBoxContainer/ShowCheckIndicatorContainer/ShowCheckIndicatorCheckBox
@onready var auto_queen_promotion_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/GameplayTab/VBoxContainer/AutoQueenPromotionContainer/AutoQueenPromotionCheckBox
@onready var animation_speed_slider = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/GameplayTab/VBoxContainer/AnimationSpeedContainer/AnimationSpeedSlider

# Accessibility
@onready var high_contrast_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AccessibilityTab/VBoxContainer/HighContrastContainer/HighContrastCheckBox
@onready var large_ui_checkbox = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AccessibilityTab/VBoxContainer/LargeUIContainer/LargeUICheckBox
@onready var text_size_slider = $PanelContainer/MarginContainer/VBoxContainer/SettingsTabs/AccessibilityTab/VBoxContainer/TextSizeContainer/TextSizeSlider

# Botones de acción
@onready var save_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/SaveButton
@onready var reset_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ResetButton
@onready var back_button = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/BackButton

# Variables
var previous_mode: int = UIManager.UIMode.MAIN_MENU
var resolutions = [
	Vector2(1280, 720),
	Vector2(1366, 768),
	Vector2(1600, 900),
	Vector2(1920, 1080),
	Vector2(2560, 1440)
]

# Función que se ejecuta al iniciar
func _ready():
	# Conectar señales de botones
	save_button.pressed.connect(_on_save_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	# Conectar señales de cambios
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	vsync_checkbox.toggled.connect(_on_vsync_toggled)
	
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	mute_checkbox.toggled.connect(_on_mute_toggled)
	
	show_legal_moves_checkbox.toggled.connect(_on_show_legal_moves_toggled)
	show_last_move_checkbox.toggled.connect(_on_show_last_move_toggled)
	show_check_indicator_checkbox.toggled.connect(_on_show_check_indicator_toggled)
	auto_queen_promotion_checkbox.toggled.connect(_on_auto_queen_promotion_toggled)
	animation_speed_slider.value_changed.connect(_on_animation_speed_changed)
	
	high_contrast_checkbox.toggled.connect(_on_high_contrast_toggled)
	large_ui_checkbox.toggled.connect(_on_large_ui_toggled)
	text_size_slider.value_changed.connect(_on_text_size_changed)
	
	# Inicializar opciones de resolución
	_setup_resolution_options()
	
	# Cargar configuración actual
	_load_current_settings()

# Carga la configuración actual a los controles
func _load_current_settings():
	# Video
	fullscreen_checkbox.button_pressed = SettingsManager.get_setting("video", "fullscreen", false)
	
	# Buscar el índice de la resolución actual
	var current_resolution = SettingsManager.get_setting("video", "resolution", Vector2(1280, 720))
	for i in range(resolutions.size()):
		if resolutions[i] == current_resolution:
			resolution_option.select(i)
			break
	
	vsync_checkbox.button_pressed = SettingsManager.get_setting("video", "vsync", true)
	
	# Audio
	master_volume_slider.value = SettingsManager.get_setting("audio", "master_volume", 1.0)
	music_volume_slider.value = SettingsManager.get_setting("audio", "music_volume", 0.8)
	sfx_volume_slider.value = SettingsManager.get_setting("audio", "sfx_volume", 0.9)
	mute_checkbox.button_pressed = SettingsManager.get_setting("audio", "mute", false)
	
	# Gameplay
	show_legal_moves_checkbox.button_pressed = SettingsManager.get_setting("gameplay", "show_legal_moves", true)
	show_last_move_checkbox.button_pressed = SettingsManager.get_setting("gameplay", "show_last_move", true)
	show_check_indicator_checkbox.button_pressed = SettingsManager.get_setting("gameplay", "show_check_indicator", true)
	auto_queen_promotion_checkbox.button_pressed = SettingsManager.get_setting("gameplay", "auto_queen_promotion", true)
	animation_speed_slider.value = SettingsManager.get_setting("gameplay", "animation_speed", 1.0)
	
	# Accessibility
	high_contrast_checkbox.button_pressed = SettingsManager.get_setting("accessibility", "high_contrast", false)
	large_ui_checkbox.button_pressed = SettingsManager.get_setting("accessibility", "large_ui", false)
	text_size_slider.value = SettingsManager.get_setting("accessibility", "text_size", 1.0)

# Configura las opciones de resolución
func _setup_resolution_options():
	resolution_option.clear()
	
	for res in resolutions:
		resolution_option.add_item("%dx%d" % [res.x, res.y])

# Manejador para el botón de guardar
func _on_save_button_pressed():
	# Las opciones ya se guardan automáticamente al cambiar
	
	# Mostrar notificación
	UIManager.show_notification("Configuración guardada", "success")
	
	# Volver a la pantalla anterior
	handle_back()

# Manejador para el botón de reiniciar
func _on_reset_button_pressed():
	# Resetear a valores predeterminados
	SettingsManager.reset_to_defaults()
	
	# Recargar la configuración en los controles
	_load_current_settings()
	
	# Mostrar notificación
	UIManager.show_notification("Configuración restablecida", "info")

# Manejador para el botón de volver
func _on_back_button_pressed():
	handle_back()

# Función para volver a la pantalla anterior
func handle_back():
	match previous_mode:
		UIManager.UIMode.MAIN_MENU:
			UIManager.show_main_menu()
		UIManager.UIMode.PAUSE_MENU:
			UIManager.show_pause_menu()
		_:
			UIManager.show_main_menu()

# Manejadores para cambios en la configuración de Video
func _on_fullscreen_toggled(button_pressed):
	SettingsManager.set_setting("video", "fullscreen", button_pressed)

func _on_resolution_selected(index):
	SettingsManager.set_setting("video", "resolution", resolutions[index])

func _on_vsync_toggled(button_pressed):
	SettingsManager.set_setting("video", "vsync", button_pressed)

# Manejadores para cambios en la configuración de Audio
func _on_master_volume_changed(value):
	SettingsManager.set_setting("audio", "master_volume", value)

func _on_music_volume_changed(value):
	SettingsManager.set_setting("audio", "music_volume", value)

func _on_sfx_volume_changed(value):
	SettingsManager.set_setting("audio", "sfx_volume", value)

func _on_mute_toggled(button_pressed):
	SettingsManager.set_setting("audio", "mute", button_pressed)

# Manejadores para cambios en la configuración de Gameplay
func _on_show_legal_moves_toggled(button_pressed):
	SettingsManager.set_setting("gameplay", "show_legal_moves", button_pressed)

func _on_show_last_move_toggled(button_pressed):
	SettingsManager.set_setting("gameplay", "show_last_move", button_pressed)

func _on_show_check_indicator_toggled(button_pressed):
	SettingsManager.set_setting("gameplay", "show_check_indicator", button_pressed)

func _on_auto_queen_promotion_toggled(button_pressed):
	SettingsManager.set_setting("gameplay", "auto_queen_promotion", button_pressed)

func _on_animation_speed_changed(value):
	SettingsManager.set_setting("gameplay", "animation_speed", value)

# Manejadores para cambios en la configuración de Accessibility
func _on_high_contrast_toggled(button_pressed):
	SettingsManager.set_setting("accessibility", "high_contrast", button_pressed)

func _on_large_ui_toggled(button_pressed):
	SettingsManager.set_setting("accessibility", "large_ui", button_pressed)

func _on_text_size_changed(value):
	SettingsManager.set_setting("accessibility", "text_size", value)
