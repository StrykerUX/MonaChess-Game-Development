# Diseño Visual - MonaChess

Este documento detalla el enfoque estético y de diseño visual para MonaChess, un juego de ajedrez con estética anime. Aunque no se implementa en la versión 0.0.0, este documento sirve como guía para el desarrollo visual futuro.

## Estilo Visual General

MonaChess presenta un estilo visual basado en anime japonés con influencias de varios géneros:

- **Anime contemporáneo**: Líneas limpias, colores vibrantes
- **Shōnen/Shōjo**: Expresividad y dinamismo en animaciones
- **Battle anime**: Para efectos visuales de combate durante capturas

## Temas Visuales

El juego contará con cuatro temas principales que afectarán tanto a la apariencia del tablero como a las piezas:

### 1. Medieval (Tema por defecto)

- **Paleta de colores**: Rojos oscuros, dorados, azules reales
- **Estilo**: Fantasía medieval con armaduras ornamentadas
- **Efectos**: Destellos metálicos, auras doradas
- **Ambiente**: Castillo europeo medieval

### 2. Samurai

- **Paleta de colores**: Negros, rojos intensos, blancos puros
- **Estilo**: Japón feudal, con armaduras samurai y kimonos
- **Efectos**: Rastros de tinta, pétalos de sakura
- **Ambiente**: Castillo japonés tradicional

### 3. Cyberpunk

- **Paleta de colores**: Neones (rosas, azules, verdes), negros profundos
- **Estilo**: Futurista con elementos de ciencia ficción y tecnología
- **Efectos**: Líneas de circuitos, glitches digitales
- **Ambiente**: Ciudad futurista de noche

### 4. Mexica Futurista

- **Paleta de colores**: Turquesas, naranjas, dorados
- **Estilo**: Fusión de iconografía mesoamericana con elementos futuristas
- **Efectos**: Símbolos aztecas, destellos solares
- **Ambiente**: Templo mesoamericano con elementos tecnológicos

## Diseño de Personajes/Piezas

Cada pieza del ajedrez será representada por un personaje en estilo anime:

### Rey
- **Concepto**: Líder noble con aura de autoridad
- **Características por tema**:
  - **Medieval**: Rey con corona y manto real
  - **Samurai**: Señor feudal (daimyō) con elaborado kabuto
  - **Cyberpunk**: CEO corporativo con implantes neurales
  - **Mexica**: Tlatoani con tocado de plumas y elementos futuristas

### Reina
- **Concepto**: Personaje poderoso y elegante
- **Características por tema**:
  - **Medieval**: Reina con vestido elaborado y cetro
  - **Samurai**: Onna-bugeisha (mujer samurai) con naginata
  - **Cyberpunk**: Hacker de élite con interfaces holográficas
  - **Mexica**: Sacerdotisa guerrera con elementos tecnológicos

### Alfil
- **Concepto**: Personaje místico con poderes especiales
- **Características por tema**:
  - **Medieval**: Mago/clérigo con túnica y bastón
  - **Samurai**: Monje budista/sintoísta
  - **Cyberpunk**: Netrunner con visor de realidad aumentada
  - **Mexica**: Chamán tecnológico con máscara ritual

### Caballo
- **Concepto**: Personaje ágil y no convencional
- **Características por tema**:
  - **Medieval**: Caballero montado con armadura
  - **Samurai**: Ninja/shinobi con equipo de infiltración
  - **Cyberpunk**: Corredor urbano con exoesqueleto
  - **Mexica**: Guerrero jaguar con armadura mecánica

### Torre
- **Concepto**: Personaje robusto y defensivo
- **Características por tema**:
  - **Medieval**: Guardia con escudo y armadura pesada
  - **Samurai**: Guerrero sumo o guardián con armadura pesada
  - **Cyberpunk**: Guardia de seguridad robótico
  - **Mexica**: Guerrero águila con armamento pesado

### Peón
- **Concepto**: Personaje común pero con potencial
- **Características por tema**:
  - **Medieval**: Soldado/campesino con armamento básico
  - **Samurai**: Ashigaru (soldado de infantería)
  - **Cyberpunk**: Ciudadano con mejoras básicas
  - **Mexica**: Guerrero novato con equipamiento ligero

## Expresiones y Poses

Cada pieza tendrá diversas expresiones y poses para diferentes momentos:

1. **Idle**: Postura neutral con pequeñas animaciones de respiración/movimiento
2. **Seleccionada**: Postura de alerta, con efecto de brillo/aura
3. **Ataque**: Postura agresiva para capturas
4. **Victoria**: Celebración tras capturar una pieza
5. **Derrota**: Expresión dramática al ser capturada
6. **Jaque**: Expresión de preocupación cuando el rey está amenazado
7. **Jaque mate**: Pose dramática de victoria/derrota final

## Efectos Visuales

### Efectos de Tablero
- **Selección de casilla**: Brillo suave en casillas válidas
- **Último movimiento**: Rastro sutil que muestra la última jugada
- **Jaque**: Efecto pulsante rojo alrededor del rey

### Efectos de Movimiento
- **Movimiento básico**: Estela breve siguiendo la pieza
- **Captura**: Explosión estilizada con onomatopeyas estilo manga
- **Enroque**: Efecto de velocidad y cambio de posición coordenado
- **Promoción**: Transformación con efectos de partículas

### Efectos Especiales "Kill"
Las capturas importantes (como la de la Reina) activarán un efecto especial tipo "Kill" que ocupará brevemente toda la pantalla:

1. **Desaturación momentánea** de la escena
2. **Líneas de velocidad** desde la pieza atacante
3. **Onomatopeya** de impacto estilo manga ("BAM!", "SLASH!")
4. **Flash** de color según el tema
5. **Viñetas** estilo cómic mostrando el "golpe final"

## Animaciones

### Tiempos y Duración
- **Movimientos normales**: 0.3-0.5 segundos
- **Capturas simples**: 1-2 segundos
- **Capturas importantes**: 3-6 segundos
- **Efectos "Kill"**: 5-6 segundos
- **Jaque mate**: 10-12 segundos
- **Transiciones entre escenas**: 1-2 segundos

### Técnicas de Animación
- **Interpolación (Tweening)** para movimientos fluidos
- **Sprites frame-by-frame** para efectos expresivos tipo anime
- **Partículas 2D** para auras, brillos y efectos mágicos
- **Animación por huesos** para personajes más complejos
- **Efectos de shader** para brillos, desaturaciones y transiciones

## Interfaz de Usuario

### Menú Principal
- **Estilo**: Minimalista con elementos de fantasía anime
- **Fondo**: Ilustración del tema actual con ligeras animaciones
- **Botones**: Diseño con marco ornamentado según el tema visual activo
- **Transiciones**: Desvanecimiento con efecto de partículas

### HUD en Partida
- **Temporizador**: Reloj con estilo visual acorde al tema
- **Contador de piezas**: Representado como "barra de vida" estilizada
- **Indicador de turno**: Icono animado que representa el color actual
- **Botones**: Diseño integrado que no distrae de la partida

### Elementos de Feedback
- **Tooltips**: Burbujas de texto estilo cómic/manga
- **Mensajes**: Texto con efectos de aparición dinámica
- **Notificaciones**: Íconos pequeños con animación de entrada/salida

## Audio y Música

Aunque no es visual, el audio complementará la estética:

### Música
- **Medieval**: Orquestal con influencias de fantasía
- **Samurai**: Instrumentos tradicionales japoneses con toques electrónicos
- **Cyberpunk**: Synth-wave y música electrónica
- **Mexica**: Instrumentos prehispánicos con elementos de música contemporánea

### Efectos de Sonido
- **Movimientos**: Sonidos sutiles acordes al tema
- **Capturas**: Efectos dramáticos tipo anime (sin voces)
- **Eventos especiales**: Sonidos únicos para enroque, jaque, etc.

## Implementación Técnica

### Sistema de Skins
```gdscript
# Estructura para skins de piezas
var piece_skins = {
    "medieval": {
        ChessPiece.Type.KING: preload("res://assets/pieces/themes/medieval/king.png"),
        ChessPiece.Type.QUEEN: preload("res://assets/pieces/themes/medieval/queen.png"),
        # etc.
    },
    "samurai": {
        ChessPiece.Type.KING: preload("res://assets/pieces/themes/samurai/king.png"),
        # etc.
    },
    # Otros temas
}

# Cambiar skin de una pieza
func apply_skin(piece_sprite: Sprite2D, piece_type: int, theme: String):
    if theme in piece_skins and piece_type in piece_skins[theme]:
        piece_sprite.texture = piece_skins[theme][piece_type]
```

### Sistema de Animaciones
```gdscript
# Ejemplo de sistema para animaciones
func play_capture_animation(attacker: Sprite2D, defender: Sprite2D, is_important: bool):
    if is_important:
        # Animación especial "Kill"
        $KillEffectOverlay.visible = true
        $KillEffectAnimationPlayer.play("kill_effect")
        await $KillEffectAnimationPlayer.animation_finished
        $KillEffectOverlay.visible = false
    else:
        # Animación simple de captura
        var tween = create_tween()
        tween.tween_property(attacker, "position", defender.position, 0.3)
        tween.tween_callback(func(): 
            $CaptureParticles.position = defender.position
            $CaptureParticles.emitting = true
        )
        await tween.finished
```

### Sistema de Efectos Visuales
```gdscript
# Ejemplo de sistema para efectos de partículas
func create_particle_effect(position: Vector2, effect_type: String):
    var effect_scene
    match effect_type:
        "capture":
            effect_scene = preload("res://scenes/effects/capture_effect.tscn")
        "promotion":
            effect_scene = preload("res://scenes/effects/promotion_effect.tscn")
        "check":
            effect_scene = preload("res://scenes/effects/check_effect.tscn")
        _:
            return
    
    var effect = effect_scene.instantiate()
    effect.position = position
    $EffectsContainer.add_child(effect)
    effect.play()
    # Autodestrucción después de terminado
    await effect.finished
    effect.queue_free()
```

## Plan de Implementación Visual

El desarrollo visual se distribuirá en fases:

1. **Versiones 0.1.0 - 0.6.0**: Gráficos funcionales básicos, sin animaciones complejas
2. **Versión 0.7.0 - 0.8.0**: Mejoras visuales iniciales, UI completa
3. **Versión 1.0.0**: Primer tema completo (Medieval)
4. **Versión 1.4.0 - 1.5.0**: Efectos visuales y animaciones completas
5. **Versiones 1.8.0 - 1.9.0**: Sistema de skins y temas adicionales
6. **Versión 2.0.0+**: Todos los temas completamente implementados

## Conclusión

El diseño visual de MonaChess busca crear una experiencia única de ajedrez que combine la elegancia del juego tradicional con la expresividad y dinamismo del anime. La implementación por fases permitirá primero centrarse en la funcionalidad del juego y luego añadir progresivamente los elementos visuales que darán a MonaChess su identidad distintiva.