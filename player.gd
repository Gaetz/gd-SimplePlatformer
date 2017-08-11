extends KinematicBody2D

# -1 for going left, 1 for going right
var input_direction = 0
var direction = 1

var speed_x = 0
var speed_y = 0
var velocity = Vector2()

const MAX_SPEED_X = 600
const JUMP_FORCE = 800
const GRAVITY = 2000
const ACCELERATION = 1000
const DECELERATION = 2000

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("jump"):
		speed_y = - JUMP_FORCE
	

func _process(delta):
	# Move input
	var is_moving_left = Input.is_action_pressed("move_left")
	var is_moving_right = Input.is_action_pressed("move_right")
	# Input direction choice
	if is_moving_left:
		input_direction = -1
	elif is_moving_right:
		input_direction = 1
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		input_direction = 0
	# Speed_x reducing when changing direction
	if is_moving_left or is_moving_right and input_direction:
		if direction == -input_direction:
			speed_x /= 8
			direction = input_direction
	
	# Motion
	if input_direction:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECELERATION * delta
	speed_x = clamp(speed_x, 0, MAX_SPEED_X)

	speed_y += GRAVITY * delta

	velocity.x = speed_x * delta * direction
	velocity.y = speed_y * delta
	move(velocity)