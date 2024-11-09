extends Control
@onready var board = $GridContainer
@onready var tile = preload("res://scenes/game/Tile.tscn")
@onready var piece = preload("res://scenes/game/Piece.tscn")
@onready var board_size = get_meta("board_size")
@onready var white = get_meta("White")
@onready var black = get_meta("Black")
# Called when the node enters the scene tree for the first time.
func _ready():
	update_board_size()
	add_piece(false, "king", Vector2i(3,4))
	add_piece(true, "queen", Vector2i(5,1))
	add_piece(true, "pawn", Vector2i(8, 8))
	add_piece(true, "pawn", Vector2i(2, 6))

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

func add_piece(is_white, name, position):
	var tile = board.get_node(str(position.x) + "," + str(position.y))
	var new_piece = piece.instantiate()
	new_piece.set_meta("Position", position)
	new_piece.set_meta("Name", name)
	new_piece.set_meta("is_white", is_white)
	tile.add_child(new_piece)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_meta("board_size") != board_size: #update the board if board_size has changed
		board_size = get_meta("board_size")
		update_board_size()
	pass
