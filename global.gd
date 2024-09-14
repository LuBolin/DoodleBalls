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

var squares_shaded = 0
var total_squares = 0.0
const WIN_THRESHOLD = 0.72 #percentage hold
const WIN_TIME = 3
var win_timer = WIN_TIME # seconds hold to win

#player variables
const DASH_COOLDOWN = 5
var dash_cd = 0
const SLAM_COOLDOWN = 3
var slam_cd = 0

var levelsBeaten = []

const SAVE_FILE_PATH = "user://saves/LevelsBeaten.dat"

func _ready() -> void:
	var dir = DirAccess.open("user://")
	dir.make_dir("saves")
	add_input_mouse("doodle", MOUSE_BUTTON_LEFT)
	add_input_mouse("tilt", MOUSE_BUTTON_RIGHT)
	squares_shaded = 0
	total_squares = 0
	add_input_mouse("slam", MOUSE_BUTTON_RIGHT)
	add_input_key("dash", KEY_SPACE)

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
	dash_cd -= delta
	slam_cd -= delta
	if (not total_squares == 0):
		if (float(squares_shaded) / total_squares > WIN_THRESHOLD):
			win_timer -= delta
		else:
			win_timer = WIN_TIME
		if win_timer < 0:
			print("you win!")
	



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
