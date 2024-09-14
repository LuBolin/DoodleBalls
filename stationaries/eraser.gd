class_name Eraser extends RigidBody2D

@export var speed: float = 150

func _ready() -> void:
	var random_angle = randf() * TAU
	var direction = Vector2(cos(random_angle), sin(random_angle))
	linear_velocity = direction * speed
