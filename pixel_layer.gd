class_name PixelLayer extends TileMapLayer

func _ready() -> void:
	assert(Global.pixel_layer == null)
	Global.pixel_layer = self
