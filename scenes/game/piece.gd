extends Control
@onready var sprite = $TextureRect

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
