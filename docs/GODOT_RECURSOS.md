# Guía de Integración de Recursos en Godot - MonaChess

Esta guía explica cómo integrar correctamente recursos gráficos y de audio en el proyecto Godot de MonaChess, tanto para contribuidores técnicos como para aquellos con menos experiencia en programación.

## Importación de Recursos en Godot

### Método 1: Desde el Editor de Godot

1. **Abrir el proyecto** en Godot Engine
2. **Utilizar el panel FileSystem** (generalmente ubicado a la izquierda)
3. **Arrastrar y soltar** los archivos desde el explorador de archivos a la carpeta correspondiente en el panel FileSystem
4. **Confirmar opciones de importación** cuando aparezca el diálogo

![Ejemplo del panel FileSystem](https://docs.godotengine.org/en/stable/_images/project_manager.png)

### Método 2: Copiar Directamente a la Carpeta del Proyecto

1. **Navegar** a la carpeta del proyecto en tu explorador de archivos
2. **Copiar** los archivos de recursos a la carpeta correcta siguiendo la estructura definida
3. **Volver a Godot** y hacer clic derecho en el panel FileSystem
4. Seleccionar **"Rescan Filesystem"** para que Godot detecte los nuevos archivos

## Configuración de Importación por Tipo de Recurso

### Imágenes y Sprites

Cuando importes imágenes, Godot mostrará opciones de importación:

1. **Para sprites de piezas**:
   - Modo de compresión: Lossless o Lossy (según calidad requerida)
   - Filtro: Linear (para escalado suave)
   - Mipmaps: Desactivados (para sprites 2D pequeños)
   - Repetir: Disabled

2. **Para fondos y texturas grandes**:
   - Modo de compresión: Lossy
   - Filtro: Linear
   - Mipmaps: Activados (mejora apariencia a distancia)
   - Repetir: Disabled (o Enabled si es un patrón)

### Animaciones

Para animaciones en secuencia o spritesheets:

1. **Selecciona el archivo** en el panel FileSystem
2. Ve a la pestaña **Import** en el panel Inspector (derecha)
3. Ajusta la configuración según sea necesario:
   - Para spritesheets: Activa "Animation" y configura las dimensiones de cada frame
   - Para secuencias: Activa "Import as Texture2D animation" y establece "Frames" correctamente

### Audio

Para archivos de audio:

1. **Música de fondo**:
   - Loop: Activado (para reproducción continua)
   - Format: Vorbis (OGG) para buena compresión
   - Bit Depth: 16 bits es suficiente para música de fondo

2. **Efectos de sonido**:
   - Loop: Generalmente desactivado
   - Format: Vorbis para efectos largos, WAV para efectos cortos
   - Bit Depth: 16 bits

## Optimización de Recursos

### Imágenes

- **Tamaño de poder de 2**: Siempre que sea posible, usa dimensiones como 128x128, 256x256, 512x512, etc.
- **Comprimir texturas grandes**: Usa formatos de compresión para fondos y texturas grandes
- **Atlases de texturas**: Considera agrupar pequeños sprites relacionados en un atlas de texturas

### Audio

- **Convertir a Mono**: Para efectos de sonido no direccionales
- **Reducir tasa de muestreo**: 44.1kHz para música, 22.05kHz puede ser suficiente para efectos
- **Ajustar calidad OGG**: Valores entre 0.6 y 0.8 ofrecen buen balance entre calidad y tamaño

## Organización en Godot

### Trabajando con ResourcePreloader

Para cargar eficientemente múltiples sprites o sonidos:

```gdscript
# Ejemplo de uso de ResourcePreloader
var preloader = ResourcePreloader.new()

# Añadir recursos
preloader.add_resource("king_white", load("res://assets/pieces/default/king_white.png"))
preloader.add_resource("king_black", load("res://assets/pieces/default/king_black.png"))

# Recuperar recursos cuando sea necesario
var king_sprite = preloader.get_resource("king_white")
```

### Sistema de Temas con Resources

Para implementar el sistema de temas visuales:

```gdscript
# Crear un recurso personalizado para temas
class_name ChessTheme
extends Resource

export var theme_name: String
export var piece_set: String
export var board_texture: Texture2D
export var background_texture: Texture2D
export var capture_effect: PackedScene
```

## Consejos para Colaboradores no Técnicos

Si no estás familiarizado con Godot:

1. **Prepara los archivos** siguiendo las convenciones de nombres y carpetas
2. **Crea un ZIP** organizado con la misma estructura de carpetas
3. **Comparte el ZIP** a través de un Issue en GitHub
4. Los desarrolladores se encargarán de importar correctamente los recursos

## Control de Versiones y Git

### Recursos Pequeños

Los recursos pequeños pueden añadirse directamente al repositorio:

```bash
git add assets/pieces/default/pawn_white.png
git commit -m "Añade sprite de peón blanco"
git push
```

### Recursos Grandes

Para recursos grandes (>10MB), es mejor usar Git LFS:

1. **Asegúrate de tener Git LFS instalado**:
   ```bash
   git lfs install
   ```

2. **Configura los tipos de archivo para LFS**:
   ```bash
   git lfs track "*.ogg"
   git lfs track "*.wav"
   git lfs track "*.png" # Si son archivos grandes
   ```

3. **Añade el archivo .gitattributes**:
   ```bash
   git add .gitattributes
   ```

4. **Añade y haz commit de los archivos normalmente**:
   ```bash
   git add assets/audio/music/theme_medieval.ogg
   git commit -m "Añade tema musical medieval"
   git push
   ```

## Licencias y Atribuciones

Para cada recurso externo, asegúrate de:

1. **Verificar la licencia** del recurso original
2. **Documentar la fuente** y términos de licencia
3. **Añadir atribuciones** en un archivo README o CREDITS en la carpeta correspondiente

Ejemplo de archivo de atribución:

```
# Atribuciones de Recursos

## Sprites de Piezas
- king_white.png: Creado por [Tu Nombre], licencia MIT
- queen_black.png: Adaptado de "Chess Queen" por [Autor Original], CC-BY 4.0, https://ejemplo.com/fuente

## Música
- theme_medieval.ogg: Compuesto por [Compositor], licencia MIT
```

## Problemas Comunes y Soluciones

### Texturas que no aparecen correctamente
- Verifica que las imágenes tengan el modo de importación correcto
- Asegúrate de que la transparencia esté correctamente configurada

### Audio que no se reproduce
- Comprueba el formato y la configuración de importación
- Verifica las configuraciones de AudioBus en el proyecto

### Problemas de rendimiento
- Comprime texturas grandes que no necesiten alta resolución
- Usa mipmaps para texturas vistas a diferentes distancias
- Preload los recursos que se usan frecuentemente

## Petición de Recursos Específicos

Si tienes habilidades artísticas y deseas contribuir pero no sabes por dónde empezar, revisa:

1. Los **Issues** con etiqueta "art-needed" en GitHub
2. El documento **VISUAL_DESIGN.md** para entender el estilo requerido
3. Pregunta en las **Discusiones** de GitHub qué recursos son prioritarios