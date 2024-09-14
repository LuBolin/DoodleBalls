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
	area_entered.connect(_on_area_entered)
	Global.line_erased.connect(erase)
	Global.total_squares += 1

# only via gray propagation
func erase():
	#if state != STATE.BLANK:
	if state == STATE.GRAY:
		state = STATE.BLANK

func _on_body_shape_entered(
	body_rid: RID, body: Node,
	body_shape_index: int, local_shape_index: int):
	if body is Eraser:
		if state == STATE.GRAY:
			Global.line_erased.emit()
		elif state == STATE.BLACK:
			state = STATE.BLANK # do not propagate
			Global.squares_shaded -= 1
	elif body is Pencil:
		#if body_shape_index == 0:
			#pass # base collider
		#else: # tip collider
		if body_shape_index == 0:
			if state == STATE.BLANK:
				state = STATE.GRAY
				# Global.pencil.trail.append(self.global_position)
				Global.pencil.add_point_to_line(self.global_position)
				Global.pencil.call_deferred("consolidate")
			if state == STATE.BLACK:
				Global.pencil.add_point_to_line(self.global_position)
				Global.pencil.call_deferred("consolidate")
			elif state == STATE.GRAY:
				var pencil_pos: Vector2 = Global.pencil.global_position
				var pix_layer = Global.pixel_layer
				var self_in_pix_coords = pix_layer.local_to_map(
					pix_layer.to_local(self.global_position))
				var pen_in_pix_coords = pix_layer.local_to_map(
					pix_layer.to_local(pencil_pos))
				if self_in_pix_coords == pen_in_pix_coords:
					Global.enclosed.emit(self.global_position)
	#elif body.name == "PencilFill":
		#state = STATE.BLACK
	#print(body.name)

func _on_area_entered(area: Area2D):
	if area.name == "PencilFill":
		state = STATE.BLACK
		Global.squares_shaded += 1
		#area.call_deferred("queue_free")
