extends Control
@onready var sprite = $TextureRect
var old_tile_color
var legal_moves : Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func refresh_texture():
	var piece_name = get_meta("Name")
	var piece_color = get_meta("is_white")
	var texture_path
	if piece_color:
		texture_path = TextureDictionary.piece_textures["white"][piece_name]
	else:
		texture_path = TextureDictionary.piece_textures["black"][piece_name]
	sprite.texture = load(texture_path)

func check_position_legal(position):
	var parent_board = self.get_parent().get_parent().get_parent()
	var board_size = parent_board.get_meta("board_size")
	if position.x > 0 and position.x <= board_size and position.y > 0 and position.y <= board_size and parent_board.get_tile(position).get_child_count() == 0:
		return true 
	else: return false

func update_legal_moves():	
	var parent_board = self.get_parent().get_parent().get_parent()
	var board_size = parent_board.get_parent().get_meta("board_size")
	legal_moves = []
	var position = self.get_meta("Position")
	var aux = position
	var knight_moves = [
	Vector2i(2, 1), Vector2i(2, -1), 
	Vector2i(-2, 1), Vector2i(-2, -1), 
	Vector2i(1, 2), Vector2i(1, -2), 
	Vector2i(-1, 2), Vector2i(-1, -2)
	]
	match self.get_meta("is_white"):
		true:
			match self.get_meta("Name"):
				"pawn":
					for i in range (2):
						aux.x += 1
						if check_position_legal(aux):
							legal_moves.append(aux)
				"rook":
					pass
				"knight":
					for move in knight_moves:
						aux = position + move
						if check_position_legal(aux):
							legal_moves.append(aux)
				"bishop":
					pass
				"king":
					pass
				"queen":
					pass
		false:
			match self.get_meta("Name"):
				"pawn":
					for i in range (2):
						aux.x -= 1
						if check_position_legal(aux):
							legal_moves.append(aux)
				"rook":
					pass
				"knight":
					for move in knight_moves:
						aux = position + move
						if check_position_legal(aux):
							legal_moves.append(aux)
				"bishop":
					pass
				"king":
					pass
				"queen":
					pass
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_texture()

func _on_focus_entered():
	update_legal_moves()
	print(legal_moves)
	var parent_board = self.get_parent().get_parent().get_parent()
	for x in legal_moves:
		parent_board.show_move_markers(x)
	
func _on_focus_exited():
	var parent_board = self.get_parent().get_parent().get_parent()
	parent_board.clear_move_markers()
