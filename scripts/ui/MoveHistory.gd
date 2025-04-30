extends Control
class_name MoveHistory

# Historial de movimientos para MonaChess
# Versión 0.8.0

# Nodos
@onready var history_container = $ScrollContainer/VBoxContainer
@onready var scroll_container = $ScrollContainer

# Historial de movimientos
var moves = []
var current_move_index = -1

# Señales
signal move_selected(move_index)

# Inicialización
func _ready():
	# Limpiar el historial al inicio
	clear_history()

# Añade un movimiento al historial
func add_move(piece_info: String, from_pos: String, to_pos: String, is_capture: bool = false, is_check: bool = false, is_checkmate: bool = false, move_number: int = -1):
	# Formatear el movimiento en notación algebraica
	var move_text = _format_move(piece_info, from_pos, to_pos, is_capture, is_check, is_checkmate)
	
	# Calcular el número de movimiento si no se proporcionó
	if move_number < 0:
		move_number = (moves.size() / 2) + 1
	
	# Crear la instancia del movimiento
	var move_data = {
		"piece": piece_info,
		"from": from_pos,
		"to": to_pos,
		"capture": is_capture,
		"check": is_check,
		"checkmate": is_checkmate,
		"text": move_text,
		"number": move_number,
		"is_white": (moves.size() % 2 == 0)
	}
	
	# Añadir al historial
	moves.append(move_data)
	current_move_index = moves.size() - 1
	
	# Actualizar la visualización
	_update_history_display()
	
	# Hacer scroll hasta el último movimiento
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

# Formatea un movimiento según la notación algebraica de ajedrez
func _format_move(piece_info: String, from_pos: String, to_pos: String, is_capture: bool, is_check: bool, is_checkmate: bool) -> String:
	var move_text = ""
	
	# Pieza (excepto para peones, que usan la columna de origen en capturas)
	if piece_info == "P":
		if is_capture:
			move_text = from_pos[0] + "x" + to_pos
		else:
			move_text = to_pos
	else:
		move_text = piece_info
		if is_capture:
			move_text += "x"
		move_text += to_pos
	
	# Añadir símbolos de jaque o jaque mate
	if is_checkmate:
		move_text += "#"
	elif is_check:
		move_text += "+"
	
	return move_text

# Actualiza la visualización del historial
func _update_history_display():
	# Limpiar el contenedor
	for child in history_container.get_children():
		child.queue_free()
	
	# Agrupar movimientos por pares (blancas y negras)
	var move_pairs = {}
	
	for i in range(moves.size()):
		var move = moves[i]
		var move_number = int(i / 2) + 1
		
		if !move_pairs.has(move_number):
			move_pairs[move_number] = { "white": null, "black": null }
		
		if i % 2 == 0:
			move_pairs[move_number]["white"] = move
		else:
			move_pairs[move_number]["black"] = move
	
	# Crear entradas en el historial
	for number in move_pairs:
		var pair = move_pairs[number]
		
		# Crear contenedor para el par de movimientos
		var move_row = HBoxContainer.new()
		move_row.size_flags_horizontal = Control.SIZE_FILL
		
		# Añadir número de movimiento
		var number_label = Label.new()
		number_label.text = str(number) + "."
		number_label.custom_minimum_size = Vector2(30, 0)
		move_row.add_child(number_label)
		
		# Añadir movimiento de blancas
		if pair["white"]:
			var white_btn = Button.new()
			white_btn.text = pair["white"]["text"]
			white_btn.flat = true
			white_btn.custom_minimum_size = Vector2(70, 0)
			
			# Destacar movimiento actual
			if moves.find(pair["white"]) == current_move_index:
				white_btn.add_theme_color_override("font_color", Color(0.2, 0.6, 1.0))
				white_btn.add_theme_font_size_override("font_size", 16)
			
			# Conectar señal de pulsación
			var move_idx = moves.find(pair["white"])
			white_btn.pressed.connect(func(): _on_move_pressed(move_idx))
			
			move_row.add_child(white_btn)
		else:
			# Espacio vacío
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(70, 0)
			move_row.add_child(spacer)
		
		# Añadir movimiento de negras
		if pair["black"]:
			var black_btn = Button.new()
			black_btn.text = pair["black"]["text"]
			black_btn.flat = true
			black_btn.custom_minimum_size = Vector2(70, 0)
			
			# Destacar movimiento actual
			if moves.find(pair["black"]) == current_move_index:
				black_btn.add_theme_color_override("font_color", Color(0.2, 0.6, 1.0))
				black_btn.add_theme_font_size_override("font_size", 16)
			
			# Conectar señal de pulsación
			var move_idx = moves.find(pair["black"])
			black_btn.pressed.connect(func(): _on_move_pressed(move_idx))
			
			move_row.add_child(black_btn)
		
		# Añadir fila al contenedor principal
		history_container.add_child(move_row)

# Manejador de evento al pulsar un movimiento
func _on_move_pressed(move_index: int):
	current_move_index = move_index
	_update_history_display()
	emit_signal("move_selected", move_index)

# Limpia el historial de movimientos
func clear_history():
	moves.clear()
	current_move_index = -1
	
	# Limpiar la visualización
	for child in history_container.get_children():
		child.queue_free()

# Exporta el historial de movimientos en formato PGN
func export_pgn() -> String:
	var pgn = ""
	var move_number = 1
	
	# Información de cabecera (opcional)
	pgn += "[Event \"MonaChess Game\"]\n"
	pgn += "[Date \"" + Time.get_date_string_from_system() + "\"]\n"
	pgn += "[White \"Player 1\"]\n"
	pgn += "[Black \"Player 2\"]\n\n"
	
	# Movimientos
	for i in range(moves.size()):
		var move = moves[i]
		
		# Añadir número de movimiento al inicio del turno de blancas
		if i % 2 == 0:
			pgn += str(move_number) + ". "
			move_number += 1
		
		# Añadir el texto del movimiento
		pgn += move["text"] + " "
		
		# Salto de línea cada 5 movimientos completos para mayor legibilidad
		if move_number % 5 == 0 and i % 2 == 1:
			pgn += "\n"
	
	# Resultado (provisional)
	if moves.size() > 0 and moves[-1]["checkmate"]:
		if moves[-1]["is_white"]:
			pgn += "1-0"  # Victoria de blancas
		else:
			pgn += "0-1"  # Victoria de negras
	else:
		pgn += "*"  # Partida en curso o resultado indeterminado
	
	return pgn

# Importa un historial de movimientos en formato PGN (implementación básica)
func import_pgn(pgn_text: String):
	clear_history()
	
	# Implementación básica para interpretar sólo los movimientos
	# PGN completo requiere un análisis más complejo
	
	# Eliminar cabeceras y comentarios
	var moves_text = pgn_text
	
	# Eliminar cabeceras entre corchetes
	var regex_headers = RegEx.new()
	regex_headers.compile("\\[.*?\\]")
	moves_text = regex_headers.sub(moves_text, "", true)
	
	# Eliminar comentarios entre llaves
	var regex_comments = RegEx.new()
	regex_comments.compile("\\{.*?\\}")
	moves_text = regex_comments.sub(moves_text, "", true)
	
	# Separar los movimientos
	var regex_moves = RegEx.new()
	regex_moves.compile("(\\d+\\.\\s*)(\\S+)(\\s+)(\\S+)?")
	
	var results = regex_moves.search_all(moves_text)
	for result in results:
		var white_move = result.get_string(2)
		var black_move = result.get_string(4) if result.get_string(4) else ""
		
		# Aquí habría que parsear los movimientos para determinar
		# pieza, origen, destino, captura, jaque, etc.
		# Esta implementación es simplificada
		
		if white_move and white_move != "":
			_add_parsed_move(white_move, true)
		
		if black_move and black_move != "":
			_add_parsed_move(black_move, false)
	
	# Actualizar la visualización
	_update_history_display()

# Añade un movimiento parseado desde PGN (implementación simplificada)
func _add_parsed_move(move_text: String, is_white: bool):
	# Determinar si hay jaque o jaque mate
	var is_check = move_text.ends_with("+")
	var is_checkmate = move_text.ends_with("#")
	
	# Eliminar + o # del final
	if is_check or is_checkmate:
		move_text = move_text.substr(0, move_text.length() - 1)
	
	# Determinar si hay captura
	var is_capture = move_text.find("x") >= 0
	
	# Determinar destino (últimas 2 letras)
	var to_pos = move_text.substr(move_text.length() - 2, 2)
	
	# Determinar pieza y origen (implementación básica)
	var piece_info = "P"  # Por defecto, peón
	var from_pos = "a1"  # Por defecto, origen genérico
	
	if move_text.length() > 2:
		# Si el primer carácter es mayúscula, es una pieza diferente al peón
		if move_text[0] >= 'A' and move_text[0] <= 'Z':
			piece_info = move_text[0]
	
	# Añadir al historial de forma simplificada
	moves.append({
		"piece": piece_info,
		"from": from_pos,
		"to": to_pos,
		"capture": is_capture,
		"check": is_check,
		"checkmate": is_checkmate,
		"text": move_text,
		"number": int(moves.size() / 2) + 1,
		"is_white": is_white
	})
	
	current_move_index = moves.size() - 1
