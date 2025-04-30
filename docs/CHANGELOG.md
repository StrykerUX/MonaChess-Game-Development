# Registro de Cambios - MonaChess

## v0.8.0 - MVP Jugable (Mayo 30, 2025)

### Añadido
- Sistema de guardado y carga de partidas
- Notificaciones mejoradas con diferentes tipos y efectos visuales
- Historial detallado de movimientos con notación de ajedrez
- Efectos visuales más claros para movimientos y eventos importantes
- Soporte para mostrar coordenadas del tablero al pasar el ratón
- Tutoriales contextuales para nuevos jugadores
- Clase ResourceManager para gestión optimizada de recursos
- Sistema ObjectPoolManager para gestión eficiente de objetos

### Cambiado
- Optimización de algoritmos críticos (verificación de jaque/jaque mate)
- Interfaz de partida mejorada con más información y mejor diseño
- Efectos visuales rediseñados para mejor rendimiento y estética
- Mejora significativa de feedback para acciones inválidas
- Menú de pausa con transiciones fluidas y efecto de desenfoque
- Optimización general de rendimiento para dispositivos de gama media

### Errores Corregidos
- Bug en la verificación de camino para movimientos de alfil
- Bug en la validación de algunos movimientos de torre
- Problema de feedback al seleccionar piezas de color incorrecto
- Fugas de memoria en efectos visuales repetitivos
- Problemas de detección de tablas en algunos casos específicos
- Inconsistencias visuales en diferentes resoluciones

## v0.7.0 - UI Mínima Funcional (Mayo 15, 2025)

### Añadido
- Menú principal con animaciones y diseño mejorado
- Sistema de pausa con opciones completas
- Panel de estado del juego con información detallada
- Historial de movimientos en notación de ajedrez
- Cronometraje para cada jugador con advertencias visuales
- Menú de ajustes con múltiples opciones de configuración
- Sistema de notificaciones dinámicas
- Pantalla de fin de partida con animaciones
- Transiciones suaves entre escenas
- Sistema de temas visuales consistente

### Cambiado
- Estructura de la interfaz de usuario completamente renovada
- Integración mejorada entre el tablero y la UI
- Optimización de la experiencia de usuario
- Sistema de manejo de eventos del juego
- Mejoras en la navegación y flujo de usuarios

### Errores Corregidos
- Problemas de visualización en diferentes resoluciones
- Problemas con el cambio de estado del juego
- Comportamiento inconsistente de la UI durante eventos del juego

## v0.6.0 - Reglas Básicas de Ajedrez (Abril 28, 2025)

### Añadido
- Detección de jaque y jaque mate
- Restricción de movimientos que dejarían al rey en jaque
- Detección de ahogado (stalemate)
- Efectos visuales para jaque y jaque mate
- Mensajes de estado del juego
- Sistema de fin de partida

### Cambiado
- Estructura mejorada del tablero de ajedrez
- Optimización en la validación de movimientos
- Interfaz de usuario actualizada con indicadores de estado
- Resaltado visual para movimientos legales más intuitivo

### Errores Corregidos
- Validación correcta de movimientos según las reglas del ajedrez
- Problema con el cambio de turno después de terminar la partida

## v0.5.0 - Sistema de Capturas (Marzo 15, 2025)

### Añadido
- Sistema de captura de piezas
- Panel visual de piezas capturadas
- Efectos visuales para capturas
- Animaciones durante la captura

### Cambiado
- Mejora en la selección de piezas
- Resaltado para captura en casillas con piezas enemigas

## v0.4.0 - Sistema de Turnos (Febrero 22, 2025)

### Añadido
- Sistema de turnos alternos (blancas/negras)
- Indicador visual del turno actual
- Restricción de selección de piezas según el turno
- Señales para eventos de cambio de turno

### Cambiado
- Mejora en la interfaz de usuario del tablero
- Optimizaciones en la gestión de piezas

## v0.3.0 - Movimientos Básicos (Enero 30, 2025)

### Añadido
- Implementación de movimientos legales para cada tipo de pieza
- Sistema para resaltar casillas válidas para moverse
- Lógica para mover piezas en el tablero
- Validación básica de movimientos

### Cambiado
- Mejora en la representación de piezas
- Optimizaciones en la gestión del tablero

## v0.2.0 - Piezas Básicas (Diciembre 18, 2024)

### Añadido
- Clase base para piezas de ajedrez
- Implementación de los 6 tipos de piezas con sprites temporales
- Posicionamiento inicial de las piezas en el tablero
- Sistema básico de selección de piezas

### Cambiado
- Estructura mejorada del tablero

## v0.1.0 - Tablero Funcional (Noviembre 25, 2024)

### Añadido
- Implementación del tablero como matriz de datos 8x8
- Representación visual básica del tablero (cuadrícula)
- Sistema de coordenadas (A1-H8)
- Lógica para posicionar elementos en el tablero

### Cambiado
- Estructura inicial del proyecto

## v0.0.0 - Estructura Base (Noviembre 10, 2024)

### Añadido
- Configuración inicial del proyecto Godot
- Estructura de carpetas básica
- Escena principal vacía
- Sistema de gestión de escenas
