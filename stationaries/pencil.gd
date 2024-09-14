extends CharacterBody2D

var move_speed: float = 100

var doodling: bool = false
var tilting: bool = false

var fall_dirn: Vector2 = Vector2.ZERO

var current_state: String
var update_state: bool = false

func _ready() -> void:
	self.global_position = Vector2.ZERO

func _input(event: InputEvent) -> void:
	var new_state: String = 'idle'
	if Input.is_action_pressed("tilt"):
		new_state = "tilt"
	elif Input.is_action_pressed("doodle"):
		new_state = "doodle"
	
	if new_state != current_state:
		current_state = new_state
		update_state = true

func _physics_process(delta: float) -> void:
	if update_state:
		%Animator.play("RESET")
		%Animator.advance(0)
		%Animator.play(current_state)
		update_state = false
