# Guía de Contribución - MonaChess

¡Gracias por tu interés en contribuir al proyecto MonaChess! Esta guía te ayudará a entender el proceso de contribución y la estructura del proyecto.

## Planificación y Versiones

Este proyecto se desarrolla siguiendo un plan de versiones claramente definido:

- **0.0.0**: Estructura Base (actual)
- **0.1.0**: Tablero Funcional
- **0.2.0**: Piezas Básicas
- **0.3.0**: Movimientos Básicos

Puedes consultar el documento completo en `docs/VERSION_0.0.0.md` para ver el plan a largo plazo.

## Cómo Contribuir

### Preparación del Entorno

1. **Requisitos**:
   - Godot Engine 4.2 o superior
   - Git

2. **Fork y Clone**:
   ```bash
   git clone https://github.com/TU_USUARIO/MonaChess-Game-Development.git
   cd MonaChess-Game-Development
   ```

3. **Abrir el Proyecto**:
   - Abre Godot Engine
   - Selecciona "Importar"
   - Navega hasta la carpeta del proyecto y ábrelo

### Flujo de Trabajo

1. **Crea una rama para tu característica**:
   ```bash
   git checkout -b feature/nombre-de-tu-caracteristica
   ```

2. **Desarrolla tu aporte**:
   - Sigue las convenciones de código
   - Mantén el alcance de tus cambios enfocado en una sola característica
   - Asegúrate de que tu código respete la arquitectura del proyecto

3. **Prueba tus cambios**:
   - Verifica que tu código funcione correctamente
   - Asegúrate de que no introduce regresiones

4. **Envía un Pull Request**:
   - Proporciona un título claro y descriptivo
   - Describe detalladamente los cambios realizados
   - Menciona la versión a la que está destinada tu contribución

## Estructura del Proyecto

```
MonaChess/
├── assets/            # Recursos gráficos y audiovisuales
├── scenes/            # Escenas del juego
├── scripts/           # Scripts
│   ├── global/        # Scripts globales (Autoloads)
│   ├── chess/         # Lógica de ajedrez
│   ├── ai/            # IA y algoritmos
│   ├── menus/         # Scripts para menús
│   └── utils/         # Utilidades
├── resources/         # Recursos reutilizables
│   ├── translations/  # Archivos de traducción
│   └── themes/        # Temas de UI
└── addons/            # Plugins (si se requieren)
```

## Convenciones de Código

- Utiliza GDScript para todos los scripts
- Usa PascalCase para nombres de nodos y clases
- Usa snake_case para nombres de variables y funciones
- Utiliza comentarios explicativos para código complejo
- Mantén las funciones pequeñas y con una sola responsabilidad

### Ejemplo de Estilo de Código

```gdscript
extends Node

# Constantes en UPPER_CASE
const MAX_PLAYERS = 2
const PIECE_TYPES = {
    PAWN = 0,
    ROOK = 1,
    KNIGHT = 2
}

# Variables en snake_case
var current_player = 0
var board_state = []

# Función con documentación
func move_piece(from_pos: Vector2, to_pos: Vector2) -> bool:
    """
    Mueve una pieza en el tablero.
    
    Parámetros:
    from_pos -- Posición origen (Vector2)
    to_pos -- Posición destino (Vector2)
    
    Retorna:
    bool -- True si el movimiento fue exitoso
    """
    # Implementación
    return true
```

## Temas Prioritarios para Contribuir

En esta etapa inicial (Versión 0.0.0), nos enfocamos en:

1. Configuración y estructura del proyecto
2. Documentación
3. Preparación para la implementación del tablero (Versión 0.1.0)

## Preguntas y Comunicación

Si tienes preguntas o necesitas ayuda, puedes:

1. **Abrir un Issue**: Para preguntas o problemas relacionados con el código
2. **Discusiones**: Para ideas o sugerencias sobre el proyecto
3. **Pull Requests**: Para contribuir con código o documentación

## Principios de Diseño

El desarrollo de MonaChess sigue estos principios:

1. **Modularidad**: Componentes independientes y reutilizables
2. **Claridad**: Código legible y bien documentado
3. **Extensibilidad**: Arquitectura que facilite la adición de nuevas características
4. **Optimización**: Rendimiento adecuado sin sacrificar la claridad
5. **Estética**: Mantener el estilo visual de anime consistente en todos los elementos

## Compromiso con la Calidad

Esperamos que todas las contribuciones mantengan un alto estándar de calidad:

- **Pruebas**: Verifica que tu código funcione como se espera
- **Performance**: Considera el impacto en el rendimiento de tus cambios
- **Documentación**: Actualiza la documentación relacionada con tus cambios
- **Compatibilidad**: Asegúrate de que los cambios sean compatibles con la versión mínima de Godot requerida (4.2)

## Próximos Pasos

Después de la versión 0.0.0, comenzaremos a trabajar en:

- Implementación del tablero de ajedrez (versión 0.1.0)
- Sistema de piezas básicas (versión 0.2.0)
- Movimientos y reglas del ajedrez (versiones 0.3.0 - 0.6.0)

¡Gracias por contribuir a hacer de MonaChess un gran juego de ajedrez con estética anime!