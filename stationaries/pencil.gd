class_name Pencil extends CharacterBody2D

var move_speed: float = 15000

var doodling: bool = false
var tilting: bool = false

var tilt_dirn: Vector2 = Vector2.ZERO

var current_state: String
var update_state: bool = false

var trail: PackedVector2Array = PackedVector2Array()
var trail_buffer: PackedVector2Array = PackedVector2Array()
func _ready() -> void:
	self.global_position = Vector2.ZERO
	assert(Global.pencil == null)
	Global.pencil = self
	
	Global.line_erased.connect(_erased)
	Global.enclosed.connect(_enclosed)

func _erased():
	trail.clear()
	%Line.clear_points()

func simplify_polygon(points: PackedVector2Array, 
	threshold: float = 0.1) -> PackedVector2Array:
	var simplified_points = PackedVector2Array()
	simplified_points.append(points[0])
	for i in range(1, points.size()):
		if simplified_points[-1].distance_to(points[i]) > threshold:
			simplified_points.append(points[i])
	return simplified_points


func _enclosed():
	var vertices = trail.duplicate()
	trail.clear()
	Global.line_erased.emit()
	
	vertices = simplify_polygon(vertices)
	print(vertices)
	var static_body = StaticBody2D.new()
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = vertices
	static_body.add_child(collision_polygon)
	get_tree().root.call_deferred("add_child", static_body)
	get_tree().create_timer(0.1).timeout.connect(
		static_body.queue_free)

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
	%Line.add_point(position)

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
