extends Control
@onready var board = $GridContainer
@onready var tile = preload("res://scenes/game/Tile.tscn")
@onready var piece = preload("res://scenes/game/Piece.tscn")
@onready var move_marker = preload("res://scenes/game/move_marker.tscn")
@onready var board_size = get_meta("board_size")
@onready var white = get_meta("White")
@onready var black = get_meta("Black")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_board_size()
	set_board_from_FEN(get_meta("FEN"))

func update_board_size():
	for n in board.get_children(): # remove all previous children
		board.remove_child(n)
		n.queue_free()
	
	board.columns = board_size #set the GridContainer's columns to the current board size
	
	var number_of_children = board_size * board_size; #calculate number of children in new grid
	
	for i in range (1, board_size+1):
		for j in range (1, board_size+1):
			var new_tile = tile.instantiate()
			if i%2 == j%2:
				new_tile.color = white
			else:
				new_tile.color = black
			new_tile.set_name(str(board_size-i+1, ",", j))
			var position = Vector2i(board_size-i+1, j)
			new_tile.set_meta("Position", position)
			board.add_child(new_tile)

func get_tile(tile_position):
	var tile = board.get_node(str(tile_position.x) + "," + str(tile_position.y))
	return tile

func add_piece(is_white, name, position):
	var tile = get_tile(position)
	var new_piece = piece.instantiate()
	new_piece.set_meta("Position", position)
	new_piece.set_meta("Name", name)
	new_piece.set_meta("is_white", is_white)
	tile.add_child(new_piece)

func set_board_from_FEN(fen_code):
	var x = 1;
	var y = board_size;
	for i in fen_code:
		if i=="/": #check if new line
			x = 1
			y = y-1
		elif (i >= '0' && i <= '9'): #check if the number is an integer
			x = x + int(i)
		elif i == i.to_lower(): #check if the number is black
			add_piece(false, FenDictionary.piece_names["black"][i], Vector2i(y, x))
			x = x+1
		elif i == i.to_upper(): #check if the number is white
			add_piece(true, FenDictionary.piece_names["white"][i], Vector2i(y, x))
			x = x+1

func show_move_markers(position):
	var tile = get_tile(position)
	var new_move_marker = move_marker.instantiate()
	tile.add_child(new_move_marker)

func clear_move_markers():
	for i in board.get_children():
		if i.has_node("MoveMarker"):
			i.get_node("MoveMarker").queue_free()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_meta("board_size") != board_size: #update the board if board_size has changed
		board_size = get_meta("board_size")
		update_board_size()
