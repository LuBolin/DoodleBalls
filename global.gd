extends Node

signal win
signal restart
signal escape
signal line_erased
signal enclosed(value: Vector2)
signal push_back

var pencil: Pencil = null
var impact_radius: float = 192.0
var pixel_layer: PixelLayer = null

var levelsBeaten = []

const SAVE_FILE_PATH = "user://saves/LevelsBeaten.dat"

func _ready() -> void:
	var dir = DirAccess.open("user://")
	dir.make_dir("saves")
	add_input_mouse("doodle", MOUSE_BUTTON_LEFT)
	add_input_mouse("slam", MOUSE_BUTTON_RIGHT)

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



func save_data():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	for level in levelsBeaten:
		file.store_16(level)

func load_data():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		while not file.eof_reached():
			levelsBeaten.append(file.get_16())

func _input(event):
	if not (event is InputEventKey):
		return
	if not (event.is_pressed()):
		return
	match event.keycode:
		KEY_R:
			restart.emit()
		KEY_ESCAPE:
			escape.emit()
		KEY_L:
			Global.win.emit()
