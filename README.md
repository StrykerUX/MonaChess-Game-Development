# MonaChess - Ajedrez de Monas Chinas

![Estado de Desarrollo](https://img.shields.io/badge/Estado-Versión%200.7.0-green)
![Godot Version](https://img.shields.io/badge/Godot-v4.2%2B-blue)
![Licencia](https://img.shields.io/badge/Licencia-MIT-green)

## 📝 Descripción

MonaChess es un juego de ajedrez con estética anime, desarrollado en Godot Engine 4.2+. Implementa todas las reglas estándar del ajedrez, combinadas con efectos visuales de estilo anime, múltiples temas visuales y un sistema de progresión.

### 🚧 Estado Actual: Versión 0.7.0 - UI Mínima Funcional

Esta versión incluye:
- Menú principal completo con animaciones y transiciones fluidas
- Sistema de pausa durante el juego con opciones de reanudar, reiniciar o salir
- Panel de estado del juego con historial de movimientos
- Cronometraje para cada jugador con indicadores visuales
- Menú de ajustes con opciones para video, audio, jugabilidad y accesibilidad
- Sistema de notificaciones para informar al usuario sobre eventos del juego
- Pantalla de fin de partida con resultados y opciones de continuación
- Sistema de temas visuales y diseño coherente en toda la interfaz

## 🎯 Características Planeadas

- Sistema completo de ajedrez con todas las reglas oficiales
- Efectos visuales y animaciones estilo anime
- Múltiples modos de juego: Historia, Partida Rápida, Multijugador
- IA con varios niveles de dificultad
- Sistema de progresión y desbloqueo de skins
- Estilos visuales temáticos (Medieval, Samurai, Cyberpunk, Mexica futurista)
- Tutorial interactivo para nuevos jugadores

## 🛠️ Tecnologías

- **Motor**: Godot Engine 4.2 o superior
- **Lenguaje**: GDScript
- **Estructura**: Sistema modular basado en escenas

## 🏗️ Estructura del Proyecto

```
MonaChess/
├── assets/            # Recursos gráficos y audiovisuales
│   ├── audio/         # Música y efectos de sonido
│   ├── fonts/         # Fuentes tipográficas
│   ├── images/        # Imágenes de UI y fondos
│   ├── pieces/        # Sprites y animaciones de piezas
│   │   ├── default/   # Skin por defecto
│   │   └── themes/    # Carpetas para cada tema visual
│   └── themes/        # Recursos de temas visuales
├── scenes/            # Escenas del juego
│   ├── board/         # Escena del tablero y piezas
│   │   └── pieces/    # Escenas para cada tipo de pieza
│   ├── ui/            # Interfaces de usuario
│   ├── game/          # Lógica principal del juego
│   └── menus/         # Menús y pantallas
├── scripts/           # Scripts independientes
│   ├── chess/         # Lógica de ajedrez
│   │   └── pieces/    # Scripts para cada tipo de pieza
│   ├── ai/            # IA y algoritmos
│   ├── global/        # Autoloads y scripts globales
│   └── utils/         # Utilidades y funciones auxiliares
├── resources/         # Recursos reutilizables
│   ├── translations/  # Archivos de traducción
│   └── themes/        # Temas de UI
├── addons/            # Plugins de Godot (si se requieren)
└── project.godot      # Archivo principal del proyecto
```

## 📋 Requisitos

- Godot Engine 4.2 o superior
- Capacidad gráfica para renderizar 2D con efectos visuales
- Espacio en disco: ~100MB (estimado para versión completa)

## 🚀 Instalación y Ejecución

### Desde el editor de Godot:

1. Clona este repositorio:
   ```
   git clone https://github.com/StrykerUX/MonaChess-Game-Development.git
   ```
2. Abre Godot Engine
3. Selecciona "Importar" y navega hasta la carpeta del proyecto
4. Abre el proyecto y presiona F5 para ejecutar

### Para Desarrolladores:

1. Fork del repositorio
2. Clona tu fork:
   ```
   git clone https://github.com/TU_USUARIO/MonaChess-Game-Development.git
   ```
3. Crea una rama para tu característica:
   ```
   git checkout -b feature/nombre-caracteristica
   ```
4. Sigue el plan de versiones para implementar características

## 📝 Plan de Versiones

- **0.0.0**: ✅ Estructura Base
- **0.1.0**: ✅ Tablero Funcional
- **0.2.0**: ✅ Piezas Básicas
- **0.3.0**: ✅ Movimientos Básicos
- **0.4.0**: ✅ Sistema de Turnos
- **0.5.0**: ✅ Capturas
- **0.6.0**: ✅ Reglas Básicas de Ajedrez
- **0.7.0**: ✅ UI Mínima Funcional (actual)
- **0.8.0**: MVP Jugable
- **1.0.0**: MVP Completo

*Ver documento completo de plan de versiones para más detalles.*

## 👥 Contribución

Las contribuciones son bienvenidas. Por favor, sigue estos pasos:

1. Fork del repositorio
2. Crea una rama para tu característica
3. Realiza tus cambios
4. Envía un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Contacto

- Creador: [TuNombre](mailto:tucorreo@ejemplo.com)
- GitHub: [https://github.com/StrykerUX](https://github.com/StrykerUX)
