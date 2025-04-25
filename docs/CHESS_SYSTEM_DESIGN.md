# Diseño del Sistema de Ajedrez - MonaChess

Este documento describe la arquitectura y diseño del sistema de ajedrez que se implementará a partir de la versión 0.1.0 en adelante. Aunque no forma parte de la versión 0.0.0, es importante tener una visión clara de cómo se estructurará este componente clave del juego.

## Arquitectura General

El sistema de ajedrez de MonaChess seguirá un patrón de arquitectura basado en datos, con una clara separación entre:

1. **Modelo de datos**: Representación lógica del tablero y las piezas
2. **Presentación visual**: Nodos y sprites que renderizan el estado del juego
3. **Controlador**: Lógica que maneja las reglas del juego y procesa las entradas del usuario

## Estructura de Datos

### Tablero

El tablero se representará como una matriz 2D de 8x8:

```gdscript
# Representación del tablero
var board = []  # Matriz de 8x8

# Constantes
const BOARD_SIZE = 8
const EMPTY = 0

# Inicialización del tablero vacío
func initialize_board():
    board = []
    for i in range(BOARD_SIZE):
        var row = []
        for j in range(BOARD_SIZE):
            row.append(EMPTY)
        board.append(row)
```

### Piezas

Cada tipo de pieza heredará de una clase base `ChessPiece`:

```gdscript
class_name ChessPiece
extends RefCounted

enum Type {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
enum Color {WHITE, BLACK}

var type: int
var color: int
var has_moved: bool = false

func _init(piece_type: int, piece_color: int):
    type = piece_type
    color = piece_color

# Método abstracto que cada subclase debe implementar
func get_valid_moves(board, position: Vector2i) -> Array:
    return []

# Método para verificar si un movimiento es válido
func is_valid_move(board, from: Vector2i, to: Vector2i) -> bool:
    var valid_moves = get_valid_moves(board, from)
    return to in valid_moves
```

## Sistema de Coordenadas

Se utilizará un sistema de coordenadas estándar de ajedrez:

- Filas: 1-8 (de abajo hacia arriba)
- Columnas: A-H (de izquierda a derecha)

Internamente, utilizaremos índices de 0-7 para filas y columnas:

```gdscript
# Convertir notación algebraica a coordenadas internas
func algebraic_to_coords(notation: String) -> Vector2i:
    var col = notation[0].unicode_at(0) - "a".unicode_at(0)
    var row = int(notation[1]) - 1
    return Vector2i(col, row)

# Convertir coordenadas internas a notación algebraica
func coords_to_algebraic(coords: Vector2i) -> String:
    var col = char("a".unicode_at(0) + coords.x)
    var row = str(coords.y + 1)
    return col + row
```

## Validación de Movimientos

La validación de movimientos se hará en dos niveles:

1. **Validación específica de pieza**: Cada tipo de pieza implementará su propio método `get_valid_moves()`
2. **Validación global**: Verificación adicional de reglas como jaque, jaque mate, etc.

### Ejemplo: Validación para el Alfil

```gdscript
class Bishop extends ChessPiece:
    func _init(piece_color: int):
        super._init(Type.BISHOP, piece_color)
    
    func get_valid_moves(board, position: Vector2i) -> Array:
        var valid_moves = []
        var directions = [
            Vector2i(1, 1), Vector2i(1, -1), 
            Vector2i(-1, 1), Vector2i(-1, -1)
        ]
        
        for direction in directions:
            var current = position + direction
            while is_inside_board(current) and board[current.y][current.x] == EMPTY:
                valid_moves.append(current)
                current += direction
            
            if is_inside_board(current) and is_enemy_piece(board, current, color):
                valid_moves.append(current)
        
        return valid_moves
```

## Reglas Especiales

Las reglas especiales del ajedrez se implementarán como métodos independientes:

### Enroque

```gdscript
func can_castle_kingside(board, color: int) -> bool:
    # Verificar que el rey y la torre no se hayan movido
    # Verificar que no hay piezas entre el rey y la torre
    # Verificar que el rey no está en jaque
    # Verificar que el rey no pasa por casillas atacadas
    pass

func castle_kingside(board, color: int) -> void:
    # Mover el rey y la torre a sus posiciones correspondientes
    pass

# Similar para el enroque largo
```

### Captura al Paso

```gdscript
func can_en_passant(board, from: Vector2i, to: Vector2i, last_move) -> bool:
    # Verificar si es un peón
    # Verificar si el último movimiento fue un peón avanzando dos casillas
    # Verificar si el movimiento actual es una captura diagonal a la posición adecuada
    pass

func perform_en_passant(board, from: Vector2i, to: Vector2i) -> void:
    # Mover el peón y capturar el peón enemigo
    pass
```

### Promoción de Peón

```gdscript
func can_promote_pawn(board, position: Vector2i) -> bool:
    # Verificar si es un peón en la última fila
    pass

func promote_pawn(board, position: Vector2i, new_piece_type: int) -> void:
    # Reemplazar el peón por la pieza elegida
    pass
```

## Detección de Condiciones Especiales

### Jaque

```gdscript
func is_in_check(board, color: int) -> bool:
    # Encontrar la posición del rey
    # Verificar si alguna pieza enemiga puede capturar al rey
    pass
```

### Jaque Mate

```gdscript
func is_checkmate(board, color: int) -> bool:
    # Verificar si está en jaque
    # Verificar si hay algún movimiento que saque al rey del jaque
    pass
```

### Tablas

```gdscript
func is_stalemate(board, color: int) -> bool:
    # Verificar si no está en jaque
    # Verificar si no hay movimientos válidos
    pass

func is_insufficient_material(board) -> bool:
    # Verificar si hay material insuficiente para dar jaque mate
    pass

func is_threefold_repetition(position_history) -> bool:
    # Verificar si una posición se ha repetido tres veces
    pass

func is_fifty_move_rule(move_history) -> bool:
    # Verificar si han pasado 50 movimientos sin capturas ni movimientos de peón
    pass
```

## Interfaz de Usuario para el Tablero

La interfaz de usuario del tablero se implementará utilizando una combinación de:

1. **Control grid**: Para el tablero en sí
2. **Texturas y Sprites**: Para las piezas y efectos visuales
3. **Áreas2D**: Para la detección de interacción con el ratón

```gdscript
# En un script asociado a la escena del tablero
extends Control

# Referencias a los nodos
@onready var grid = $Grid
@onready var pieces_container = $PiecesContainer

# Tamaño de casilla
var cell_size = Vector2(64, 64)

# Cargar piezas
func load_pieces(board_data):
    # Limpiar contenedor
    for child in pieces_container.get_children():
        child.queue_free()
    
    # Crear piezas según board_data
    for row in range(8):
        for col in range(8):
            var piece_data = board_data[row][col]
            if piece_data != EMPTY:
                var piece_sprite = create_piece_sprite(piece_data.type, piece_data.color)
                piece_sprite.position = Vector2(col, row) * cell_size
                pieces_container.add_child(piece_sprite)

# Manejar selección de pieza
func _on_cell_clicked(cell_coords):
    # Lógica para seleccionar pieza o mover a destino
    pass
```

## Efectos Visuales

Los efectos visuales se implementarán utilizando:

1. **AnimationPlayer**: Para animaciones básicas como movimiento de piezas
2. **Particles2D**: Para efectos tipo partículas en capturas
3. **CanvasLayer**: Para overlays de "kill" o jaque mate

```gdscript
# Ejemplo de animación de movimiento
func animate_move(piece_sprite, from_pos, to_pos):
    var tween = create_tween()
    tween.tween_property(piece_sprite, "position", to_pos, 0.3).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

# Ejemplo de efecto de captura
func play_capture_effect(position):
    var effect = capture_effect_scene.instantiate()
    effect.position = position
    effects_container.add_child(effect)
    effect.emitting = true
    await get_tree().create_timer(1.5).timeout
    effect.queue_free()
```

## Inteligencia Artificial

La IA se implementará usando algoritmos como Minimax con poda alfa-beta:

```gdscript
# Ejemplo simplificado de algoritmo Minimax
func minimax(board, depth, is_maximizing, alpha, beta):
    if depth == 0 or is_game_over(board):
        return evaluate_board(board)
    
    if is_maximizing:
        var max_eval = -INF
        for move in get_all_possible_moves(board, WHITE):
            var new_board = make_move(board, move)
            var eval = minimax(new_board, depth - 1, false, alpha, beta)
            max_eval = max(max_eval, eval)
            alpha = max(alpha, eval)
            if beta <= alpha:
                break
        return max_eval
    else:
        var min_eval = INF
        for move in get_all_possible_moves(board, BLACK):
            var new_board = make_move(board, move)
            var eval = minimax(new_board, depth - 1, true, alpha, beta)
            min_eval = min(min_eval, eval)
            beta = min(beta, eval)
            if beta <= alpha:
                break
        return min_eval
```

## Planificación de Implementación

La implementación del sistema de ajedrez se hará de forma incremental:

1. **Versión 0.1.0**: Tablero básico y representación de datos
2. **Versión 0.2.0**: Piezas básicas y visualización
3. **Versión 0.3.0**: Movimientos básicos y validación
4. **Versión 0.4.0**: Sistema de turnos
5. **Versión 0.5.0**: Capturas
6. **Versión 0.6.0**: Reglas básicas (jaque, jaque mate)
7. **Versión 1.0.0**: Reglas avanzadas (enroque, captura al paso, promoción)
8. **Versiones posteriores**: IA, efectos visuales mejorados, etc.

## Conclusión

Este diseño proporciona una base sólida para implementar el sistema de ajedrez en MonaChess, permitiendo una estructura modular y extensible que facilitará la adición de características en versiones futuras. La separación clara entre la lógica del juego y la presentación visual permitirá que el sistema sea flexible para adaptarse a los diferentes temas visuales planificados.