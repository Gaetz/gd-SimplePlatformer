extends KinematicBody2D

# -1 for going left, 1 for going right
var input_direction = 0
var direction = 1

var speed = 0
var ACCELERATION = 1000
var DECELERATION = 2000
var velocity = 0

const MAX_SPEED = 600

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	var is_moving_left = event.is_action_pressed("move_left")
	var is_moving_right = event.is_action_pressed("move_right")
	# Input direction choice
	if is_moving_left:
		input_direction = -1
	elif is_moving_right:
		input_direction = 1
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		input_direction = 0
	# Speed reducing when changing direction
	if is_moving_left or is_moving_right and input_direction:
		if direction == -input_direction:
			speed /= 8
			direction = input_direction

func _process(delta):
	# Variation
	if input_direction:
		speed += ACCELERATION * delta
	else:
		speed -= DECELERATION * delta
	speed = clamp(speed, 0, MAX_SPEED)
	
	# Motion
	velocity = speed * delta * direction
	move(Vector2(velocity, 0))