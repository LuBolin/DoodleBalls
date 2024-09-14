class_name Eraser extends RigidBody2D

@export var speed: float = 80

func _ready() -> void:
	var random_angle = randf() * TAU
	var direction = Vector2(cos(random_angle), sin(random_angle))
	linear_velocity = direction * speed
	Global.push_back.connect(_push_back)

func _process(delta: float) -> void:
	if %SpriteWrapper:
		%SpriteWrapper.look_at(self.global_position + linear_velocity)

func _physics_process(delta: float) -> void:
	if linear_velocity.length() < speed:
		linear_velocity = linear_velocity.normalized() * speed

func _push_back():
	var pen_pos = Global.pencil.global_position
	var away_vec = self.global_position - pen_pos
	var dist = away_vec.length()
	if dist > Global.impact_radius:
		return
	apply_force(10000*away_vec.normalized())
