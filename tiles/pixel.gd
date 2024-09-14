extends Area2D

enum STATE {BLANK, GRAY, BLACK}
var state: STATE = STATE.BLANK :
	set(v):
		state = v
		var rect_2: Rect2
		match state:
			STATE.BLANK:
				rect_2 = Rect2(16, 0, 16, 16)
			STATE.GRAY:
				rect_2 = Rect2(0, 16, 16, 16)
			STATE.BLACK:
				rect_2 = Rect2(16, 16, 16, 16)
		if %Sprite:
			%Sprite.set_region_rect(rect_2)

func _ready() -> void:
	state = STATE.BLANK
	body_shape_entered.connect(_on_body_shape_entered)
	Global.line_erased.connect(erase)

func erase():
	if state != STATE.BLANK:
		state = STATE.BLANK

func _on_body_shape_entered(
	body_rid: RID, body: Node,
	body_shape_index: int, local_shape_index: int):
	if body is Eraser:
		if state != STATE.BLANK:
			Global.line_erased.emit()
	elif body is Pencil:
		if body_shape_index == 0:
			pass # base collider
		else: # tip collider
			if state == STATE.BLANK:
				state = STATE.GRAY
				Global.pencil.trail.append(self.global_position)
				Global.pencil.add_point_to_line(self.global_position)
			elif state == STATE.GRAY:
				var pencil_pos: Vector2 = Global.pencil.global_position
				var pix_layer = Global.pixel_layer
				var self_in_pix_coords = pix_layer.local_to_map(
					pix_layer.to_local(self.global_position))
				var pen_in_pix_coords = pix_layer.local_to_map(
					pix_layer.to_local(pencil_pos))
				if self_in_pix_coords == pen_in_pix_coords:
					Global.enclosed.emit()
	elif body is PencilFill:
		state = STATE.BLACK
