extends Node2D

@onready var main_canvas = $MainMenu
@onready var buttonsGrid = $MainMenu/LevelButtons
@onready var lvl_button_template = \
	preload("res://menu/level_button.tscn")

@export var lvl_1: PackedScene
@export var lvl_2: PackedScene
@export var lvl_3: PackedScene

var levels = []

func _ready():
	init_levels()
	for l in levels:
		var lvl_num = l[0]
		var lvl_scene = l[1]
		var lvl_button = lvl_button_template.instantiate()
		buttonsGrid.add_child(lvl_button)
		lvl_button.set_text(str(lvl_num))
		lvl_button.pressed.connect(func x(): gotoLevel(lvl_scene))
	self.renderBeaten()
	main_canvas.show()
	print("Test")

# auto_loading breaks on html5 export
# for the sake of game jam
# just patch it up like this for now
func init_levels():
	levels.append([1, lvl_1])
	levels.append([2, lvl_2])
	levels.append([3, lvl_3])
	#var dir = DirAccess.open(lvl_scenes_dir)
	#for f in dir.get_files():
		#if lvl_scene_name_regex.search(f):
			#var lvl_scene = load(lvl_scenes_dir + "//" + f)
			#var lvl_digits = f.length()-11 #"Level ".length() - ".tscn".length()
			#var lvl_num = int(f.substr(6,lvl_digits))
			#levels.append([lvl_num, lvl_scene])

func gotoLevel(lvl_scene):
	get_tree().change_scene_to_packed(lvl_scene)

func renderBeaten():
	Global.load_data()
	var levelButtons = buttonsGrid.get_children()
	for index in levelButtons.size():
		var button = levelButtons[index]
		# red_tick
		var cleared = Global.levelsBeaten \
			and (index+1) in Global.levelsBeaten
		var cleared_checkmark = button.get_node("Cleared")
		if cleared_checkmark:
			button.get_child(0).visible = cleared

func _on_clear_beaten_button_pressed():
	Global.levelsBeaten = []
	Global.save_data()
	renderBeaten()

func _on_main_menu_button_pressed():
	main_canvas.show()
