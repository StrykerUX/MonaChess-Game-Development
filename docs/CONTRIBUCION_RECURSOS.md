# Guía de Contribución para Recursos - MonaChess

Esta guía está diseñada para artistas, diseñadores de sonido y colaboradores que deseen contribuir con recursos visuales o de audio al proyecto MonaChess, incluso si no tienen experiencia en programación.

## ¿Qué necesita MonaChess?

MonaChess es un juego de ajedrez con estética anime que necesita:

- **Sprites de piezas**: Ilustraciones de las 6 piezas de ajedrez (Rey, Reina, Alfil, Caballo, Torre, Peón) en estilo anime
- **Fondos**: Imágenes para el tablero y menús
- **Efectos visuales**: Animaciones para movimientos, capturas y eventos especiales
- **Iconos de UI**: Botones, indicadores y elementos de interfaz
- **Música**: Temas musicales para menús y partidas
- **Efectos de sonido**: Para movimientos, capturas y eventos

## Requisitos Técnicos para Recursos

### Imágenes y Sprites

- **Formato**: PNG con transparencia (preferido) o JPEG para fondos sin transparencia
- **Resolución**:
  - Piezas: 256x256 píxeles (mínimo)
  - Fondos: 1920x1080 píxeles (para compatibilidad con distintas resoluciones)
  - Iconos UI: 128x128 píxeles
- **Estilo**: Anime/Manga, coherente con el documento VISUAL_DESIGN.md
- **Variantes**: Se necesitan versiones para ambos bandos (blanco/negro)

### Animaciones

- **Formato**: Secuencia de PNG o spritesheet
- **Duración recomendada**:
  - Movimientos normales: 3-5 frames
  - Capturas/Efectos especiales: 5-10 frames
- **Nombrado**: Usar convención clara (ej: `king_white_move_01.png`, `king_white_move_02.png`, etc.)

### Audio

- **Formato**: OGG (preferido) o WAV (para procesamiento adicional)
- **Música**:
  - Duración: 2-3 minutos, con loop suave
  - Tamaño: procurar mantenerlo bajo 5MB por pista si es posible
- **Efectos**:
  - Duración: Cortos (0.5-3 segundos)
  - Claridad: Fácilmente distinguibles entre sí

## Estructura de Carpetas

Los recursos deben organizarse siguiendo esta estructura:

```
assets/
├── audio/
│   ├── music/
│   │   ├── menu/
│   │   ├── gameplay/
│   │   └── themes/       # Música para cada tema visual
│   └── sfx/              # Efectos de sonido
│       ├── pieces/
│       ├── ui/
│       └── events/
├── fonts/                # Fuentes tipográficas
├── images/
│   ├── backgrounds/      # Fondos para escenas
│   ├── ui/               # Elementos de interfaz
│   └── effects/          # Efectos visuales generales
├── pieces/               # Sprites de piezas
│   ├── default/          # Estilo base
│   └── themes/           # Carpetas para cada tema visual
│       ├── medieval/
│       ├── samurai/
│       ├── cyberpunk/
│       └── mexica/
└── themes/               # Recursos adicionales para temas visuales
```

## Cómo Contribuir (Sin Conocimientos de Programación)

Existen varias formas de contribuir incluso si no sabes programar:

### Opción 1: Mediante Issues de GitHub

1. Regístrate en GitHub si aún no tienes una cuenta
2. Ve al [repositorio del proyecto](https://github.com/StrykerUX/MonaChess-Game-Development)
3. Haz clic en "Issues" -> "New Issue"
4. Describe el recurso que quieres aportar
5. Adjunta el archivo o un enlace de descarga
6. Los mantenedores revisarán e integrarán tu aporte

### Opción 2: Mediante Pull Request (Más Técnico)

Si estás familiarizado con GitHub:

1. Haz un fork del repositorio
2. Añade tus recursos en las carpetas correspondientes
3. Haz commit de tus cambios
4. Crea un Pull Request describiendo tu contribución

### Opción 3: Compartir mediante Google Drive u Otro Medio

Si prefieres no usar GitHub:

1. Organiza tus archivos según la estructura descrita
2. Comparte un enlace de Google Drive (o similar) con los mantenedores
3. Envía un correo o mensaje describiendo tu contribución

## Consejos para Crear Recursos Efectivos

### Para Artistas

- **Consistencia**: Mantén un estilo coherente entre todas las piezas
- **Variedad**: Crea poses y expresiones distintas para diferentes acciones
- **Legibilidad**: Asegúrate de que las piezas sean fácilmente identificables
- **Paleta**: Sigue la guía de colores de cada tema visual

### Para Creadores de Audio

- **Atmósfera**: La música debe reflejar el tema visual correspondiente
- **Claridad**: Los efectos deben ser distinguibles y no abrumadores
- **Coherencia**: Mantén un estilo de sonido consistente dentro de cada tema
- **Volumen**: Equilibra los niveles de volumen entre diferentes efectos

## Reconocimiento de Autoría

Todos los contribuyentes serán reconocidos en:

1. Los créditos dentro del juego
2. El archivo CONTRIBUTORS.md del repositorio
3. La documentación del proyecto

Especifica cómo quieres que aparezca tu nombre/apodo y si deseas incluir enlaces a tu portfolio o redes sociales.

## Licencia

Al contribuir recursos, aceptas que sean distribuidos bajo la licencia MIT del proyecto. Si deseas condiciones especiales para tus contribuciones, especifícalo claramente al enviarlas.

## Inspiración y Referencias

Para entender mejor el estilo visual del proyecto:

- Revisa el documento [VISUAL_DESIGN.md](VISUAL_DESIGN.md) para detalles sobre la estética
- Consulta la carpeta `references/` (si está disponible) para ejemplos visuales
- Pide a los mantenedores ejemplos o mockups si necesitas más claridad

## Ejemplos de Convenciones de Nombres

### Para Piezas

```
king_white_idle.png
king_black_idle.png
queen_white_attack.png
pawn_black_defeat.png
```

### Para Efectos

```
capture_effect_minor.png
capture_effect_major_01.png
capture_effect_major_02.png
checkmate_effect.png
```

### Para Audio

```
theme_medieval_menu.ogg
theme_cyberpunk_gameplay.ogg
sfx_move_piece.ogg
sfx_capture_minor.ogg
sfx_checkmate.ogg
```

## Contacto y Preguntas

Si tienes dudas sobre los recursos que puedes contribuir, no dudes en:

- Abrir un Issue con tu pregunta
- Contactar directamente con los mantenedores

¡Gracias por ayudar a que MonaChess sea un juego visualmente espectacular!