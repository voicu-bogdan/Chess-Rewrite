extends Control
@onready var sprite = $TextureRect
var old_tile_color
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_texture()


func _on_focus_entered():
	var parent_tile = self.get_parent()
	old_tile_color = parent_tile.color
	var x = parent_tile.get_meta("Position")
	print(x)
	parent_tile.color = Color.GREEN
	
func _on_focus_exited():
	var parent_tile = self.get_parent()
	parent_tile.color = old_tile_color
