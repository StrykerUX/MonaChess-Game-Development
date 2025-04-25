# Versión 0.0.0 - Estructura Base

Esta versión corresponde a la configuración inicial del proyecto y la estructura base necesaria para comenzar el desarrollo del juego "Ajedrez de Monas Chinas".

## Objetivos de la Versión 0.0.0

- Configurar el proyecto Godot con los parámetros correctos
- Crear la estructura de directorios necesaria
- Establecer la escena principal vacía
- Implementar el sistema básico de gestión de escenas
- Configurar archivos de proyecto iniciales

## Estructura de Directorios

```
MonaChess/
├── assets/            # Recursos gráficos y audiovisuales (vacío inicialmente)
├── scenes/            # Escenas del juego
│   ├── Main.tscn      # Escena principal vacía
│   └── MainMenu.tscn  # Escena del menú principal vacía
├── scripts/           # Scripts independientes
│   ├── global/        # Scripts globales
│   │   └── GameManager.gd   # Gestor del juego (singleton/autoload)
│   └── utils/         # Utilidades
│       └── SceneLoader.gd   # Sistema de carga de escenas
├── resources/         # Recursos reutilizables (vacío inicialmente)
├── docs/              # Documentación del proyecto
│   └── VERSION_0.0.0.md     # Este documento
└── project.godot      # Archivo principal del proyecto
```

## Configuración del Proyecto

### Ajustes Iniciales

- **Nombre del Proyecto**: MonaChess
- **Resolución por defecto**: 1280x720
- **Modo de ventana inicial**: Ventana redimensionable
- **Orientación**: Landscape
- **Versión de Godot**: 4.2.x o superior

### Autoloads (Singletons)

- **GameManager**: Controla el estado global del juego
  - Ubicación: `res://scripts/global/GameManager.gd`
  - Función: Singleton para mantener el estado del juego entre escenas

### Estructura de Escenas

- **Main.tscn**: Escena principal que contiene:
  - Un nodo de tipo `Node` como raíz
  - Un comentario que indique "Escena principal - Versión 0.0.0"

- **MainMenu.tscn**: Escena del menú principal (vacía por ahora)
  - Un nodo de tipo `Control` como raíz
  - Un comentario que indique "Menú Principal - Versión 0.0.0"

## Scripts Básicos

### GameManager.gd

Este script actuará como singleton para gestionar el estado global del juego.

```gdscript
extends Node

# Versión actual del juego
const VERSION = "0.0.0"

# Enumeración para los estados del juego
enum GameState {
	MAIN_MENU,
	GAME,
	PAUSED,
	GAME_OVER
}

# Estado actual del juego
var current_state: int = GameState.MAIN_MENU

# Modo de juego seleccionado
enum GameMode {
	STORY,
	QUICK_PLAY,
	LOCAL_MULTIPLAYER,
	TUTORIAL
}

var selected_game_mode: int = GameMode.QUICK_PLAY

# Función llamada cuando el nodo entra en el árbol de escena
func _ready():
	print("GameManager inicializado - Versión: ", VERSION)

# Cambia el estado del juego
func change_state(new_state: int) -> void:
	current_state = new_state
	print("Cambio de estado a: ", new_state)
```

### SceneLoader.gd

Este script facilitará la carga y transición entre escenas.

```gdscript
extends Node

# Referencia a la escena actual
var current_scene = null

# Función llamada cuando el nodo entra en el árbol de escena
func _ready():
	# Obtenemos la escena raíz actual
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# Cambia a una nueva escena
func goto_scene(path: String) -> void:
	# Esta función cambiará la escena actual por una nueva
	
	# Llamamos a defer para asegurarnos de que se ejecuta cuando la escena esté lista
	call_deferred("_deferred_goto_scene", path)

# Función para cambiar escena de forma diferida
func _deferred_goto_scene(path: String) -> void:
	# Liberamos la escena actual
	current_scene.free()
	
	# Cargamos la nueva escena
	var new_scene = load(path)
	
	# Instanciamos la nueva escena
	current_scene = new_scene.instantiate()
	
	# Añadimos la nueva escena al árbol
	get_tree().root.add_child(current_scene)
	
	# Opcional: hacemos que sea la escena activa
	get_tree().current_scene = current_scene
```

## Preparación para Futuras Versiones

Aunque esta versión solo contiene la estructura base, se han planificado directorios y archivos que serán necesarios para las características futuras:

### Sistema de Ajedrez (Versiones 0.1.0 - 1.0.0)
- `scripts/chess/` albergará la lógica del juego de ajedrez
- `scenes/board/` contendrá las escenas del tablero y piezas

### Interfaz de Usuario (Versiones 0.7.0+)
- `scenes/ui/` para componentes de interfaz reutilizables
- `resources/themes/` para temas de UI

### Sistema de IA (Versiones 1.2.0+)
- `scripts/ai/` para los algoritmos de IA

### Temas Visuales (Versiones 1.9.0+)
- `assets/themes/` para estilos visuales del juego
- `assets/pieces/themes/` para skins de piezas por tema

### Multijugador (Versiones 2.1.0+)
- `scripts/multiplayer/` para la lógica de multijugador

## Instrucciones para Desarrolladores

Para trabajar con esta versión inicial:

1. **Clonar el repositorio**:
   ```
   git clone https://github.com/StrykerUX/MonaChess-Game-Development.git
   ```

2. **Abrir el proyecto**:
   - Ejecutar Godot Engine 4.2+
   - Seleccionar "Importar" y navegar hasta la carpeta del proyecto
   - Abrir el proyecto

3. **Verificar la estructura**:
   - Comprobar que todos los directorios existen y están vacíos (excepto los que contienen archivos iniciales)
   - Verificar que los scripts básicos GameManager.gd y SceneLoader.gd estén en su lugar

## Siguientes Pasos

Una vez completada la Versión 0.0.0, se procederá con la implementación de la Versión 0.1.0, que incluirá:

- Implementación del tablero como matriz de datos 8x8
- Representación visual básica del tablero (cuadrícula)
- Sistema de coordenadas (A1-H8)
- Lógica para posicionar elementos en el tablero
