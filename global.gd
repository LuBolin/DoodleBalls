extends Node

signal line_erased
signal enclosed

var pencil: Pencil = null
var pixel_layer: PixelLayer = null

func _ready() -> void:
	add_input_mouse("doodle", MOUSE_BUTTON_LEFT)
	add_input_mouse("tilt", MOUSE_BUTTON_RIGHT)

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
