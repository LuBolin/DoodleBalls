extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var cycle = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cycle += delta * 10
	if cycle > 100:
		cycle = 0
	value = cycle
