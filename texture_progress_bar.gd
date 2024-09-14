extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	value = min_value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.total_squares != 0:
		value = (max_value - min_value) * float(Global.squares_shaded) / Global.total_squares + min_value
		$"../../../Label".text = str(int(float(Global.squares_shaded) / Global.total_squares * 100)) + "%"
