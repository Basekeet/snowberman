extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tilemap = get_parent().tilemap
	var tile_size = tilemap.get_tileset().tile_size
	var tilemap_rect = tilemap.get_used_rect()

	var x_map = (tilemap_rect.end.x - tilemap_rect.position.x) * tile_size[0]
	var y_map =	(tilemap_rect.end.y - tilemap_rect.position.y) * tile_size[1]

	
	var camera_size = get_viewport().size
	var x_camera = camera_size[0]
	var y_camera = camera_size[1]
	
	set_zoom(Vector2(float(x_camera) / float(x_map), float(y_camera) / float(y_map)))
