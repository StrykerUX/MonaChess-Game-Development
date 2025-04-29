# Versión 0.6.0 - Reglas Básicas de Ajedrez

Esta versión implementa las reglas básicas del ajedrez, incluyendo la detección de jaque y jaque mate.

## Características Implementadas

1. **Detección de Jaque**
   - Sistema que verifica si un rey está en jaque después de cada movimiento
   - Resaltado visual del rey en jaque
   - Efectos visuales y notificaciones cuando se detecta un jaque

2. **Restricción de Movimientos**
   - Impide movimientos que dejarían al propio rey en jaque
   - Solo muestra como disponibles los movimientos legales
   - Mensajes de error claros cuando un movimiento no es válido

3. **Detección de Jaque Mate**
   - Verificación automática de jaque mate después de cada movimiento
   - Mensaje de victoria para el jugador ganador
   - Efectos visuales para el fin de juego

4. **Detección de Ahogado (Stalemate)**
   - Verificación de situaciones de ahogado (sin movimientos legales pero sin jaque)
   - Declaración automática de tablas cuando se detecta

5. **Sistema de Estado de Juego**
   - Control del estado activo/inactivo de la partida
   - Interfaz para mostrar el estado actual de la partida
   - Sistema para reiniciar después de finalizar un juego

## Archivos Modificados/Creados

- `scripts/chess/ChessBoard.gd` → Versión 0.6.0 que incluye reglas de jaque/mate
- `scripts/chess/utils/ChessUtils.gd` → Utilidades para operaciones comunes de ajedrez
- `scripts/chess/rules/ChessRules.gd` → Lógica para verificar reglas avanzadas
- `scenes/board/ChessBoard.tscn` → Actualizado para incluir indicadores de estado de juego

## Diagrama de Flujo

```
Jugador hace clic → Selecciona pieza → Se muestran solo movimientos legales
   ↓
Jugador selecciona destino → Verificación de jaque → Movimiento permitido/rechazado
   ↓
Después del movimiento → Verificar jaque al oponente → Verificar jaque mate o ahogado
   ↓
  Fin del juego o continuar con el siguiente turno
```

## Cambios Técnicos Importantes

1. **Algoritmo de Detección de Jaque**
   - Búsqueda de posición del rey
   - Verificación de amenazas desde todas las piezas enemigas
   - Optimización para no repetir verificaciones innecesarias

2. **Algoritmo de Detección de Jaque Mate**
   - Verificación exhaustiva de todos los movimientos posibles
   - Simulación de cada movimiento para comprobar si saca al rey del jaque
   - Declaración de victoria cuando no hay escapatoria

3. **Simulación de Movimientos**
   - Sistema para simular movimientos sin realizarlos en el tablero
   - Verificación de consecuencias antes de permitir un movimiento
   - Copias temporales del estado del tablero para análisis

4. **Interfaz de Usuario Mejorada**
   - Etiquetas y mensajes claros para el estado del juego
   - Efectos visuales para jaque y jaque mate
   - Indicaciones de fin de partida

## Pruebas Sugeridas

1. **Jaque Básico**: Mover una pieza para dar jaque al rey enemigo.
2. **Evitar Jaque**: Intentar mover una pieza que deje al propio rey en jaque (debería ser rechazado).
3. **Jaque Mate Simple**: Configurar un jaque mate con reina y torre.
4. **Ahogado**: Configurar una posición donde un jugador no tenga movimientos legales sin estar en jaque.

## Próximos Pasos

- Implementación de reglas avanzadas en la versión 1.0.0 (enroque, captura al paso, promoción de peón)
- Mejoras visuales para los efectos de jaque mate
- Opciones para reiniciar o retroceder movimientos
- Sonidos para eventos importantes (jaque, jaque mate)

## Notas Adicionales

- Se ha optimizado el rendimiento de las verificaciones de jaque para evitar ralentizaciones.
- La detección de ahogado puede requerir más pruebas en posiciones complejas.
- Los mensajes de estado del juego están preparados para traducción en versiones futuras.
