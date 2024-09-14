extends Area2D

enum STATE {BLANK, GRAY, BLACK}
var state: STATE = STATE.BLANK

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is Eraser:
		state = STATE.BLANK
		# emit signal for player to clear all gray
	elif body is PencilTip:
		 #if blank, change to gray
		pass
	elif body is PencilFill:
		 #change to black
		pass
