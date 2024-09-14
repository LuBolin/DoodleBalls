extends Node2D

var level_num_regex = RegEx.new()
var level_num: int

func _ready() -> void:
	Global.win.connect(win)
	var level_scene_file_path = get_tree().current_scene.scene_file_path
	# res://levels/Level X.tscn
	level_num_regex.compile("^res://levels/Level (\\d+)\\.tscn$")
	var result = level_num_regex.search(level_scene_file_path)
	if result: # should always be true
		level_num = int(result.get_string(1))

func win():
	Global.levelsBeaten.append(level_num)
	Global.save_data()
	%Cheer.play(0)
	await get_tree().create_timer(2).timeout
	to_menu()

func to_menu():
	var main_menu: PackedScene = load("res://menu/MainMenu.tscn")
	get_tree().change_scene_to_packed(main_menu)
