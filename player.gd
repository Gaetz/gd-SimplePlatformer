extends KinematicBody2D

# -1 for going left, 1 for going right
var input_direction = 0
var direction = 0

var speed = 0
var ACCELERATION = 1000
var DECELERATION = 2000
var velocity = 0

const MAX_SPEED = 600

func _ready():
	set_process(true)

func _process(delta):
	# Remember last direction
	if input_direction:
		direction = input_direction
	
	# Input direction choice
	if Input.is_action_pressed("ui_left"):
		input_direction = -1
	elif Input.is_action_pressed("ui_right"):
		input_direction = 1
	else:
		input_direction = 0
	
	# Variation
	if(direction == -input_direction):
		speed /= 8
	if input_direction:
		speed += ACCELERATION * delta
	else:
		speed -= DECELERATION * delta
	speed = clamp(speed, 0, MAX_SPEED)
	
	# Motion
	velocity = speed * delta * direction
	move(Vector2(velocity, 0))