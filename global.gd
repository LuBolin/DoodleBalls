extends Node

signal line_erased
signal enclosed(value: Vector2)

var pencil: Pencil = null
var pixel_layer: PixelLayer = null

var squares_shaded = 0
var total_squares = 0.0
const WIN_THRESHOLD = 0.72 #percentage hold
const WIN_TIME = 3
var win_timer = WIN_TIME # seconds hold to win

func _ready() -> void:
	add_input_mouse("doodle", MOUSE_BUTTON_LEFT)
	add_input_mouse("tilt", MOUSE_BUTTON_RIGHT)
	squares_shaded = 0
	total_squares = 0

func add_input_key(input_name: String, input_key: Key):
	InputMap.add_action(input_name)
	var event_space = InputEventKey.new()
	event_space.physical_keycode = input_key
	InputMap.action_add_event(input_name, event_space)

func add_input_mouse(input_name: String, input_mouse: MouseButton):
	InputMap.add_action(input_name)
	var event_space = InputEventMouseButton.new()
	event_space.button_index = input_mouse
	InputMap.action_add_event(input_name, event_space)
	

func _process(delta):
	if (not total_squares == 0):
		if (float(squares_shaded) / total_squares > WIN_THRESHOLD):
			win_timer -= delta
		else:
			win_timer = WIN_TIME
		if win_timer < 0:
			print("you win!")
			pass
	
