extends Node

@onready var level: AudioStreamPlayer2D = $level
@onready var menu: AudioStreamPlayer2D = $menu

func _ready():
	get_tree().tree_changed.connect(scene_changed)

func scene_changed():
	# non_singleton_root
	if not get_tree():
		return
	var root = get_tree().root.get_children()[-1]
	if "Level" in root.name:
		level.play()
		menu.stop()
	elif "Main" in root.name:
		level.stop()
		menu.play()
