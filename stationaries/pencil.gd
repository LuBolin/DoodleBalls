class_name Pencil extends CharacterBody2D

var move_speed: float = 15000

var doodling: bool = false
var tilting: bool = false

var tilt_dirn: Vector2 = Vector2.ZERO

var current_state: String
var update_state: bool = false

var trail: PackedVector2Array = PackedVector2Array()
var trail_buffer = []

func _ready() -> void:
	self.global_position = Vector2.ZERO
	assert(Global.pencil == null)
	Global.pencil = self
	
	Global.line_erased.connect(_erased)
	Global.enclosed.connect(_enclosed)

func _erased():
	trail.clear()
	trail_buffer.clear()

func simplify_polygon(points: PackedVector2Array, 
	threshold: float = 0.1) -> PackedVector2Array:
	var simplified_points = PackedVector2Array()
	simplified_points.append(points[0])
	for i in range(1, points.size()):
		if simplified_points[-1].distance_to(points[i]) > threshold:
			simplified_points.append(points[i])
	return simplified_points

#func consolidate():
	#if trail_buffer.is_empty():
		#return
	#var total: Vector2 = Vector2.ZERO
	#for vec2 in trail_buffer:
		#total += vec2
	#total /= trail_buffer.size()
	#trail.append(total)
	#trail_buffer.clear()

func consolidate():
	if trail_buffer.is_empty():
		return
	var target_pos = self.global_position
	var closest_point = trail_buffer[0]
	var min_distance = target_pos.distance_to(closest_point)
	
	for vec2 in trail_buffer:
		var distance = target_pos.distance_to(vec2)
		if distance < min_distance:
			min_distance = distance
			closest_point = vec2
	trail.append(closest_point)
	
	trail_buffer.clear()

func _enclosed(closure_point: Vector2):
	var vertices = trail.duplicate()
	var closure_index = vertices.find(closure_point)
	if closure_index == -1:
		return
	vertices = vertices.slice(closure_index)
	trail.clear()
	Global.line_erased.emit()
	vertices = simplify_polygon(vertices)
	var area = Area2D.new()
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = vertices
	area.add_child(collision_polygon)
	area.collision_layer = 1
	area.collision_mask = 1
	area.name = "PencilFill"
	get_tree().root.call_deferred("add_child", area)
	get_tree().create_timer(1).timeout.connect(
		area.queue_free
	)


func _input(event: InputEvent) -> void:
	var new_state: String = 'idle'
	if Input.is_action_pressed("tilt"):
		new_state = "tilt"
		var target_global_pos = get_global_mouse_position()
		tilt_dirn = (target_global_pos - global_position).normalized()
	elif Input.is_action_pressed("doodle"):
		new_state = "doodle"
	
	if new_state != current_state:
		current_state = new_state
		update_state = true

func add_point_to_line(position: Vector2):
	trail_buffer.append(position)

func _physics_process(delta: float) -> void:
	if update_state:
		%Animator.play("RESET")
		%Animator.advance(0)
		%Animator.play(current_state)
		update_state = false
	if current_state == "doodle":
		var target_global_pos = get_global_mouse_position()
		var direction = (target_global_pos - global_position).normalized()
		velocity = direction * move_speed * delta
		move_and_slide()
