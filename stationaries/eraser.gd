class_name Eraser extends RigidBody2D

@export var speed: float = 80

func _ready() -> void:
	var random_angle = randf() * TAU
	var direction = Vector2(cos(random_angle), sin(random_angle))
	linear_velocity = direction * speed

func _process(delta: float) -> void:
	if %SpriteWrapper:
		%SpriteWrapper.look_at(self.global_position + linear_velocity)

func _physics_process(delta: float) -> void:
	if linear_velocity.length() < speed:
		linear_velocity = linear_velocity.normalized() * speed
